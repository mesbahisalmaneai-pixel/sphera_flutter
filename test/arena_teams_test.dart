import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/arena/arena_engine.dart';
import 'package:sphera_flutter/data/arena/arena_models.dart';

ArenaParticipant team(String id, List<String> players) => ArenaParticipant(
      id: id,
      name: 'Team $id',
      roster: [for (final p in players) ArenaPlayer(id: p, name: p.toUpperCase())],
    );

/// Clash Squad 4v4 with three teams (6 players in total, unequal allowed).
Tournament clash({List<ArenaParticipant>? teams, String mode = 'Clash Squad 4v4'}) =>
    ArenaEngine.build(Tournament(
      id: 't',
      name: 'Cup',
      game: 'Free Fire',
      mode: mode,
      structure: ArenaStructure.singleLeague,
      randomDraw: false,
      participants: teams ??
          [
            team('A', ['p1', 'p2']),
            team('B', ['p3', 'p4']),
            team('C', ['p5', 'p6']),
          ],
      createdAt: DateTime(2026, 1, 1),
    ));

List<String> names(Tournament t, String teamId) =>
    t.participants.firstWhere((p) => p.id == teamId).roster.map((p) => p.name).toList();

Tournament playOneMatchOf(Tournament t, String teamId) {
  final m = t.matches.firstWhere((m) => !m.bye && (m.homeId == teamId || m.awayId == teamId));
  return ArenaEngine.submitResult(t, m.id, 1, 0);
}

void main() {
  group('unequal teams', () {
    test('2v2, 4v4 and 8v8 accept teams of different sizes', () {
      for (final mode in ['Clash Squad 2v2', 'Clash Squad 4v4', 'Clash Squad 8v8']) {
        final t = clash(mode: mode, teams: [
          team('A', ['p1', 'p2']),
          team('B', ['p3']),
          team('C', ['p4', 'p5', 'p6'].take(mode == 'Clash Squad 2v2' ? 2 : 3).toList()),
          team('D', ['p7', 'p8']),
        ]);
        expect(ArenaEngine.validate(t), isEmpty, reason: mode);
      }
    });

    test('no fake players are added: a one-player team stays at one', () {
      final t = clash(teams: [
        team('A', ['p1', 'p2', 'p3']),
        team('B', ['p4']),
        team('C', ['p5', 'p6']),
      ]);
      expect(t.participants.firstWhere((p) => p.id == 'B').players, 1);
    });

    test('1v1 has one player per side', () {
      final t = clash(mode: 'Clash Squad 1v1', teams: [
        for (var i = 1; i <= 6; i++) ArenaParticipant(id: 's$i', name: 'S$i'),
      ]);
      expect(t.participants.every((p) => p.players == 1), isTrue);
      expect(ArenaEngine.swapParticipants(t, 's1', 's2').participants.first.id, 's2');
    });
  });

  group('swap players', () {
    test('cross-team swap from the specification', () {
      final t = clash(teams: [
        team('A', ['p1', 'p2']),
        team('B', ['p3', 'p4']),
        team('C', ['p5', 'p6']),
      ]);
      final after = ArenaEngine.swapPlayers(t, 'A', 'p1', 'B', 'p3');
      expect(names(after, 'A'), ['P3', 'P2']);
      expect(names(after, 'B'), ['P1', 'P4']);
      expect(names(after, 'C'), ['P5', 'P6']);
      expect(after.participants.firstWhere((p) => p.id == 'A').players, 2);
      expect(after.participants.firstWhere((p) => p.id == 'B').players, 2);
      // identities are kept
      expect(after.participants.firstWhere((p) => p.id == 'A').roster.first.id, 'p3');
      expect(ArenaEngine.validate(after), isEmpty);
    });

    test('swapping inside one team only reorders it', () {
      final after = ArenaEngine.swapPlayers(clash(), 'A', 'p1', 'A', 'p2');
      expect(names(after, 'A'), ['P2', 'P1']);
    });

    test('unknown players and identical players are refused', () {
      final t = clash();
      expect(() => ArenaEngine.swapPlayers(t, 'A', 'nope', 'B', 'p3'), throwsA(isA<ArenaError>()));
      expect(() => ArenaEngine.swapPlayers(t, 'A', 'p1', 'A', 'p1'), throwsA(isA<ArenaError>()));
      expect(() => ArenaEngine.swapPlayers(t, 'A', 'p1', 'Z', 'p3'), throwsA(isA<ArenaError>()));
    });

    test('refused once one of the teams has played', () {
      final t = playOneMatchOf(clash(), 'A');
      expect(() => ArenaEngine.swapPlayers(t, 'A', 'p1', 'B', 'p3'), throwsA(isA<ArenaError>()));
    });

    test('solo modes have no rosters to swap', () {
      final t = ArenaEngine.build(Tournament(
        id: 't',
        name: 'Cup',
        game: 'eFootball',
        mode: 'PvP',
        structure: ArenaStructure.singleLeague,
        participants: [for (var i = 0; i < 4; i++) ArenaParticipant(id: 'x$i', name: 'X$i')],
        createdAt: DateTime(2026, 1, 1),
      ));
      expect(() => ArenaEngine.swapPlayers(t, 'x0', 'a', 'x1', 'b'), throwsA(isA<ArenaError>()));
    });
  });

  group('swap teams', () {
    test('positions, groups and fixtures are exchanged and rosters stay with their team', () {
      final before = clash();
      final after = ArenaEngine.swapParticipants(before, 'A', 'B');
      String? sw(String? id) => id == 'A' ? 'B' : (id == 'B' ? 'A' : id);
      expect(after.participants.map((p) => p.id).toList(), ['B', 'A', 'C']);
      expect(names(after, 'A'), ['P1', 'P2']);
      expect(names(after, 'B'), ['P3', 'P4']);
      for (var i = 0; i < before.matches.length; i++) {
        expect(after.matches[i].homeId, sw(before.matches[i].homeId));
        expect(after.matches[i].awayId, sw(before.matches[i].awayId));
      }
      expect(after.leagues.first.groups.first.participantIds,
          before.leagues.first.groups.first.participantIds.map(sw).toList());
    });

    test('swapping a team with itself or an unknown team is refused', () {
      final t = clash();
      expect(() => ArenaEngine.swapParticipants(t, 'A', 'A'), throwsA(isA<ArenaError>()));
      expect(() => ArenaEngine.swapParticipants(t, 'A', 'Z'), throwsA(isA<ArenaError>()));
    });

    test('refused once one of the teams has played', () {
      final t = playOneMatchOf(clash(), 'A');
      expect(() => ArenaEngine.swapParticipants(t, 'A', 'C'), throwsA(isA<ArenaError>()));
    });
  });

  group('edit rosters', () {
    test('add, rename and remove players inside the size limit', () {
      var t = clash();
      final a = t.participants.firstWhere((p) => p.id == 'A');
      t = ArenaEngine.setRoster(t, 'A', [...a.roster, const ArenaPlayer(id: 'p7', name: 'P7')]);
      expect(names(t, 'A'), ['P1', 'P2', 'P7']);
      t = ArenaEngine.setRoster(t, 'A', [for (final p in t.participants.first.roster) p.id == 'p1' ? p.copyWith(name: 'Zed') : p]);
      expect(names(t, 'A'), ['Zed', 'P2', 'P7']);
    });

    test('refuses empty rosters, too many players, empty names and duplicates', () {
      final t = clash();
      expect(() => ArenaEngine.setRoster(t, 'A', const []), throwsA(isA<ArenaError>()));
      expect(
        () => ArenaEngine.setRoster(t, 'A', [for (var i = 0; i < 5; i++) ArenaPlayer(id: 'n$i', name: 'N$i')]),
        throwsA(isA<ArenaError>()),
      );
      expect(() => ArenaEngine.setRoster(t, 'A', const [ArenaPlayer(id: 'x', name: ' ')]),
          throwsA(isA<ArenaError>()));
      // same name as a player of another team
      expect(() => ArenaEngine.setRoster(t, 'A', const [ArenaPlayer(id: 'x', name: 'p3')]),
          throwsA(isA<ArenaError>()));
      // same player id as a player of another team
      expect(() => ArenaEngine.setRoster(t, 'A', const [ArenaPlayer(id: 'p3', name: 'Other')]),
          throwsA(isA<ArenaError>()));
    });

    test('rename refuses duplicates and empty names', () {
      final t = clash();
      expect(ArenaEngine.renameParticipant(t, 'A', 'Falcons').participants.first.name, 'Falcons');
      expect(() => ArenaEngine.renameParticipant(t, 'A', 'team b'), throwsA(isA<ArenaError>()));
      expect(() => ArenaEngine.renameParticipant(t, 'A', '  '), throwsA(isA<ArenaError>()));
    });

    test('validation flags a player assigned to two teams', () {
      final t = Tournament(
        id: 't',
        name: 'Cup',
        game: 'Free Fire',
        mode: 'Clash Squad 4v4',
        structure: ArenaStructure.singleLeague,
        participants: [
          team('A', ['p1', 'p2', 'p3']),
          team('B', ['p3', 'p4', 'p5']),
        ],
        createdAt: DateTime(2026, 1, 1),
      );
      expect(ArenaEngine.validate(t).any((e) => e.contains('assigned twice')), isTrue);
    });
  });

  group('battle royale duo', () {
    Tournament duo() => ArenaEngine.build(Tournament(
          id: 'b',
          name: 'BR',
          game: 'Free Fire',
          mode: 'Battle Royale Duo',
          structure: ArenaStructure.singleLeague,
          brRoundsPlanned: 1,
          brScoring: BrScoring.forSlots(4),
          participants: [for (var i = 0; i < 4; i++) team('T$i', ['a$i', 'b$i'])],
          createdAt: DateTime(2026, 1, 1),
        ));

    test('duo teams keep exactly 2 players, but players can be swapped', () {
      var t = duo();
      expect(() => ArenaEngine.setRoster(t, 'T0', [t.participants.first.roster.first]), throwsA(isA<ArenaError>()));
      t = ArenaEngine.swapPlayers(t, 'T0', 'a0', 'T1', 'b1');
      expect(names(t, 'T0'), ['B1', 'B0']);
      expect(names(t, 'T1'), ['A1', 'A0']);
    });

    test('rosters are locked once a round is confirmed', () {
      var t = duo();
      t = ArenaEngine.brSubmitRound(t, t.brRounds.first.id, {
        for (var i = 0; i < 4; i++) 'T$i': BrResult(placement: i + 1),
      });
      expect(() => ArenaEngine.swapPlayers(t, 'T0', 'a0', 'T1', 'b1'), throwsA(isA<ArenaError>()));
      // swapping team positions does not touch results, so it stays possible
      expect(ArenaEngine.swapParticipants(t, 'T0', 'T1').participants.first.id, 'T1');
    });
  });

  group('persistence', () {
    test('rosters survive JSON and old tournaments without rosters still load', () {
      final t = clash();
      final back = Tournament.fromJson(t.toJson());
      expect(names(back, 'A'), ['P1', 'P2']);
      expect(back.participants.first.roster.first.id, 'p1');
      final old = ArenaParticipant.fromJson({'id': 'x', 'name': 'Old', 'n': 3});
      expect(old.roster, isEmpty);
      expect(old.players, 3);
    });

    test('a swap is still there after saving and loading', () {
      final swapped = ArenaEngine.swapPlayers(clash(), 'A', 'p1', 'B', 'p3');
      final back = Tournament.fromJson(swapped.toJson());
      expect(names(back, 'A'), ['P3', 'P2']);
      expect(names(back, 'B'), ['P1', 'P4']);
    });
  });
}
