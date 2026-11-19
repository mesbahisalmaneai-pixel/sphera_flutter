import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'database.dart';
import 'game_account_repository.dart' show profitOf;

/// Performance Center: period comparisons, monthly goals, best periods, streak.
/// Same rule as the Home graph: an account counts in the period it was ADDED
/// (createdAt), and FOR SALE accounts have no profit yet.

// ======================= Periods =======================

enum PerfPeriod { today, week, month }

class PeriodSummary {
  const PeriodSummary({
    required this.period,
    required this.profit,
    required this.added,
    required this.prevProfit,
    required this.prevAdded,
  });
  final PerfPeriod period;
  final double profit; // stored in DH
  final int added;
  final double prevProfit; // same length period just before
  final int prevAdded;

  double get profitDelta => profit - prevProfit;

  /// % change vs the previous period, null when the previous period is 0.
  double? get profitChangePct => prevProfit == 0 ? null : profitDelta / prevProfit.abs() * 100;
}

/// [start, end) of the current period and of the one before it.
(DateTime, DateTime, DateTime) periodBounds(PerfPeriod p, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  return switch (p) {
    PerfPeriod.today => (today, DateTime(today.year, today.month, today.day + 1),
        DateTime(today.year, today.month, today.day - 1)),
    PerfPeriod.week => () {
        final monday = DateTime(today.year, today.month, today.day - (today.weekday - 1));
        return (monday, DateTime(monday.year, monday.month, monday.day + 7),
            DateTime(monday.year, monday.month, monday.day - 7));
      }(),
    PerfPeriod.month => (DateTime(now.year, now.month), DateTime(now.year, now.month + 1),
        DateTime(now.year, now.month - 1)),
  };
}

PeriodSummary summarizePeriod(List<GameAccount> accounts, PerfPeriod p, {DateTime? now}) {
  final (start, end, prevStart) = periodBounds(p, now ?? DateTime.now());
  var profit = 0.0, prevProfit = 0.0;
  var added = 0, prevAdded = 0;
  for (final a in accounts) {
    final t = a.createdAt;
    if (!t.isBefore(start) && t.isBefore(end)) {
      added++;
      profit += profitOf(a);
    } else if (!t.isBefore(prevStart) && t.isBefore(start)) {
      prevAdded++;
      prevProfit += profitOf(a);
    }
  }
  return PeriodSummary(
      period: p, profit: profit, added: added, prevProfit: prevProfit, prevAdded: prevAdded);
}

/// Consecutive days with at least one account added, ending today (or
/// yesterday, so the streak is not "lost" before you had a chance today).
int addStreak(List<GameAccount> accounts, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final days = {for (final a in accounts) DateTime(a.createdAt.year, a.createdAt.month, a.createdAt.day)};
  var day = DateTime(n.year, n.month, n.day);
  if (!days.contains(day)) day = DateTime(day.year, day.month, day.day - 1);
  var streak = 0;
  while (days.contains(day)) {
    streak++;
    day = DateTime(day.year, day.month, day.day - 1);
  }
  return streak;
}

/// Most profitable bucket of a range (null when nothing made a profit).
PerfPoint? bestBucket(List<PerfPoint> points) {
  PerfPoint? best;
  for (final p in points) {
    if (p.profit > 0 && (best == null || p.profit > best.profit)) best = p;
  }
  return best;
}

// ======================= Goals =======================

class PerformanceGoals {
  const PerformanceGoals({this.monthlyProfit = 0, this.monthlyAccounts = 0});
  final double monthlyProfit; // DH, 0 = no goal
  final int monthlyAccounts; // 0 = no goal
  bool get any => monthlyProfit > 0 || monthlyAccounts > 0;
}

class GoalsNotifier extends Notifier<PerformanceGoals> {
  @override
  PerformanceGoals build() {
    _load();
    return const PerformanceGoals();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = PerformanceGoals(
      monthlyProfit: p.getDouble('goal_month_profit') ?? 0,
      monthlyAccounts: p.getInt('goal_month_accounts') ?? 0,
    );
  }

  Future<void> set({required double monthlyProfit, required int monthlyAccounts}) async {
    state = PerformanceGoals(
        monthlyProfit: monthlyProfit < 0 ? 0 : monthlyProfit,
        monthlyAccounts: monthlyAccounts < 0 ? 0 : monthlyAccounts);
    final p = await SharedPreferences.getInstance();
    await p.setDouble('goal_month_profit', state.monthlyProfit);
    await p.setInt('goal_month_accounts', state.monthlyAccounts);
  }
}

final goalsProvider = NotifierProvider<GoalsNotifier, PerformanceGoals>(GoalsNotifier.new);

class GoalProgress {
  const GoalProgress({required this.current, required this.target, required this.expectedFraction});
  final double current;
  final double target;

  /// Share of the month already elapsed (0..1): where you "should" be by now.
  final double expectedFraction;

  double get fraction => target <= 0 ? 0 : (current / target).clamp(0.0, 1.0).toDouble();
  bool get reached => target > 0 && current >= target;
  bool get onTrack => reached || fraction >= expectedFraction;
}

/// Share of the current month that has passed, counting today as done.
double monthElapsed(DateTime now) {
  final days = DateTime(now.year, now.month + 1, 0).day;
  return (now.day / days).clamp(0.0, 1.0).toDouble();
}

// ======================= Providers =======================

final periodSummaryProvider = Provider.family<PeriodSummary, PerfPeriod>(
    (ref, p) => summarizePeriod(ref.watch(dashboardAccountsProvider), p));

final addStreakProvider = Provider<int>((ref) => addStreak(ref.watch(dashboardAccountsProvider)));

final profitGoalProvider = Provider<GoalProgress?>((ref) {
  final g = ref.watch(goalsProvider);
  if (g.monthlyProfit <= 0) return null;
  final m = ref.watch(periodSummaryProvider(PerfPeriod.month));
  return GoalProgress(current: m.profit, target: g.monthlyProfit, expectedFraction: monthElapsed(DateTime.now()));
});

final accountsGoalProvider = Provider<GoalProgress?>((ref) {
  final g = ref.watch(goalsProvider);
  if (g.monthlyAccounts <= 0) return null;
  final m = ref.watch(periodSummaryProvider(PerfPeriod.month));
  return GoalProgress(
      current: m.added.toDouble(),
      target: g.monthlyAccounts.toDouble(),
      expectedFraction: monthElapsed(DateTime.now()));
});
