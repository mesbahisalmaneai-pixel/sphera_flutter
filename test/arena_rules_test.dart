import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/arena/arena_engine.dart';
import 'package:sphera_flutter/data/arena/arena_models.dart';

ArenaMatch confirmedMatch(String id, String h, String a, int hs, int as_) => ArenaMatch(
      id: id,
      stage: MatchStage.group,
      round: 1,
      slot: 0,
      groupId: 'g',
      homeId: h,
      awayId: a,
      homeScore: hs,
      awayScore: as_,
      status: MatchStatus.confirmed,
    );

/// 4-player knockout: p0-p3 and p1-p2 semi-finals, then the final.
Tournament knockout(KnockoutDraw rule) => ArenaEngine.build(Tournament(
      id: 't',
      name: 'Cup',
      game: 'eFootball',
      mode: '1v1 Match',
      structure: ArenaStructure.knockoutOnly,
      randomDraw: false,
      rules: ArenaRules(knockoutDraw: rule),
      participants: [for (var i = 0; i < 4; i++) ArenaParticipant(id: 'p$i', name: 'P$i')],
      createdAt: DateTime(2026, 1, 1),
    ));

ArenaMatch semi(Tournament t, int slot) =>
    t.knockoutMatches.firstWhere((m) => m.round == 0 && m.slot == slot);

ArenaMatch finalOf(Tournament t) => t.knockoutMatches.firstWhere((m) => m.round == 1);

Tournament battleRoyale({int rounds = 2, int n = 5, List<int>? table}) => ArenaEngine.build(Tournament(
      id: 'br',
      name: 'BR Cup',
      game: 'Free Fire',
      mode: 'Battle Royale Solo',
      structure: ArenaStructure.singleLeague,
      brRoundsPlanned: rounds,
      brScoring: BrScoring(killPoints: 2, placementPoints: table ?? [10, 6, 0, 0, 0]),
      participants: [for (var i = 0; i < n; i++) ArenaParticipant(id: 'p$i', name: 'P$i')],
      createdAt: DateTime(2026, 1, 1),
    ));

void main() {
  group('knockout draw: penalties (default)', () {
    test('a level score without a shoot-out is refused', () {
      final t = knockout(KnockoutDraw.penalties);
      expect(() => ArenaEngine.submitResult(t, semi(t, 0).id, 1, 1), throwsA(isA<ArenaError>()));
    });

    test('a level shoot-out is refused', () {
      final t = knockout(KnockoutDraw.penalties);
      expect(
        () => ArenaEngine.submitResult(t, semi(t, 0).id, 1, 1, homePens: 3, awayPens: 3),
        throwsA(isA<ArenaError>()),
      );
    });

    test('the shoot-out winner advances and the score keeps the goals apart', () {
      var t = knockout(KnockoutDraw.penalties);
      final m = semi(t, 0);
      t = ArenaEngine.submitResult(t, m.id, 1, 1, homePens: 3, awayPens: 4);
      final done = semi(t, 0);
      expect(done.decidedBy, MatchDecider.penalties);
      expect(done.scoreText, '1-1 (3-4 pens)');
      expect(ArenaEngine.winnerOf(done), done.awayId);
      expect(finalOf(t).homeId, done.awayId);
    });

    test('extra-time flag is ignored when the rule is penalties', () {
      var t = knockout(KnockoutDraw.penalties);
      t = ArenaEngine.submitResult(t, semi(t, 0).id, 2, 1, decidedBy: MatchDecider.extraTime);
      expect(semi(t, 0).decidedBy, MatchDecider.regular);
    });
  });

  group('knockout draw: extra time', () {
    test('a winner after extra time is recorded as a.e.t.', () {
      var t = knockout(KnockoutDraw.extraTime);
      t = ArenaEngine.submitResult(t, semi(t, 0).id, 2, 1, decidedBy: MatchDecider.extraTime);
      expect(semi(t, 0).decidedBy, MatchDecider.extraTime);
      expect(semi(t, 0).scoreText, '2-1 a.e.t.');
    });

    test('still level after extra time goes to penalties', () {
      var t = knockout(KnockoutDraw.extraTime);
      expect(() => ArenaEngine.submitResult(t, semi(t, 0).id, 2, 2), throwsA(isA<ArenaError>()));
      t = ArenaEngine.submitResult(t, semi(t, 0).id, 2, 2, homePens: 5, awayPens: 4);
      expect(semi(t, 0).decidedBy, MatchDecider.penalties);
      expect(ArenaEngine.winnerOf(semi(t, 0)), semi(t, 0).homeId);
    });
  });

  group('knockout draw: replay', () {
    test('a draw sends the match back and nobody advances', () {
      var t = knockout(KnockoutDraw.replay);
      t = ArenaEngine.submitResult(t, semi(t, 0).id, 1, 1);
      final m = semi(t, 0);
      expect(m.status, MatchStatus.scheduled);
      expect(m.homeScore, isNull);
      expect(m.replays.length, 1);
      expect(m.replays.first.home, 1);
      expect(finalOf(t).homeId, isNull);
    });

    test('the replayed match can be won and keeps its history', () {
      var t = knockout(KnockoutDraw.replay);
      t = ArenaEngine.submitResult(t, semi(t, 0).id, 0, 0);
      t = ArenaEngine.submitResult(t, semi(t, 0).id, 2, 0);
      final m = semi(t, 0);
      expect(m.isConfirmed, isTrue);
      expect(m.replays.length, 1);
      expect(finalOf(t).homeId, m.homeId);
    });
  });

  group('standings: head-to-head before goal difference', () {
    // a and b both have 4 pts. b has the far better goal difference,
    // but a beat b in their direct match.
    final matches = [
      confirmedMatch('1', 'a', 'b', 1, 0),
      confirmedMatch('2', 'a', 'c', 0, 0),
      confirmedMatch('3', 'b', 'd', 6, 0),
      confirmedMatch('4', 'b', 'c', 0, 0),
    ];

    test('default order ranks the head-to-head winner first and explains it', () {
      final rows = ArenaEngine.standings(['a', 'b', 'c', 'd'], matches, const ArenaRules());
      expect(rows.map((r) => r.id).toList(), ['a', 'b', 'c', 'd']);
      expect(rows[1].rankedBy, 'Head-to-head');
      expect(rows[1].note, 'Level on 4 pts. Head-to-head: a beat b 1-0 in their direct match.');
      expect(rows[2].rankedBy, 'Points');
      expect(rows[0].note, '');
    });

    test('with goal difference first, the better goal difference wins instead', () {
      const gdFirst = ArenaRules(tiebreakers: [Tiebreaker.goalDifference, Tiebreaker.headToHead]);
      final rows = ArenaEngine.standings(['a', 'b', 'c', 'd'], matches, gdFirst);
      expect(rows.first.id, 'b');
      expect(rows[1].note, contains('Goal difference'));
    });
  });

  group('mode limits', () {
    Tournament make(String game, String mode, List<ArenaParticipant> ps, {int max = 64}) => Tournament(
          id: 't',
          name: 'Cup',
          game: game,
          mode: mode,
          structure: ArenaStructure.singleLeague,
          maxParticipants: max,
          participants: ps,
          createdAt: DateTime(2026, 1, 1),
        );

    List<ArenaParticipant> teams(int count, int players) =>
        [for (var i = 0; i < count; i++) ArenaParticipant(id: 'p$i', name: 'T$i', players: players)];

    test('Clash Squad starts with 2 teams, even of different sizes (2 vs 1)', () {
      for (final mode in ['Clash Squad 2v2', 'Clash Squad 4v4', 'Clash Squad 8v8']) {
        final errors = ArenaEngine.validate(make('Free Fire', mode, [
          const ArenaParticipant(id: 'a', name: 'A', players: 2),
          const ArenaParticipant(id: 'b', name: 'B', players: 1),
        ]));
        expect(errors, isEmpty, reason: mode);
      }
    });

    test('Clash Squad 1v1 needs two players, one team alone is refused', () {
      expect(ArenaEngine.validate(make('Free Fire', 'Clash Squad 1v1', teams(2, 1))), isEmpty);
      expect(ArenaEngine.validate(make('Free Fire', 'Clash Squad 1v1', teams(1, 1))), isNotEmpty);
      expect(ArenaEngine.validate(make('Free Fire', 'Clash Squad 4v4', teams(1, 3))), isNotEmpty);
    });

    test('team size is a maximum per team', () {
      final errors = ArenaEngine.validate(make('Free Fire', 'Clash Squad 2v2', [
        const ArenaParticipant(id: 'a', name: 'A', players: 3),
        const ArenaParticipant(id: 'b', name: 'B', players: 3),
      ]));
      expect(errors.any((e) => e.contains('between 1 and 2')), isTrue);
    });

    test('CO-OP allows teams of 1, 2 or 3 and still needs 6 players in total', () {
      final mixed = ArenaEngine.validate(make('eFootball', 'CO-OP Team', [
        const ArenaParticipant(id: 'a', name: 'A', players: 1),
        const ArenaParticipant(id: 'b', name: 'B', players: 2),
        const ArenaParticipant(id: 'c', name: 'C', players: 3),
      ]));
      expect(mixed, isEmpty);
      final tooFew = ArenaEngine.validate(make('eFootball', 'CO-OP Team', teams(2, 2)));
      expect(tooFew.any((e) => e.contains('6 players')), isTrue);
      final tooBig = ArenaEngine.validate(make('eFootball', 'CO-OP Team', teams(3, 4)));
      expect(tooBig.any((e) => e.contains('between 1 and 3')), isTrue);
    });

    test('PvP has no 6-player rule', () {
      expect(ArenaEngine.validate(make('eFootball', 'PvP', teams(2, 1))), isEmpty);
    });

    test('Battle Royale caps: solo 48 players, duo 24 teams, squad 12 teams', () {
      List<String> run(String mode, int count, int players) {
        final n = count;
        return ArenaEngine.validate(Tournament(
          id: 't',
          name: 'Cup',
          game: 'Free Fire',
          mode: mode,
          structure: ArenaStructure.singleLeague,
          maxParticipants: 100,
          brScoring: BrScoring.forSlots(n),
          participants: teams(count, players),
          createdAt: DateTime(2026, 1, 1),
        ));
      }

      expect(run('Battle Royale Solo', 48, 1), isEmpty);
      expect(run('Battle Royale Solo', 49, 1).any((e) => e.contains('at most 48')), isTrue);
      expect(run('Battle Royale Duo', 24, 2), isEmpty);
      expect(run('Battle Royale Duo', 25, 2).any((e) => e.contains('at most 24')), isTrue);
      expect(run('Battle Royale Squad', 12, 4), isEmpty);
      expect(run('Battle Royale Squad', 13, 4).any((e) => e.contains('at most 12')), isTrue);
    });

    test('Battle Royale teams must be complete', () {
      final errors = ArenaEngine.validate(Tournament(
        id: 't',
        name: 'Cup',
        game: 'Free Fire',
        mode: 'Battle Royale Duo',
        structure: ArenaStructure.singleLeague,
        brScoring: BrScoring.forSlots(4),
        participants: [
          for (var i = 0; i < 4; i++) ArenaParticipant(id: 'p$i', name: 'T$i', players: i == 0 ? 1 : 2)
        ],
        createdAt: DateTime(2026, 1, 1),
      ));
      expect(errors.any((e) => e.contains('exactly 2 players')), isTrue);
    });

    test('Battle Royale needs a valid placement table before it can start', () {
      expect(() => battleRoyale(n: 3, table: [5, 0, 0]), throwsA(isA<ArenaError>())); // fewer than 4
      expect(() => battleRoyale(table: [10, 6, 0, 0]), throwsA(isA<ArenaError>())); // wrong length
      expect(() => battleRoyale(table: [10, 6, 3, 0, 0]), throwsA(isA<ArenaError>())); // tail not 0
    });
  });

  group('goals against tiebreaker', () {
    test('fewer goals conceded ranks higher when it is the criterion', () {
      const ga = ArenaRules(tiebreakers: [Tiebreaker.goalsAgainst]);
      final rows = ArenaEngine.standings(
        ['a', 'b', 'c', 'd'],
        [confirmedMatch('1', 'a', 'c', 1, 0), confirmedMatch('2', 'b', 'd', 3, 1)],
        ga,
      );
      expect(rows[0].id, 'a');
      expect(rows[1].id, 'b');
      expect(rows[1].rankedBy, 'Goals against');
    });
  });

  group('battle royale', () {
    Map<String, BrResult> round(List<List<int>> placeKills) => {
          for (var i = 0; i < placeKills.length; i++)
            'p$i': BrResult(placement: placeKills[i][0], kills: placeKills[i][1]),
        };

    test('build creates the planned rounds and no fixtures', () {
      final t = battleRoyale(rounds: 3);
      expect(t.brRounds.length, 3);
      expect(t.matches, isEmpty);
      expect(t.brRounds.every((r) => !r.confirmed), isTrue);
    });

    test('placements must be unique, in range and complete', () {
      final t = battleRoyale();
      final id = t.brRounds.first.id;
      expect(() => ArenaEngine.brSubmitRound(t, id, round([[1, 0], [1, 0], [3, 0], [4, 0], [5, 0]])),
          throwsA(isA<ArenaError>()));
      expect(() => ArenaEngine.brSubmitRound(t, id, round([[1, 0], [2, 0], [3, 0], [4, 0], [6, 0]])),
          throwsA(isA<ArenaError>()));
      expect(() => ArenaEngine.brSubmitRound(t, id, round([[1, 0], [2, 0], [3, 0]])),
          throwsA(isA<ArenaError>()));
      expect(() => ArenaEngine.brSubmitRound(t, id, round([[1, -1], [2, 0], [3, 0], [4, 0], [5, 0]])),
          throwsA(isA<ArenaError>()));
    });

    test('table is placement points plus kills x 2; champion only when all rounds are in', () {
      var t = battleRoyale();
      t = ArenaEngine.brSubmitRound(t, t.brRounds[0].id, round([[1, 3], [2, 2], [3, 0], [4, 1], [5, 0]]));
      var rows = ArenaEngine.brStandings(t);
      expect(rows.map((r) => r.id).toList(), ['p0', 'p1', 'p3', 'p2', 'p4']);
      expect(rows.map((r) => r.points).toList(), [16, 10, 2, 0, 0]);
      expect(ArenaEngine.champion(t), isNull);

      t = ArenaEngine.brSubmitRound(t, t.brRounds[1].id, round([[2, 0], [1, 2], [3, 0], [4, 0], [5, 0]]));
      rows = ArenaEngine.brStandings(t);
      expect(rows.first.id, 'p1');
      expect(rows.first.points, 24);
      expect(rows.first.placementPts, 16); // 6 + 10
      expect(rows.first.killPts, 8); // 4 kills x 2
      expect(rows.first.kills, 4);
      expect(rows[1].rankedBy, 'Points');
      expect(ArenaEngine.champion(t), 'p1');
    });

    test('level points are split by wins, and the table says so', () {
      var t = battleRoyale(rounds: 1);
      // p0: 10 pts (1st, 0 kills). p1: 6 + 2 kills x 2 = 10 pts (2nd).
      t = ArenaEngine.brSubmitRound(t, t.brRounds[0].id, round([[1, 0], [2, 2], [3, 0], [4, 0], [5, 0]]));
      final rows = ArenaEngine.brStandings(t);
      expect(rows[0].id, 'p0');
      expect(rows[1].rankedBy, 'Wins');
      expect(rows[1].note, contains('Wins'));
    });

    test('reset clears the rounds', () {
      var t = battleRoyale(rounds: 1);
      t = ArenaEngine.brSubmitRound(t, t.brRounds[0].id, round([[1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]));
      t = ArenaEngine.resetResults(t);
      expect(t.brRounds.single.confirmed, isFalse);
      expect(t.brRounds.single.results, isEmpty);
    });
  });

  group('clash squad is decided by the winner', () {
    Tournament cs({List<StatColumn>? cols}) => ArenaEngine.build(Tournament(
          id: 'c',
          name: 'CS',
          game: 'Free Fire',
          mode: 'Clash Squad 4v4',
          structure: ArenaStructure.singleLeague,
          randomDraw: false,
          standingsColumns: cols ?? ArenaGameMode.cs4v4.defaultColumns,
          participants: [for (var i = 0; i < 3; i++) ArenaParticipant(id: 't$i', name: 'T$i', players: 2)],
          createdAt: DateTime(2026, 1, 1),
        ));

    ArenaMatch firstMatch(Tournament t) => t.matches.firstWhere((m) => !m.bye);

    test('picking the winner confirms the match and gives the points', () {
      var t = cs();
      final m = firstMatch(t);
      t = ArenaEngine.submitWinner(t, m.id, m.awayId!);
      final done = t.matches.firstWhere((x) => x.id == m.id);
      expect(done.isConfirmed, isTrue);
      expect(ArenaEngine.winnerOf(done), m.awayId);
      final rows = ArenaEngine.groupStandings(t, t.leagues.first.groups.first);
      final winner = rows.firstWhere((r) => r.id == m.awayId);
      final loser = rows.firstWhere((r) => r.id == m.homeId);
      expect(winner.won, 1);
      expect(winner.points, 3);
      expect(loser.lost, 1);
      expect(loser.points, 0);
      expect(rows.every((r) => r.drawn == 0), isTrue);
      expect(rows.first.id, m.awayId);
    });

    test('the winner must be one of the two sides', () {
      final t = cs();
      final m = firstMatch(t);
      final other = ['t0', 't1', 't2'].firstWhere((id) => id != m.homeId && id != m.awayId);
      expect(() => ArenaEngine.submitWinner(t, m.id, other), throwsA(isA<ArenaError>()));
    });

    test('other games are scored with results, not by picking a winner', () {
      final t = ArenaEngine.build(Tournament(
        id: 'e',
        name: 'E',
        game: 'eFootball',
        mode: 'PvP',
        structure: ArenaStructure.singleLeague,
        participants: [for (var i = 0; i < 2; i++) ArenaParticipant(id: 'x$i', name: 'X$i')],
        createdAt: DateTime(2026, 1, 1),
      ));
      final m = firstMatch(t);
      expect(() => ArenaEngine.submitWinner(t, m.id, m.homeId!), throwsA(isA<ArenaError>()));
    });

    test('ranking has no draws and no goal tie-breakers', () {
      final rules = ArenaEngine.effectiveRules(cs());
      expect(rules.tiebreakers, [Tiebreaker.headToHead]);
      expect(rules.pointsDraw, 0);
    });

    test('goal columns are refused for Clash Squad', () {
      expect(() => cs(cols: [StatColumn.goalDifference]), throwsA(isA<ArenaError>()));
    });
  });
}
