import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/database.dart';
import 'package:sphera_flutter/data/insights.dart';
import 'package:sphera_flutter/data/performance.dart';
import 'package:sphera_flutter/data/settings.dart';
import 'package:sphera_flutter/data/smart_tools.dart';

GameAccount acc(
  String id,
  double purchase,
  double sale,
  DateTime created, {
  String game = 'efootball',
  GameAccountStatus status = GameAccountStatus.active,
  DateTime? updated,
}) =>
    GameAccount(
      id: id,
      ownerId: 'u1',
      gameId: game,
      idCompte: id,
      name: id,
      purchasePrice: purchase,
      salePrice: sale,
      status: status,
      playerPhotoIds: '[]',
      createdAt: created,
      updatedAt: updated ?? created,
    );

Game game(String id) => Game(
    id: id, ownerId: 'u1', name: id.toUpperCase(), createdAt: DateTime(2025), updatedAt: DateTime(2025));

const healthy = DataHealth(
    duplicates: 0, gameDuplicates: 0, invalidEmails: 0, missingIds: 0, noBoxes: 0, trashed: 0);

List<Insight> insights(List<GameAccount> accounts,
        {DataHealth health = healthy,
        PerformanceGoals goals = const PerformanceGoals(),
        List<GoogleGameBox> boxes = const [],
        List<GoogleAccount> google = const [],
        required DateTime now}) =>
    computeInsights(
      games: [game('efootball'), game('ff')],
      accounts: accounts,
      googleAccounts: google,
      boxes: boxes,
      health: health,
      goals: goals,
      now: now,
    );

void main() {
  // Thursday 15 Oct 2026, noon.
  final now = DateTime(2026, 10, 15, 12);

  group('periods', () {
    test('week runs Monday to Sunday and compares with the week before', () {
      final s = summarizePeriod([
        acc('a', 100, 150, DateTime(2026, 10, 12)), // Monday this week, +50
        acc('b', 100, 120, DateTime(2026, 10, 11)), // Sunday last week, +20
        acc('c', 100, 90, DateTime(2026, 10, 5)), // Monday last week, -10
        acc('d', 100, 500, DateTime(2026, 10, 4)), // two weeks ago, ignored
      ], PerfPeriod.week, now: now);
      expect(s.added, 1);
      expect(s.profit, 50);
      expect(s.prevAdded, 2);
      expect(s.prevProfit, 10);
      expect(s.profitChangePct, 400);
    });

    test('today vs yesterday, month vs last month; FOR SALE adds no profit', () {
      final list = [
        acc('a', 100, 150, DateTime(2026, 10, 15, 9)),
        acc('b', 100, 0, DateTime(2026, 10, 15, 10), status: GameAccountStatus.forSale),
        acc('c', 100, 130, DateTime(2026, 10, 14)),
        acc('d', 100, 200, DateTime(2026, 9, 30)),
      ];
      final today = summarizePeriod(list, PerfPeriod.today, now: now);
      expect((today.added, today.profit, today.prevAdded, today.prevProfit), (2, 50.0, 1, 30.0));
      final month = summarizePeriod(list, PerfPeriod.month, now: now);
      expect((month.added, month.profit, month.prevAdded, month.prevProfit), (3, 80.0, 1, 100.0));
    });

    test('no change % when the previous period is zero', () {
      final s = summarizePeriod([acc('a', 0, 10, now)], PerfPeriod.today, now: now);
      expect(s.profitChangePct, isNull);
    });
  });

  group('streak and goals', () {
    test('streak counts back from today, or from yesterday if nothing today yet', () {
      final days = [14, 13, 12, 10].map((d) => acc('$d', 0, 0, DateTime(2026, 10, d))).toList();
      expect(addStreak(days, now: now), 3); // 14, 13, 12 (no 15 yet, 11 missing)
      expect(addStreak([...days, acc('t', 0, 0, now)], now: now), 4);
      expect(addStreak([acc('old', 0, 0, DateTime(2026, 10, 1))], now: now), 0);
    });

    test('goal pace compares progress with the share of the month gone', () {
      expect(monthElapsed(now), closeTo(15 / 31, 1e-9));
      const behind = GoalProgress(current: 200, target: 1000, expectedFraction: 0.5);
      expect((behind.fraction, behind.onTrack, behind.reached), (0.2, false, false));
      const ahead = GoalProgress(current: 1200, target: 1000, expectedFraction: 0.5);
      expect((ahead.fraction, ahead.onTrack, ahead.reached), (1.0, true, true));
    });
  });

  group('insights', () {
    test('no accounts: a single "add your first account" tip', () {
      final list = insights(const [], now: now);
      expect(list.map((i) => i.id), ['empty']);
      expect(list.single.alert, isFalse);
    });

    test('best game, losing game and sold-at-a-loss are found; warnings come first', () {
      final list = insights([
        acc('a', 100, 300, DateTime(2026, 9, 1)), // efootball +200
        acc('b', 100, 150, DateTime(2026, 9, 2)), // efootball +50
        acc('c', 200, 120, DateTime(2026, 9, 3), game: 'ff', status: GameAccountStatus.sell), // ff -80
      ], now: now);
      final ids = list.map((i) => i.id).toList();
      expect(ids, contains('best-game:efootball'));
      expect(ids, contains('losing-games:ff'));
      expect(ids, contains('sold-loss:1'));
      expect(list.first.level, InsightLevel.warning);
      expect(list.last.level, InsightLevel.good);
    });

    test('stale FOR SALE listings and COMING boxes are reminders', () {
      final g = GoogleAccount(
          id: 'g1',
          ownerId: 'u1',
          email: 'a@gmail.com',
          grade: Grade.gold,
          favorite: false,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026));
      final box = GoogleGameBox(
          id: 'b1', googleAccountId: 'g1', gameId: 'ff', status: BoxStatus.coming, updatedAt: DateTime(2026));
      final list = insights([
        acc('old', 100, 0, DateTime(2026, 9, 1), status: GameAccountStatus.forSale),
        acc('new', 100, 0, DateTime(2026, 10, 10), status: GameAccountStatus.forSale),
      ], google: [g], boxes: [box], now: now);
      final stale = list.firstWhere((i) => i.id.startsWith('stale-forsale'));
      expect(stale.id, 'stale-forsale:1');
      expect(stale.reminder, isTrue);
      expect(list.firstWhere((i) => i.id.startsWith('coming')).title, '1 box marked COMING');
    });

    test('goals: behind pace is a reminder, reached is good news', () {
      final list = [acc('a', 100, 200, DateTime(2026, 10, 2))]; // +100 this month
      final behind = insights(list, goals: const PerformanceGoals(monthlyProfit: 1000), now: now);
      expect(behind.any((i) => i.id == 'goal-profit:behind:2026-10' && i.reminder), isTrue);
      final done = insights(list, goals: const PerformanceGoals(monthlyProfit: 50), now: now);
      expect(done.any((i) => i.id == 'goal-profit:done:2026-10' && i.level == InsightLevel.good), isTrue);
    });

    test('data health issues become warnings', () {
      final list = insights([acc('a', 0, 0, now)],
          health: const DataHealth(
              duplicates: 1, gameDuplicates: 1, invalidEmails: 2, missingIds: 0, noBoxes: 0, trashed: 0),
          now: now);
      expect(list.where((i) => i.level == InsightLevel.warning).map((i) => i.id),
          containsAll(['dups:2', 'bad-email:2']));
    });
  });

  group('notifications', () {
    final all = insights([
      acc('c', 200, 120, DateTime(2026, 9, 3), game: 'ff', status: GameAccountStatus.sell),
      acc('old', 100, 0, DateTime(2026, 9, 1), status: GameAccountStatus.forSale),
    ], now: now);

    test('only warnings and reminders are notifications', () {
      final n = notificationsFrom(all, const NotificationPrefs());
      expect(n, isNotEmpty);
      expect(n.every((i) => i.alert), isTrue);
      expect(n.any((i) => i.reminder), isTrue);
    });

    test('settings: reminders can be muted, master switch hides everything', () {
      final noReminders = notificationsFrom(all, const NotificationPrefs(reminders: false));
      expect(noReminders.any((i) => i.reminder), isFalse);
      expect(noReminders, isNotEmpty);
      expect(notificationsFrom(all, const NotificationPrefs(enabled: false)), isEmpty);
    });
  });
}
