import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/arena/arena_engine.dart';
import 'package:sphera_flutter/data/arena/arena_models.dart';

Tournament draft(
  int n,
  ArenaStructure s, {
  int leagues = 2,
  int groups = 2,
  int q = 2,
  bool dbl = false,
  bool random = false,
}) =>
    Tournament(
      id: 't1',
      name: 'Cup',
      game: 'eFootball',
      mode: '1v1 Match',
      structure: s,
      leaguesCount: leagues,
      groupsPerLeague: groups,
      qualifiersPerGroup: q,
      doubleRound: dbl,
      randomDraw: random,
      participants: [for (var i = 0; i < n; i++) ArenaParticipant(id: 'p$i', name: 'P$i')],
      createdAt: DateTime(2026, 1, 1),
    );

ArenaMatch confirmed(String id, String h, String a, int hs, int as_, {String group = 'g'}) => ArenaMatch(
      id: id,
      stage: MatchStage.group,
      round: 1,
      slot: 0,
      groupId: group,
      homeId: h,
      awayId: a,
      homeScore: hs,
      awayScore: as_,
      status: MatchStatus.confirmed,
    );

/// Confirms every group match 1-0 to the home side.
Tournament playAllGroups(Tournament t) {
  var cur = t;
  for (final m in t.groupMatches) {
    cur = ArenaEngine.submitResult(cur, m.id, 1, 0);
  }
  return cur;
}

void main() {
  group('round-robin', () {
    test('even count: every pair exactly once, no self-matches', () {
      final rounds = ArenaEngine.roundRobin(['a', 'b', 'c', 'd']);
      expect(rounds.length, 3);
      expect(rounds.every((r) => r.length == 2), isTrue);
      final seen = <String>{};
      for (final r in rounds) {
        for (final p in r) {
          expect(p.home, isNot(p.away));
          final key = ([p.home, p.away]..sort()).join('-');
          expect(seen.add(key), isTrue, reason: 'duplicate fixture $key');
        }
      }
      expect(seen.length, 6);
    });

    test('odd count: byes, nobody plays twice in a round, everyone plays n-1', () {
      final rounds = ArenaEngine.roundRobin(['a', 'b', 'c', 'd', 'e']);
      expect(rounds.length, 5);
      final games = <String, int>{};
      for (final r in rounds) {
        expect(r.length, 2); // one participant rests each round
        final inRound = <String>{};
        for (final p in r) {
          expect(inRound.add(p.home), isTrue);
          expect(inRound.add(p.away), isTrue);
          games[p.home] = (games[p.home] ?? 0) + 1;
          games[p.away] = (games[p.away] ?? 0) + 1;
        }
      }
      expect(games.values.every((g) => g == 4), isTrue);
    });

    test('double round-robin: each ordered pairing once', () {
      final rounds = ArenaEngine.roundRobin(['a', 'b', 'c', 'd'], doubleRound: true);
      final ordered = rounds.expand((r) => r).map((p) => '${p.home}>${p.away}').toList();
      expect(ordered.length, 12);
      expect(ordered.toSet().length, 12);
    });
  });

  group('structure building', () {
    test('single league builds one table with all fixtures', () {
      final t = ArenaEngine.build(draft(6, ArenaStructure.singleLeague));
      expect(t.leagues.length, 1);
      expect(t.leagues.first.groups.length, 1);
      expect(t.groupMatches.length, 15);
    });

    test('multiple leagues with multiple groups', () {
      final t = ArenaEngine.build(draft(16, ArenaStructure.multiLeaguesGroupsKnockout, leagues: 2, groups: 2));
      expect(t.leagues.map((l) => l.name), ['League A', 'League B']);
      expect(t.leagues.first.groups.map((g) => g.name), ['Group A1', 'Group A2']);
      expect(t.leagues.expand((l) => l.groups).every((g) => g.participantIds.length == 4), isTrue);
      expect(t.groupMatches.length, 4 * 6);
      expect(t.knockoutGenerated, isFalse);
    });

    test('manual (seeded) assignment follows entry order; random keeps everyone once', () {
      final seeded = ArenaEngine.build(draft(8, ArenaStructure.groupsOnly, groups: 2));
      expect(seeded.leagues.first.groups.first.participantIds, ['p0', 'p2', 'p4', 'p6']);

      final random = ArenaEngine.build(draft(8, ArenaStructure.groupsOnly, groups: 2, random: true), rng: Random(7));
      final all = random.leagues.first.groups.expand((g) => g.participantIds).toList()..sort();
      expect(all, [for (var i = 0; i < 8; i++) 'p$i']..sort());
    });

    test('validation rejects impossible configurations', () {
      expect(ArenaEngine.validate(draft(3, ArenaStructure.groupsOnly, groups: 2)), isNotEmpty);
      expect(ArenaEngine.validate(draft(8, ArenaStructure.groupsKnockout, groups: 2, q: 5)), isNotEmpty);
      expect(ArenaEngine.validate(draft(1, ArenaStructure.singleLeague)), isNotEmpty);
      expect(ArenaEngine.validate(draft(8, ArenaStructure.groupsKnockout, groups: 2, q: 2)), isEmpty);
      expect(() => ArenaEngine.build(draft(3, ArenaStructure.groupsOnly, groups: 2)), throwsA(isA<ArenaError>()));
    });
  });

  group('knockout', () {
    test('seed order for 8', () {
      expect(ArenaEngine.seedOrder(8), [1, 8, 4, 5, 2, 7, 3, 6]);
    });

    test('byes when the count is not a power of two', () {
      final t = ArenaEngine.build(draft(6, ArenaStructure.knockoutOnly));
      expect(t.knockoutMatches.length, 7); // 4 + 2 + 1 slots
      final byes = t.knockoutMatches.where((m) => m.bye).toList();
      expect(byes.length, 2);
      expect(byes.every((m) => m.isConfirmed), isTrue);
      // Top seeds (p0, p1) are already in round 2.
      final r1 = t.knockoutMatches.where((m) => m.round == 1).toList()..sort((a, b) => a.slot.compareTo(b.slot));
      expect(r1[0].homeId, 'p0');
      expect(r1[1].homeId, 'p1');
    });

    test('winners advance only from confirmed results; champion is the final winner', () {
      var t = ArenaEngine.build(draft(4, ArenaStructure.knockoutOnly));
      final semis = t.knockoutMatches.where((m) => m.round == 0).toList()..sort((a, b) => a.slot.compareTo(b.slot));
      final finalBefore = t.knockoutMatches.firstWhere((m) => m.round == 1);
      expect(finalBefore.homeId, isNull);
      expect(finalBefore.awayId, isNull);

      t = ArenaEngine.submitResult(t, semis[0].id, 2, 0);
      var fin = t.knockoutMatches.firstWhere((m) => m.round == 1);
      expect(fin.homeId, 'p0');
      expect(fin.awayId, isNull); // other semi unconfirmed: nobody advances
      expect(ArenaEngine.champion(t), isNull);

      t = ArenaEngine.submitResult(t, semis[1].id, 1, 3);
      fin = t.knockoutMatches.firstWhere((m) => m.round == 1);
      expect(fin.awayId, 'p2');

      t = ArenaEngine.submitResult(t, fin.id, 1, 0);
      expect(ArenaEngine.champion(t), 'p0');
    });

    test('amending is blocked once the next round was played', () {
      var t = ArenaEngine.build(draft(4, ArenaStructure.knockoutOnly));
      final semis = t.knockoutMatches.where((m) => m.round == 0).toList()..sort((a, b) => a.slot.compareTo(b.slot));
      t = ArenaEngine.submitResult(t, semis[0].id, 2, 0);
      t = ArenaEngine.submitResult(t, semis[1].id, 1, 3);
      // Still allowed before the final is played.
      t = ArenaEngine.submitResult(t, semis[0].id, 3, 0);
      expect(t.audit.last.text, startsWith('Result amended'));
      final fin = t.knockoutMatches.firstWhere((m) => m.round == 1);
      t = ArenaEngine.submitResult(t, fin.id, 1, 0);
      expect(() => ArenaEngine.submitResult(t, semis[0].id, 0, 1), throwsA(isA<ArenaError>()));
    });
  });

  group('result validation', () {
    test('rejects draws in knockout, negatives, byes and unknown matches', () {
      final t = ArenaEngine.build(draft(6, ArenaStructure.knockoutOnly));
      final playable = t.knockoutMatches.firstWhere((m) => m.playable);
      expect(() => ArenaEngine.submitResult(t, playable.id, 1, 1), throwsA(isA<ArenaError>()));
      expect(() => ArenaEngine.submitResult(t, playable.id, -1, 0), throwsA(isA<ArenaError>()));
      final bye = t.knockoutMatches.firstWhere((m) => m.bye);
      expect(() => ArenaEngine.submitResult(t, bye.id, 1, 0), throwsA(isA<ArenaError>()));
      expect(() => ArenaEngine.submitResult(t, 'nope', 1, 0), throwsA(isA<ArenaError>()));
    });

    test('draws are allowed in the group stage', () {
      var t = ArenaEngine.build(draft(4, ArenaStructure.singleLeague));
      t = ArenaEngine.submitResult(t, t.groupMatches.first.id, 2, 2);
      expect(t.groupMatches.first.isConfirmed, isTrue);
    });
  });

  group('standings', () {
    const rules = ArenaRules();

    test('points and goal difference come from confirmed results only', () {
      final pending = ArenaMatch(
        id: 'x',
        stage: MatchStage.group,
        round: 1,
        slot: 0,
        groupId: 'g',
        homeId: 'a',
        awayId: 'b',
        homeScore: 9,
        awayScore: 0,
      ); // scheduled: must be ignored
      final rows = ArenaEngine.standings(
        ['a', 'b', 'c'],
        [confirmed('1', 'a', 'b', 2, 0), confirmed('2', 'b', 'c', 1, 1), pending],
        rules,
      );
      expect(rows.first.id, 'a');
      expect(rows.first.points, 3);
      expect(rows.first.gd, 2);
      final b = rows.firstWhere((r) => r.id == 'b');
      expect(b.points, 1);
      expect(b.played, 2);
    });

    test('goal difference separates teams level on points', () {
      final rows = ArenaEngine.standings(
        ['a', 'b', 'c', 'd'],
        [confirmed('1', 'a', 'c', 3, 0), confirmed('2', 'b', 'd', 1, 0)],
        rules,
      );
      expect(rows[0].id, 'a');
      expect(rows[1].id, 'b');
      expect(rows[1].rankedBy, 'Goal difference');
    });

    test('head-to-head can be the only tiebreaker', () {
      const h2hOnly = ArenaRules(tiebreakers: [Tiebreaker.headToHead]);
      final rows = ArenaEngine.standings(
        ['a', 'b', 'c', 'd'],
        [
          confirmed('1', 'a', 'b', 1, 0),
          confirmed('2', 'b', 'c', 5, 0),
          confirmed('3', 'd', 'a', 1, 0),
        ],
        h2hOnly,
      );
      expect(rows.map((r) => r.id).toList(), ['d', 'a', 'b', 'c']);
      expect(rows[1].rankedBy, 'Head-to-head');
      expect(rows[3].rankedBy, 'Points');
    });

    test('teams level on everything fall back to name order and say so', () {
      // a>b, b>c, c>a, all 1-0: a three-way dead heat.
      final rows = ArenaEngine.standings(
        ['c', 'b', 'a'],
        [confirmed('1', 'a', 'b', 1, 0), confirmed('2', 'b', 'c', 1, 0), confirmed('3', 'c', 'a', 1, 0)],
        rules,
      );
      expect(rows.map((r) => r.id).toList(), ['a', 'b', 'c']);
      expect(rows[1].rankedBy, contains('Level'));
    });

    test('custom points system is respected', () {
      const custom = ArenaRules(pointsWin: 2, pointsDraw: 1, pointsLoss: 0);
      final rows = ArenaEngine.standings(['a', 'b'], [confirmed('1', 'a', 'b', 1, 0)], custom);
      expect(rows.first.points, 2);
    });
  });

  group('groups to knockout', () {
    test('cannot generate before the group stage is complete, nor twice', () {
      final t = ArenaEngine.build(draft(8, ArenaStructure.groupsKnockout, groups: 2));
      expect(() => ArenaEngine.generateKnockout(t), throwsA(isA<ArenaError>()));
      final done = ArenaEngine.generateKnockout(playAllGroups(t));
      expect(() => ArenaEngine.generateKnockout(done), throwsA(isA<ArenaError>()));
    });

    test('cross-group matchups: A1 v B2 and B1 v A2 in opposite halves', () {
      final built = ArenaEngine.build(draft(8, ArenaStructure.groupsKnockout, groups: 2));
      final done = playAllGroups(built);
      final ko = ArenaEngine.generateKnockout(done);
      final groups = ko.leagues.first.groups;
      final a = ArenaEngine.groupStandings(ko, groups[0]).map((r) => r.id).toList();
      final b = ArenaEngine.groupStandings(ko, groups[1]).map((r) => r.id).toList();
      final semis = ko.knockoutMatches.where((m) => m.round == 0).toList()..sort((x, y) => x.slot.compareTo(y.slot));
      expect(semis.length, 2);
      expect([semis[0].homeId, semis[0].awayId], [a[0], b[1]]);
      expect([semis[1].homeId, semis[1].awayId], [b[0], a[1]]);
      expect(ko.knockoutGenerated, isTrue);
    });

    test('group results are locked once the knockout exists; reset clears it', () {
      final ko = ArenaEngine.generateKnockout(
          playAllGroups(ArenaEngine.build(draft(8, ArenaStructure.groupsKnockout, groups: 2))));
      expect(() => ArenaEngine.submitResult(ko, ko.groupMatches.first.id, 0, 5), throwsA(isA<ArenaError>()));
      final reset = ArenaEngine.resetResults(ko);
      expect(reset.knockoutMatches, isEmpty);
      expect(reset.knockoutGenerated, isFalse);
      expect(reset.groupMatches.any((m) => m.isConfirmed), isFalse);
      expect(reset.audit.last.text, contains('reset'));
    });
  });

  group('persistence', () {
    test('tournament survives a JSON round trip', () {
      var t = ArenaEngine.build(draft(8, ArenaStructure.groupsKnockout, groups: 2));
      t = ArenaEngine.submitResult(t, t.groupMatches.first.id, 2, 1);
      final restored = Tournament.fromJson(jsonDecode(jsonEncode(t.toJson())) as Map<String, dynamic>);
      expect(jsonEncode(restored.toJson()), jsonEncode(t.toJson()));
    });
  });
}
