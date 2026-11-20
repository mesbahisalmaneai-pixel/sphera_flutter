import '../core/l10n.dart';
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/format.dart';
import 'dashboard.dart';
import 'database.dart';
import 'game_account_repository.dart' show profitOf;
import 'performance.dart';
import 'providers.dart';
import 'settings.dart';
import 'smart_tools.dart';

/// SPHERA Intelligence: offline, rule-based analysis of the local data.
/// Nothing leaves the device. The same insights feed the Notifications center.

enum InsightLevel { good, info, warning }

/// Where tapping an insight takes the user (the UI maps it to a screen).
enum InsightTarget {
  profit,
  performance,
  forSale,
  duplicates,
  security,
  googleAccounts,
  addAccount,
  activity,
  gradeStats,
  statusStats,
  gamesStats,
  games,
  trash,
  organizer,
  vault,
  arena,
  achievements,
  settings,
  notifications,
  notificationSettings,
}

class Insight {
  const Insight({
    required this.id,
    required this.level,
    required this.icon,
    required this.title,
    required this.body,
    this.target,
    this.reminder = false,
  });

  /// Stable while the situation is unchanged; it changes when the numbers do,
  /// so a "read" notification comes back if the problem grows.
  final String id;
  final InsightLevel level;
  final IconData icon;
  final String title;
  final String body;
  final InsightTarget? target;

  /// Reminders can be muted separately (Settings > Notifications > Reminders).
  final bool reminder;

  /// Warnings and reminders are shown as notifications.
  bool get alert => level == InsightLevel.warning || reminder;
}

/// A FOR SALE listing untouched for this long gets a reminder.
const kStaleForSaleDays = 14;

/// [accounts] = live gaming accounts of non-archived games (dashboard scope).
List<Insight> computeInsights({
  required List<Game> games,
  required List<GameAccount> accounts,
  required List<GoogleAccount> googleAccounts,
  required List<GoogleGameBox> boxes,
  required DataHealth health,
  required PerformanceGoals goals,
  CurrencySettings? currency,
  DateTime? now,
  AppLocalizations? l,
}) {
  // Texts in [l]'s language (English when left out, as in tests).
  final t = l ?? l10nFor('en');
  final n = now ?? DateTime.now();
  String m(double v) => money(v, currency: currency);
  String sm(double v) => signedMoney(v, currency: currency);
  final out = <Insight>[];

  if (accounts.isEmpty) {
    out.add(Insight(
      id: 'empty',
      level: InsightLevel.info,
      icon: Icons.add_circle_outline,
      title: t.insEmptyTitle,
      body: t.insEmptyBody,
      target: InsightTarget.addAccount,
    ));
  }

  // ---- Month trend ----
  final kpis = computeKpis(accounts, now: n);
  if (kpis.profitThisMonth != 0 || kpis.profitLastMonth != 0) {
    final up = kpis.profitThisMonth >= kpis.profitLastMonth;
    final pct = kpis.profitChangePct;
    out.add(Insight(
      id: 'trend:${up ? 'up' : 'down'}',
      level: up ? InsightLevel.good : InsightLevel.warning,
      icon: up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
      title: up ? t.insTrendUpTitle : t.insTrendDownTitle,
      body: pct == null
          ? t.insTrendBody(sm(kpis.profitThisMonth), sm(kpis.profitLastMonth))
          : t.insTrendBodyPct(sm(kpis.profitThisMonth), sm(kpis.profitLastMonth),
              '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(0)}'),
      target: InsightTarget.performance,
    ));
  }

  // ---- Per game ----
  final byGame = <String, List<GameAccount>>{};
  for (final a in accounts) {
    (byGame[a.gameId] ??= []).add(a);
  }
  final gameName = {for (final g in games) g.id: g.name};
  final profits = {
    for (final e in byGame.entries) e.key: e.value.fold<double>(0, (s, a) => s + profitOf(a)),
  };
  final ranked = profits.entries.where((e) => gameName.containsKey(e.key)).toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  if (ranked.length >= 2 && ranked.first.value > 0) {
    final best = ranked.first;
    final total = profits.values.where((v) => v > 0).fold<double>(0, (s, v) => s + v);
    final share = total <= 0 ? 0 : best.value / total * 100;
    out.add(Insight(
      id: 'best-game:${best.key}',
      level: InsightLevel.good,
      icon: Icons.emoji_events_outlined,
      title: t.insBestTitle(gameName[best.key]!),
      body: t.insBestBody(sm(best.value), share.toStringAsFixed(0), byGame[best.key]!.length),
      target: InsightTarget.profit,
    ));
  }
  final losing = ranked.where((e) => e.value < 0).toList();
  if (losing.isNotEmpty) {
    final names = losing.map((e) => gameName[e.key]).join(', ');
    final total = losing.fold<double>(0, (s, e) => s + e.value);
    out.add(Insight(
      id: 'losing-games:${losing.map((e) => e.key).join(',')}',
      level: InsightLevel.warning,
      icon: Icons.money_off_rounded,
      title: losing.length == 1 ? t.insLosingOneTitle(names) : t.insLosingManyTitle(losing.length),
      body: losing.length == 1 ? t.insLosingOneBody(sm(total)) : t.insLosingManyBody(names, sm(total)),
      target: InsightTarget.profit,
    ));
  }

  // ---- Sold at a loss ----
  final soldLoss =
      accounts.where((a) => a.status == GameAccountStatus.sell && profitOf(a) < 0).toList();
  if (soldLoss.isNotEmpty) {
    final total = soldLoss.fold<double>(0, (s, a) => s + profitOf(a));
    out.add(Insight(
      id: 'sold-loss:${soldLoss.length}',
      level: InsightLevel.warning,
      icon: Icons.south_east_rounded,
      title: t.insSoldLossTitle(soldLoss.length),
      body: t.insSoldLossBody(m(-total)),
      target: InsightTarget.profit,
    ));
  }

  // ---- Active accounts priced under cost ----
  final underCost = accounts
      .where((a) =>
          a.status == GameAccountStatus.active && a.salePrice > 0 && a.salePrice < a.purchasePrice)
      .length;
  if (underCost > 0) {
    out.add(Insight(
      id: 'under-cost:$underCost',
      level: InsightLevel.info,
      icon: Icons.price_change_outlined,
      title: t.insUnderCostTitle(underCost),
      body: t.insUnderCostBody,
      target: InsightTarget.profit,
    ));
  }

  // ---- Average margin ----
  final priced = accounts.where((a) => a.status != GameAccountStatus.forSale).toList();
  final cost = priced.fold<double>(0, (s, a) => s + a.purchasePrice);
  if (priced.length >= 3 && cost > 0) {
    final net = priced.fold<double>(0, (s, a) => s + profitOf(a));
    final margin = net / cost * 100;
    final avg = net / priced.length;
    out.add(Insight(
      id: 'margin:${margin.round()}',
      level: margin >= 0 ? InsightLevel.info : InsightLevel.warning,
      icon: Icons.percent_rounded,
      title: t.insMarginTitle('${margin >= 0 ? '+' : ''}${margin.toStringAsFixed(1)}'),
      body: t.insMarginBody(sm(avg), priced.length),
      target: InsightTarget.profit,
    ));
  }

  // ---- Stale FOR SALE listings (reminder) ----
  final cutoff = n.subtract(const Duration(days: kStaleForSaleDays));
  final stale = accounts
      .where((a) => a.status == GameAccountStatus.forSale && a.updatedAt.isBefore(cutoff))
      .length;
  if (stale > 0) {
    out.add(Insight(
      id: 'stale-forsale:$stale',
      level: InsightLevel.info,
      icon: Icons.schedule_rounded,
      title: t.insStaleTitle(stale, kStaleForSaleDays),
      body: t.insStaleBody,
      target: InsightTarget.forSale,
      reminder: true,
    ));
  }

  // ---- COMING boxes (reminder) ----
  final liveIds = {for (final g in googleAccounts) g.id};
  final gameIds = {for (final g in games) g.id};
  final coming = boxes
      .where((b) =>
          b.status == BoxStatus.coming && liveIds.contains(b.googleAccountId) && gameIds.contains(b.gameId))
      .length;
  if (coming > 0) {
    out.add(Insight(
      id: 'coming:$coming',
      level: InsightLevel.info,
      icon: Icons.hourglass_top_rounded,
      title: t.insComingTitle(coming),
      body: t.insComingBody,
      target: InsightTarget.googleAccounts,
      reminder: true,
    ));
  }

  // ---- Data health ----
  final dups = health.duplicates + health.gameDuplicates;
  if (dups > 0) {
    out.add(Insight(
      id: 'dups:$dups',
      level: InsightLevel.warning,
      icon: Icons.content_copy_outlined,
      title: t.insDupsTitle(dups),
      body: t.insDupsBody,
      target: InsightTarget.duplicates,
    ));
  }
  if (health.invalidEmails > 0) {
    out.add(Insight(
      id: 'bad-email:${health.invalidEmails}',
      level: InsightLevel.warning,
      icon: Icons.alternate_email_rounded,
      title: t.insBadEmailTitle(health.invalidEmails),
      body: t.insBadEmailBody,
      target: InsightTarget.security,
    ));
  }
  if (health.missingIds > 0) {
    out.add(Insight(
      id: 'missing-id:${health.missingIds}',
      level: InsightLevel.info,
      icon: Icons.badge_outlined,
      title: t.insMissingIdTitle(health.missingIds),
      body: t.insMissingIdBody,
      target: InsightTarget.security,
    ));
  }

  // ---- Goals (reminder) ----
  final month = summarizePeriod(accounts, PerfPeriod.month, now: n);
  final expected = monthElapsed(n);
  void goal(String key, String reachedTitle, String behindTitle, double current, double target,
      String Function(double) fmt) {
    if (target <= 0) return;
    final g = GoalProgress(current: current, target: target, expectedFraction: expected);
    if (g.reached) {
      out.add(Insight(
        id: 'goal-$key:done:${n.year}-${n.month}',
        level: InsightLevel.good,
        icon: Icons.flag_rounded,
        title: reachedTitle,
        body: t.insGoalReachedBody(fmt(current), fmt(target)),
        target: InsightTarget.performance,
      ));
    } else if (!g.onTrack) {
      out.add(Insight(
        id: 'goal-$key:behind:${n.year}-${n.month}',
        level: InsightLevel.info,
        icon: Icons.flag_outlined,
        title: behindTitle,
        body: t.insGoalBehindBody(fmt(current), fmt(target), (expected * 100).toStringAsFixed(0)),
        target: InsightTarget.performance,
        reminder: true,
      ));
    }
  }

  goal('profit', t.insGoalProfitReached, t.insGoalProfitBehind, month.profit, goals.monthlyProfit, m);
  goal('accounts', t.insGoalAccountsReached, t.insGoalAccountsBehind, month.added.toDouble(), goals.monthlyAccounts.toDouble(),
      (v) => v.toStringAsFixed(0));

  // Warnings first, then reminders/info, then good news.
  int rank(Insight i) => switch (i.level) {
        InsightLevel.warning => 0,
        InsightLevel.info => 1,
        InsightLevel.good => 2,
      };
  out.sort((a, b) => rank(a).compareTo(rank(b)));
  return out;
}

// ======================= Providers =======================

final insightsProvider = Provider<List<Insight>>((ref) => computeInsights(
      games: ref.watch(activeGamesProvider).value ?? const <Game>[],
      accounts: ref.watch(dashboardAccountsProvider),
      googleAccounts: ref.watch(googleAccountsProvider).value ?? const <GoogleAccount>[],
      boxes: ref.watch(googleBoxesProvider).value ?? const <GoogleGameBox>[],
      health: ref.watch(dataHealthProvider),
      goals: ref.watch(goalsProvider),
      currency: ref.watch(currencyProvider),
      l: l10nFor(ref.watch(languageProvider)),
    ));

/// Insights shown as notifications, after the user's notification settings.
List<Insight> notificationsFrom(List<Insight> insights, NotificationPrefs prefs) => !prefs.enabled
    ? const <Insight>[]
    : [for (final i in insights) if (i.alert && (prefs.reminders || !i.reminder)) i];

final notificationsProvider = Provider<List<Insight>>(
    (ref) => notificationsFrom(ref.watch(insightsProvider), ref.watch(notificationPrefsProvider)));

/// Ids of the notifications the user has already seen.
class ReadNotificationsNotifier extends Notifier<Set<String>> {
  static const _k = 'notif_read';

  @override
  Set<String> build() {
    _load();
    return <String>{};
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = (p.getStringList(_k) ?? const <String>[]).toSet();
  }

  /// Keeps only ids that are still current, so the list never grows forever.
  Future<void> markAllRead(Iterable<String> current) async {
    state = current.toSet();
    (await SharedPreferences.getInstance()).setStringList(_k, state.toList());
  }
}

final readNotificationsProvider =
    NotifierProvider<ReadNotificationsNotifier, Set<String>>(ReadNotificationsNotifier.new);

final unreadNotificationCountProvider = Provider<int>((ref) {
  final read = ref.watch(readNotificationsProvider);
  return ref.watch(notificationsProvider).where((i) => !read.contains(i.id)).length;
});
