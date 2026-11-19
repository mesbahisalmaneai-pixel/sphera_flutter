import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';
import 'game_account_repository.dart' show profitOf;
import 'providers.dart';

/// Time range of the Home performance graph.
enum PerfRange { daily, weekly, monthly }

/// One bar of the performance graph.
class PerfPoint {
  const PerfPoint({required this.start, required this.profit, required this.count});
  final DateTime start; // first instant of the day / week (Monday) / month
  final double profit; // sum of (sale - purchase), stored in DH
  final int count; // accounts added in this bucket
}

/// The four KPI cards of the Home dashboard (+ this month vs last month).
class DashboardKpis {
  const DashboardKpis({
    required this.total,
    required this.active,
    required this.forSale,
    required this.sold,
    required this.netProfit,
    required this.addedThisMonth,
    required this.profitThisMonth,
    required this.profitLastMonth,
  });
  final int total;
  final int active;
  final int forSale; // listed, no price yet
  final int sold;
  final double netProfit;
  final int addedThisMonth;
  final double profitThisMonth; // profit of accounts added this month
  final double profitLastMonth; // profit of accounts added last month

  /// % change of monthly profit vs last month. null when last month is 0
  /// (a percentage would be meaningless).
  double? get profitChangePct => profitLastMonth == 0
      ? null
      : (profitThisMonth - profitLastMonth) / profitLastMonth.abs() * 100;

  static const empty = DashboardKpis(
      total: 0,
      active: 0,
      forSale: 0,
      sold: 0,
      netProfit: 0,
      addedThisMonth: 0,
      profitThisMonth: 0,
      profitLastMonth: 0);
}


/// [accounts] must already exclude trashed accounts and archived games.
/// Net profit = sum of profitOf(): FOR SALE accounts have no price, so they
/// count 0 (same rule as Profit Center).
DashboardKpis computeKpis(List<GameAccount> accounts, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final thisMonth = DateTime(n.year, n.month);
  final lastMonth = DateTime(n.year, n.month - 1);

  var active = 0, sold = 0, forSale = 0, added = 0;
  var net = 0.0, pThis = 0.0, pLast = 0.0;
  for (final a in accounts) {
    if (a.status == GameAccountStatus.active) active++;
    if (a.status == GameAccountStatus.sell) sold++;
    if (a.status == GameAccountStatus.forSale) forSale++;
    final p = profitOf(a);
    net += p;
    if (!a.createdAt.isBefore(thisMonth)) {
      added++;
      pThis += p;
    } else if (!a.createdAt.isBefore(lastMonth)) {
      pLast += p;
    }
  }
  return DashboardKpis(
    total: accounts.length,
    active: active,
    forSale: forSale,
    sold: sold,
    netProfit: net,
    addedThisMonth: added,
    profitThisMonth: pThis,
    profitLastMonth: pLast,
  );
}

/// Ascending bucket start dates. Daily = last 30 days, Weekly = last 12 weeks
/// (weeks start on Monday), Monthly = last 12 months. DateTime(y, m, d - i)
/// normalises overflow, so month/year/DST boundaries are handled by Dart.
List<DateTime> bucketStarts(PerfRange r, DateTime now) => switch (r) {
      PerfRange.daily => [
          for (var i = 29; i >= 0; i--) DateTime(now.year, now.month, now.day - i)
        ],
      PerfRange.weekly => () {
          final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
          return [
            for (var i = 11; i >= 0; i--) DateTime(monday.year, monday.month, monday.day - 7 * i)
          ];
        }(),
      PerfRange.monthly => [
          for (var i = 11; i >= 0; i--) DateTime(now.year, now.month - i)
        ],
    };

/// Groups priced accounts (not FOR SALE) by the date they were added
/// (`createdAt`) and sums their profit. (The app has no "sold at" date yet, see README note.)
List<PerfPoint> buildPerformance(List<GameAccount> accounts, PerfRange range, {DateTime? now}) {
  final starts = bucketStarts(range, now ?? DateTime.now());
  final profit = List<double>.filled(starts.length, 0);
  final count = List<int>.filled(starts.length, 0);
  for (final a in accounts) {
    if (a.status == GameAccountStatus.forSale) continue; // no price yet
    final t = a.createdAt;
    if (t.isBefore(starts.first)) continue; // older than the window
    var i = starts.length - 1;
    while (i > 0 && t.isBefore(starts[i])) {
      i--;
    }
    profit[i] += profitOf(a);
    count[i]++;
  }
  return [
    for (var i = 0; i < starts.length; i++)
      PerfPoint(start: starts[i], profit: profit[i], count: count[i])
  ];
}

// ---------------------------------------------------------------------------
// Providers. Everything is derived from the Drift streams, so the dashboard
// updates instantly whenever the data changes (no polling needed).
// ---------------------------------------------------------------------------

/// True until both source streams have emitted once (used for skeletons).
final dashboardLoadingProvider = Provider<bool>((ref) =>
    !ref.watch(allGameAccountsProvider).hasValue || !ref.watch(activeGamesProvider).hasValue);

/// Non-trashed gaming accounts whose game is not archived
/// (same scope as Profit Center and Games Statistics).
final dashboardAccountsProvider = Provider<List<GameAccount>>((ref) {
  final games = ref.watch(activeGamesProvider).value ?? const <Game>[];
  final ids = {for (final g in games) g.id};
  final all = ref.watch(allGameAccountsProvider).value ?? const <GameAccount>[];
  return all.where((a) => ids.contains(a.gameId)).toList();
});

final dashboardKpisProvider =
    Provider<DashboardKpis>((ref) => computeKpis(ref.watch(dashboardAccountsProvider)));

final performanceProvider = Provider.family<List<PerfPoint>, PerfRange>(
    (ref, range) => buildPerformance(ref.watch(dashboardAccountsProvider), range));

/// Accounts currently FOR SALE (no price), newest change first.
final forSaleAccountsProvider = Provider<List<GameAccount>>((ref) {
  final list = ref
      .watch(dashboardAccountsProvider)
      .where((a) => a.status == GameAccountStatus.forSale)
      .toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return list;
});
