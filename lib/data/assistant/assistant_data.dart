import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../achievements.dart';
import '../dashboard.dart';
import '../database.dart';
import '../game_account_repository.dart' show profitOf;
import '../insights.dart';
import '../performance.dart';
import '../providers.dart';
import '../settings.dart';
import '../smart_tools.dart';

/// Per-game numbers (non-archived games, accounts not in the Trash).
class GameSummary {
  const GameSummary({
    required this.name,
    required this.count,
    required this.active,
    required this.sold,
    required this.forSale,
    required this.profit,
    required this.sales,
    required this.expenses,
  });
  final String name;
  final int count, active, sold, forSale;
  final double profit, sales, expenses; // DH
}

class AccountLine {
  const AccountLine(this.name, this.game, this.profit, this.status);
  final String name;
  final String game;
  final double profit; // DH
  final GameAccountStatus status;
}

/// Everything the assistant may know about the user's data, at one moment.
/// Deliberately excludes emails, Account IDs and notes.
class AssistantData {
  const AssistantData({
    required this.now,
    required this.currency,
    required this.kpis,
    required this.today,
    required this.week,
    required this.month,
    required this.sales,
    required this.expenses,
    required this.games,
    required this.top,
    required this.losses,
    required this.googleTotal,
    required this.byGrade,
    required this.byBox,
    required this.health,
    required this.goals,
    required this.streak,
    required this.insights,
    required this.alerts,
    required this.achievementsDone,
    required this.achievementsTotal,
  });

  final DateTime now;
  final CurrencySettings? currency;
  final DashboardKpis kpis;
  final PeriodSummary today, week, month;
  final double sales, expenses; // DH, priced accounts
  final List<GameSummary> games; // most profitable first
  final List<AccountLine> top, losses;
  final int googleTotal;
  final Map<Grade, int> byGrade;
  final Map<BoxStatus, int> byBox;
  final DataHealth health;
  final PerformanceGoals goals;
  final int streak;
  final List<Insight> insights;
  final List<Insight> alerts;
  final int achievementsDone, achievementsTotal;

  String m(double dh) => money(dh, currency: currency);
  String sm(double dh) => signedMoney(dh, currency: currency);

  /// Compact text given to Claude in AI mode (amounts already converted).
  String toPromptText() {
    final b = StringBuffer()
      ..writeln(
          '<sphera_data date="${fmtDate(now)}" currency="${currency?.code ?? 'DH'}">')
      ..writeln(
          'Gaming accounts: ${kpis.total} (active ${kpis.active}, sold ${kpis.sold}, for sale ${kpis.forSale}).')
      ..writeln(
          'Net profit: ${sm(kpis.netProfit)}. Sales ${m(sales)}, expenses ${m(expenses)}.')
      ..writeln(
          'Today: ${sm(today.profit)}, ${today.added} added (yesterday ${sm(today.prevProfit)}, ${today.prevAdded}).')
      ..writeln(
          'This week: ${sm(week.profit)}, ${week.added} added (last week ${sm(week.prevProfit)}, ${week.prevAdded}).')
      ..writeln(
          'This month: ${sm(month.profit)}, ${month.added} added (last month ${sm(month.prevProfit)}, ${month.prevAdded}).')
      ..writeln('Add streak: $streak day(s).');
    if (goals.any) {
      b.writeln('Monthly goals: '
          '${goals.monthlyProfit > 0 ? 'profit ${m(goals.monthlyProfit)}' : 'no profit goal'}, '
          '${goals.monthlyAccounts > 0 ? '${goals.monthlyAccounts} accounts' : 'no accounts goal'}.');
    }
    b.writeln('Games:');
    for (final g in games) {
      b.writeln(
          '- ${g.name}: ${g.count} accounts (active ${g.active}, sold ${g.sold}, for sale ${g.forSale}), '
          'profit ${sm(g.profit)}, sales ${m(g.sales)}, expenses ${m(g.expenses)}');
    }
    if (top.isNotEmpty) {
      b.writeln(
          'Most profitable accounts: ${top.map((a) => '${a.name} (${a.game}) ${sm(a.profit)}').join('; ')}');
    }
    if (losses.isNotEmpty) {
      b.writeln(
          'Accounts at a loss: ${losses.map((a) => '${a.name} (${a.game}) ${sm(a.profit)}').join('; ')}');
    }
    b
      ..writeln('Google accounts: $googleTotal. Grades: '
          '${Grade.values.map((g) => '${gradeName(g)} ${byGrade[g] ?? 0}').join(', ')}.')
      ..writeln(
          'Game boxes: ${BoxStatus.values.map((s) => '${boxName(s)} ${byBox[s] ?? 0}').join(', ')}.')
      ..writeln(
          'Data health: ${health.duplicates} Google duplicate groups, ${health.gameDuplicates} gaming duplicate groups, '
          '${health.invalidEmails} invalid emails, ${health.missingIds} accounts without ID, '
          '${health.noBoxes} Google accounts with no box set, ${health.trashed} items in Trash.')
      ..writeln(
          'Achievements: $achievementsDone / $achievementsTotal unlocked.')
      ..writeln('Current insights:');
    for (final i in insights) {
      b.writeln(
          '- [${i.level.name}${i.reminder ? ', reminder' : ''}] ${i.title}: ${i.body}');
    }
    b.writeln('</sphera_data>');
    return b.toString();
  }
}

String gradeName(Grade g) => switch (g) {
      Grade.bronze => 'Bronze',
      Grade.silver => 'Silver',
      Grade.gold => 'Gold',
      Grade.platinum => 'Platinum',
      Grade.diamond => 'Diamond',
      Grade.interdit => 'Interdit',
    };

String boxName(BoxStatus s) => switch (s) {
      BoxStatus.empty => 'EMPTY',
      BoxStatus.done => 'DONE',
      BoxStatus.notYet => 'NOT YET',
      BoxStatus.coming => 'COMING',
    };

AssistantData buildAssistantData({
  required List<Game> games,
  required List<GameAccount> accounts,
  required List<GoogleAccount> googleAccounts,
  required List<GoogleGameBox> boxes,
  required DataHealth health,
  required PerformanceGoals goals,
  required List<Insight> insights,
  required List<Insight> alerts,
  required int achievementsDone,
  required int achievementsTotal,
  CurrencySettings? currency,
  DateTime? now,
}) {
  final n = now ?? DateTime.now();
  final name = {for (final g in games) g.id: g.name};
  final summaries = <GameSummary>[
    for (final g in games)
      () {
        final mine = accounts.where((a) => a.gameId == g.id).toList();
        final priced = mine.where((a) => a.status != GameAccountStatus.forSale);
        return GameSummary(
          name: g.name,
          count: mine.length,
          active:
              mine.where((a) => a.status == GameAccountStatus.active).length,
          sold: mine.where((a) => a.status == GameAccountStatus.sell).length,
          forSale:
              mine.where((a) => a.status == GameAccountStatus.forSale).length,
          profit: mine.fold(0.0, (s, a) => s + profitOf(a)),
          sales: priced.fold(0.0, (s, a) => s + a.salePrice),
          expenses: priced.fold(0.0, (s, a) => s + a.purchasePrice),
        );
      }(),
  ]..sort((a, b) => b.profit.compareTo(a.profit));

  final lines = [
    for (final a in accounts)
      if (a.status != GameAccountStatus.forSale)
        AccountLine(a.name, name[a.gameId] ?? '', profitOf(a), a.status),
  ]..sort((a, b) => b.profit.compareTo(a.profit));

  final stats = <Grade, int>{for (final g in Grade.values) g: 0};
  for (final a in googleAccounts) {
    stats[a.grade] = stats[a.grade]! + 1;
  }
  final liveIds = {for (final a in googleAccounts) a.id};
  final gameIds = {for (final g in games) g.id};
  final byBox = <BoxStatus, int>{for (final s in BoxStatus.values) s: 0};
  for (final b in boxes) {
    if (liveIds.contains(b.googleAccountId) && gameIds.contains(b.gameId)) {
      byBox[b.status] = byBox[b.status]! + 1;
    }
  }
  final priced = accounts.where((a) => a.status != GameAccountStatus.forSale);

  return AssistantData(
    now: n,
    currency: currency,
    kpis: computeKpis(accounts, now: n),
    today: summarizePeriod(accounts, PerfPeriod.today, now: n),
    week: summarizePeriod(accounts, PerfPeriod.week, now: n),
    month: summarizePeriod(accounts, PerfPeriod.month, now: n),
    sales: priced.fold(0.0, (s, a) => s + a.salePrice),
    expenses: priced.fold(0.0, (s, a) => s + a.purchasePrice),
    games: summaries,
    top: lines.where((l) => l.profit > 0).take(5).toList(),
    losses: lines.reversed.where((l) => l.profit < 0).take(5).toList(),
    googleTotal: googleAccounts.length,
    byGrade: stats,
    byBox: byBox,
    health: health,
    goals: goals,
    streak: addStreak(accounts, now: n),
    insights: insights,
    alerts: alerts,
    achievementsDone: achievementsDone,
    achievementsTotal: achievementsTotal,
  );
}

final assistantDataProvider = Provider<AssistantData>((ref) {
  final ach = ref.watch(achievementsProvider);
  return buildAssistantData(
    games: ref.watch(activeGamesProvider).value ?? const <Game>[],
    accounts: ref.watch(dashboardAccountsProvider),
    googleAccounts:
        ref.watch(googleAccountsProvider).value ?? const <GoogleAccount>[],
    boxes: ref.watch(googleBoxesProvider).value ?? const <GoogleGameBox>[],
    health: ref.watch(dataHealthProvider),
    goals: ref.watch(goalsProvider),
    insights: ref.watch(insightsProvider),
    alerts: ref.watch(notificationsProvider),
    achievementsDone: ach.where((a) => a.done).length,
    achievementsTotal: ach.length,
    currency: ref.watch(currencyProvider),
  );
});
