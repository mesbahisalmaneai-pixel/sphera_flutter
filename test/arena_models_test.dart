import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/arena/arena_models.dart';

void main() {
  group('game modes', () {
    test('Free Fire offers Battle Royale and Clash Squad; eFootball offers PvP and CO-OP', () {
      expect(ArenaGameMode.games, ['Free Fire', 'eFootball']);
      expect(ArenaGameMode.typesFor('Free Fire'), ['Battle Royale', 'Clash Squad']);
      expect(ArenaGameMode.typesFor('eFootball'), ['PvP', 'CO-OP Team']);
      expect(ArenaGameMode.ofType('Free Fire', 'Battle Royale').map((m) => m.short), ['Solo', 'Duo', 'Squad']);
      expect(ArenaGameMode.ofType('Free Fire', 'Clash Squad').map((m) => m.short),
          ['1v1', '2v2', '4v4', '8v8']);
    });

    test('Battle Royale limits', () {
      expect(ArenaGameMode.brSolo.maxParticipants, 48);
      expect(ArenaGameMode.brDuo.maxParticipants, 24);
      expect(ArenaGameMode.brDuo.teamSize, 2);
      expect(ArenaGameMode.brSquad.maxParticipants, 12);
      expect(ArenaGameMode.brSquad.teamSize, 4);
      // 48 players in every BR mode.
      for (final m in ArenaGameMode.ofType('Free Fire', 'Battle Royale')) {
        expect(m.maxParticipants! * m.teamSize, 48);
        expect(m.isBattleRoyale, isTrue);
      }
    });

    test('Clash Squad needs 2 teams, no player minimum; CO-OP keeps its 6-player rule', () {
      for (final m in ArenaGameMode.ofType('Free Fire', 'Clash Squad')) {
        expect(m.minTotalPlayers, 0);
        expect(m.minParticipants, 2);
        expect(m.fixedTeamSize, isFalse);
        expect(m.format, ArenaFormat.headToHead);
      }
      expect(ArenaGameMode.cs1v1.teamSize, 1);
      expect(ArenaGameMode.cs2v2.teamSize, 2);
      expect(ArenaGameMode.cs4v4.teamSize, 4);
      expect(ArenaGameMode.cs8v8.teamSize, 8);
      expect(ArenaGameMode.efootballCoop.teamSize, 3);
      expect(ArenaGameMode.efootballCoop.minTotalPlayers, 6);
      expect(ArenaGameMode.efootballPvp.teamSize, 1);
    });

    test('Clash Squad is decided by the winner: no goal columns. eFootball and Battle Royale are not', () {
      for (final m in ArenaGameMode.ofType('Free Fire', 'Clash Squad')) {
        expect(m.winnerOnly, isTrue);
        expect(m.standingColumns,
            [StatColumn.played, StatColumn.won, StatColumn.lost, StatColumn.points]);
        expect(m.defaultColumns, m.standingColumns);
      }
      expect(ArenaGameMode.efootballPvp.winnerOnly, isFalse);
      expect(ArenaGameMode.efootballPvp.standingColumns, StatColumn.values);
      expect(ArenaGameMode.efootballPvp.defaultColumns, kDefaultStandingColumns);
      expect(ArenaGameMode.brSolo.winnerOnly, isFalse);
    });

    test('labels are unique per game and legacy labels still resolve', () {
      final keys = ArenaGameMode.all.map((m) => '${m.game}/${m.label}').toSet();
      expect(keys.length, ArenaGameMode.all.length);
      expect(ArenaGameMode.find('eFootball', '1v1 Match'), isNotNull);
      expect(ArenaGameMode.find('Free Fire', 'Clash Squad (custom team size)'), isNotNull);
      expect(ArenaGameMode.find('Free Fire', 'Clash Squad 4v4'), isNotNull);
      expect(ArenaGameMode.find('eFootball', '1v1 Match')!.minTotalPlayers, 0);
    });
  });

  group('rules', () {
    test('head-to-head is applied before goal difference by default', () {
      const rules = ArenaRules();
      expect(rules.tiebreakers.first, Tiebreaker.headToHead);
      expect(rules.tiebreakers.indexOf(Tiebreaker.headToHead),
          lessThan(rules.tiebreakers.indexOf(Tiebreaker.goalDifference)));
    });

    test('classic preset is GD, H2H, GF, GA', () {
      expect(kTiebreakClassic, [
        Tiebreaker.goalDifference,
        Tiebreaker.headToHead,
        Tiebreaker.goalsScored,
        Tiebreaker.goalsAgainst,
      ]);
    });

    test('knockout draw rule defaults to penalties and survives JSON', () {
      expect(const ArenaRules().knockoutDraw, KnockoutDraw.penalties);
      final back = ArenaRules.fromJson(const ArenaRules(knockoutDraw: KnockoutDraw.replay).toJson());
      expect(back.knockoutDraw, KnockoutDraw.replay);
    });

    test('old saved rules without the knockout key load with penalties', () {
      final back = ArenaRules.fromJson({'w': 3, 'd': 1, 'l': 0, 'tb': ['goalDifference']});
      expect(back.knockoutDraw, KnockoutDraw.penalties);
      expect(back.tiebreakers, [Tiebreaker.goalDifference]);
    });
  });

  group('knockout match result', () {
    ArenaMatch match({int? hs, int? as_, int? hp, int? ap, MatchDecider by = MatchDecider.regular}) =>
        ArenaMatch(
          id: 'm',
          stage: MatchStage.knockout,
          round: 0,
          slot: 0,
          homeId: 'a',
          awayId: 'b',
          homeScore: hs,
          awayScore: as_,
          homePens: hp,
          awayPens: ap,
          decidedBy: by,
          status: MatchStatus.confirmed,
        );

    test('normal win', () {
      expect(match(hs: 2, as_: 1).winnerId, 'a');
      expect(match(hs: 2, as_: 1).scoreText, '2-1');
    });

    test('level score decided on penalties', () {
      final m = match(hs: 1, as_: 1, hp: 3, ap: 4, by: MatchDecider.penalties);
      expect(m.winnerId, 'b');
      expect(m.scoreText, '1-1 (3-4 pens)');
      expect(m.wentToPenalties, isTrue);
    });

    test('level score with no tie-break has no winner', () {
      expect(match(hs: 0, as_: 0).winnerId, isNull);
    });

    test('match survives JSON including penalties and replay history', () {
      final m = match(hs: 2, as_: 2, hp: 5, ap: 4, by: MatchDecider.penalties)
          .copyWith(replays: const [ScoreLine(1, 1)]);
      final back = ArenaMatch.fromJson(m.toJson());
      expect(back.homePens, 5);
      expect(back.awayPens, 4);
      expect(back.decidedBy, MatchDecider.penalties);
      expect(back.replays.single.home, 1);
      expect(back.winnerId, 'a');
    });

    test('old saved matches without the new keys still load', () {
      final back = ArenaMatch.fromJson({
        'id': 'x',
        'stage': 'knockout',
        'round': 0,
        'slot': 0,
        'status': 'scheduled',
      });
      expect(back.decidedBy, MatchDecider.regular);
      expect(back.replays, isEmpty);
    });
  });

  group('battle royale scoring', () {
    const scoring = BrScoring(killPoints: 2, placementPoints: [12, 9, 8, 7, 0, 0, 0]);

    test('total = placement points + kills x 2, shown in two parts', () {
      const r = BrResult(placement: 1, kills: 5);
      expect(scoring.placementPointsFor(1), 12);
      expect(scoring.killPointsFor(r), 10);
      expect(scoring.pointsFor(r), 22);
      expect(scoring.pointsFor(const BrResult(placement: 4, kills: 0)), 7);
    });

    test('kills are worth 2 points by default', () {
      expect(const BrScoring().killPoints, 2);
    });

    test('placements outside the table score only kills', () {
      expect(scoring.pointsFor(const BrResult(placement: 20, kills: 3)), 6);
    });

    test('default table has one row per slot and zeros for the last three', () {
      for (final n in [4, 5, 10, 12, 24, 48]) {
        final table = BrScoring.defaultTable(n);
        expect(table.length, n);
        expect(table.skip(n - 3).every((p) => p == 0), isTrue, reason: 'n=$n');
        expect(table.first, greaterThan(0));
        expect(BrScoring.forSlots(n).validate(n), isEmpty, reason: 'n=$n');
      }
    });

    test('validation catches an inconsistent table', () {
      expect(const BrScoring(placementPoints: [10, 5, 0, 0, 0]).validate(6), isNotEmpty); // wrong length
      expect(const BrScoring(placementPoints: [10, 5, 3, 0, 0]).validate(5), isNotEmpty); // tail not zero
      expect(const BrScoring(placementPoints: [5, 8, 0, 0, 0]).validate(5), isNotEmpty); // increasing
      expect(const BrScoring(placementPoints: [0, 0, 0, 0, 0]).validate(5), isNotEmpty); // 1st scores 0
      expect(const BrScoring(placementPoints: [10, 5, 0, 0, 0]).validate(5), isEmpty);
    });

    test('scoring and rounds survive JSON', () {
      final back = BrScoring.fromJson(scoring.toJson());
      expect(back.killPoints, 2);
      expect(back.placementPoints, [12, 9, 8, 7, 0, 0, 0]);
      final r = BrRound(
        id: 'r1',
        number: 1,
        results: const {'a': BrResult(placement: 1, kills: 4)},
        confirmed: true,
      );
      final round = BrRound.fromJson(r.toJson());
      expect(round.results['a']!.kills, 4);
      expect(round.confirmed, isTrue);
    });
  });

  group('tournament', () {
    Tournament t(String game, String mode) => Tournament(
          id: 't',
          name: 'T',
          game: game,
          mode: mode,
          structure: ArenaStructure.singleLeague,
          createdAt: DateTime(2026, 1, 1),
        );

    test('format follows the mode and old tournaments default to head-to-head', () {
      expect(t('Free Fire', 'Battle Royale Squad').isBattleRoyale, isTrue);
      expect(t('eFootball', 'CO-OP Team').isBattleRoyale, isFalse);
      expect(t('Other', 'Unknown').format, ArenaFormat.headToHead);
    });

    test('battle royale fields survive JSON', () {
      final tour = Tournament(
        id: 't',
        name: 'T',
        game: 'Free Fire',
        mode: 'Battle Royale Solo',
        structure: ArenaStructure.singleLeague,
        createdAt: DateTime(2026, 1, 1),
        brRoundsPlanned: 5,
        brRounds: const [BrRound(id: 'r1', number: 1)],
        brScoring: const BrScoring(placementPoints: [5, 0, 0, 0]),
      );
      final back = Tournament.fromJson(tour.toJson());
      expect(back.brRoundsPlanned, 5);
      expect(back.brRounds.single.number, 1);
      expect(back.brScoring.killPoints, 2);
      expect(back.brScoring.placementPoints, [5, 0, 0, 0]);
    });

    test('standings columns default, round-trip, and old tournaments load the default', () {
      expect(t('eFootball', 'PvP').standingsColumns, kDefaultStandingColumns);
      final custom = Tournament(
        id: 't',
        name: 'T',
        game: 'eFootball',
        mode: 'PvP',
        structure: ArenaStructure.singleLeague,
        createdAt: DateTime(2026, 1, 1),
        standingsColumns: const [StatColumn.won, StatColumn.goalsFor, StatColumn.points],
      );
      expect(Tournament.fromJson(custom.toJson()).standingsColumns,
          [StatColumn.won, StatColumn.goalsFor, StatColumn.points]);
      final old = custom.toJson()..remove('cols');
      expect(Tournament.fromJson(old).standingsColumns, kDefaultStandingColumns);
      expect(StatColumn.values.length, kMaxStandingColumns);
    });

    test('participants remember how many players they stand for', () {
      const p = ArenaParticipant(id: 'x', name: 'Team', players: 3);
      expect(ArenaParticipant.fromJson(p.toJson()).players, 3);
      expect(ArenaParticipant.fromJson({'id': 'x', 'name': 'Old'}).players, 1);
    });
  });
}
