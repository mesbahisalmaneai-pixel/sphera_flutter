import 'package:flutter/material.dart' show IconData, Icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/l10n.dart';
import '../../core/status_style.dart' show gradeLabel;
import '../../core/theme.dart' show kThemeStyles;
import '../../data/achievements.dart';
import '../../data/dashboard.dart';
import '../../data/database.dart' show BoxStatus, Grade;
import '../../data/profile.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../../data/smart_tools.dart';
import 'models/orbit_destination.dart';

/// One label + value pair (a cell of the info card).
class OrbitMetric {
  const OrbitMetric(this.label, this.value);
  final String label;
  final String value;
}

/// One row with a progress bar (the "Stats" tab of an open section).
class OrbitBar {
  const OrbitBar(this.label, this.value, this.fraction);
  final String label;
  final String value;
  final double fraction; // 0..1
}

/// Everything the Orbit screen shows about one section, computed from live data.
class OrbitSectionInfo {
  const OrbitSectionInfo({
    required this.cells,
    required this.gaugeA,
    required this.gaugeALabel,
    required this.gaugeB,
    required this.gaugeBLabel,
    required this.bigLabel,
    required this.bigValue,
    required this.bars,
  });

  /// Used when a section has no entry (a section added later).
  factory OrbitSectionInfo.fallback(int screens) => OrbitSectionInfo(
        cells: [OrbitMetric(appL10n.orbScreens, '$screens')],
        gaugeA: 0,
        gaugeALabel: '',
        gaugeB: 0,
        gaugeBLabel: '',
        bigLabel: appL10n.orbScreens,
        bigValue: '$screens',
        bars: const [],
      );

  final List<OrbitMetric> cells;
  final double gaugeA;
  final String gaugeALabel;
  final double gaugeB;
  final String gaugeBLabel;
  final String bigLabel;
  final String bigValue;
  final List<OrbitBar> bars;
}

/// One card of the Insights row. [destId] is the id of the Orbit destination
/// (see orbit_sections.dart) that the card opens.
class OrbitInsight {
  const OrbitInsight({
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
    required this.captionIcon,
    required this.destId,
  });
  final IconData icon;
  final String label;
  final String value;
  final String caption;
  final IconData captionIcon;
  final String destId;
}

class OrbitData {
  const OrbitData({required this.sections, required this.insights});
  final Map<String, OrbitSectionInfo> sections;
  final List<OrbitInsight> insights;

  OrbitSectionInfo infoFor(OrbitSection s) =>
      sections[s.id] ?? OrbitSectionInfo.fallback(s.destinations.length);
}

/// The destination with this [id], or null.
OrbitDestination? findDestination(List<OrbitSection> sections, String id) {
  for (final s in sections) {
    for (final d in s.destinations) {
      if (d.id == id) return d;
    }
  }
  return null;
}

double _frac(num part, num whole) =>
    whole <= 0 ? 0.0 : (part / whole).clamp(0.0, 1.0).toDouble();

final orbitDataProvider = Provider<OrbitData>((ref) {
  final kpis = ref.watch(dashboardKpisProvider);
  final google = ref.watch(googleStatsProvider);
  final games = ref.watch(gameStatsProvider);
  final health = ref.watch(dataHealthProvider);
  final vault = ref.watch(vaultProvider);
  final ach = ref.watch(achievementsProvider);
  final look = ref.watch(appearanceProvider);
  final cur = ref.watch(currencyProvider);
  final lang = ref.watch(languageProvider);
  final l = l10nFor(lang);
  final notif = ref.watch(notificationPrefsProvider);
  final profile = ref.watch(profileProvider);

  final profitText = money(kpis.netProfit, currency: cur);
  final accountsAll = google.total + kpis.total;
  final duplicates = health.duplicates + health.gameDuplicates;

  final boxesTotal = google.byStatus.values.fold<int>(0, (a, b) => a + b);
  final boxesSet = boxesTotal - (google.byStatus[BoxStatus.empty] ?? 0);
  final boxesDone = google.byStatus[BoxStatus.done] ?? 0;
  final diamonds = google.byGrade[Grade.diamond] ?? 0;
  final premium = diamonds + (google.byGrade[Grade.platinum] ?? 0);

  final achDone = ach.where((a) => a.done).length;
  final points = ach.where((a) => a.done).fold<int>(0, (t, a) => t + a.points);
  final pointsAll = ach.fold<int>(0, (t, a) => t + a.points);
  final pending = ach.where((a) => !a.done).toList()
    ..sort((a, b) => b.fraction.compareTo(a.fraction));

  final byCount = [...games]..sort((a, b) => b.count.compareTo(a.count));
  final maxCount = byCount.isEmpty ? 0 : byCount.first.count;

  final styleName = kThemeStyles[look.style] ?? look.style;
  final modeName = switch (look.mode) {
    ThemeModeSetting.dark => l.dark,
    ThemeModeSetting.light => l.light,
    ThemeModeSetting.system => l.orbSystem,
  };
  final alertsOn = notif.enabled;
  final remindersOn = notif.enabled && notif.reminders;

  final sections = <String, OrbitSectionInfo>{
    'stats': OrbitSectionInfo(
      cells: [
        OrbitMetric(l.orbNetProfit, profitText),
        OrbitMetric(l.orbAccounts, '${kpis.total}'),
        OrbitMetric(l.orbSold, '${kpis.sold}'),
        OrbitMetric(l.orbForSale, '${kpis.forSale}'),
      ],
      gaugeA: _frac(kpis.active, kpis.total),
      gaugeALabel: l.orbActive,
      gaugeB: _frac(kpis.sold, kpis.total),
      gaugeBLabel: l.orbSold,
      bigLabel: l.orbNetProfit,
      bigValue: profitText,
      bars: [
        OrbitBar(l.orbActive, '${kpis.active}', _frac(kpis.active, kpis.total)),
        OrbitBar(l.orbSold, '${kpis.sold}', _frac(kpis.sold, kpis.total)),
        OrbitBar(l.orbForSale, '${kpis.forSale}', _frac(kpis.forSale, kpis.total)),
        OrbitBar(l.orbAddedThisMonth, '${kpis.addedThisMonth}', _frac(kpis.addedThisMonth, kpis.total)),
      ],
    ),
    'cards': OrbitSectionInfo(
      cells: [
        OrbitMetric(l.orbGoogleAccounts, '${google.total}'),
        OrbitMetric(l.orbGamingAccounts, '${kpis.total}'),
        OrbitMetric(l.orbDuplicates, '$duplicates'),
        OrbitMetric(l.orbInVault, '${vault.length}'),
      ],
      gaugeA: accountsAll == 0 ? 1.0 : 1.0 - _frac(health.issues, accountsAll),
      gaugeALabel: l.orbClean,
      gaugeB: _frac(vault.length, accountsAll),
      gaugeBLabel: l.orbInVault,
      bigLabel: l.orbDuplicates,
      bigValue: '$duplicates',
      bars: [
        OrbitBar(l.orbGoogleDuplicates, '${health.duplicates}', _frac(health.duplicates, google.total)),
        OrbitBar(l.orbSameAccountId, '${health.gameDuplicates}', _frac(health.gameDuplicates, kpis.total)),
        OrbitBar(l.orbInVault, '${vault.length}', _frac(vault.length, accountsAll)),
      ],
    ),
    'games': OrbitSectionInfo(
      cells: [
        OrbitMetric(l.orbGames, '${games.length}'),
        OrbitMetric(l.orbAccounts, '${kpis.total}'),
        OrbitMetric(l.orbActive, '${kpis.active}'),
        OrbitMetric(l.orbForSale, '${kpis.forSale}'),
      ],
      gaugeA: _frac(kpis.active, kpis.total),
      gaugeALabel: l.orbActive,
      gaugeB: _frac(kpis.forSale, kpis.total),
      gaugeBLabel: l.orbListed,
      bigLabel: l.orbGamingAccounts,
      bigValue: '${kpis.total}',
      bars: [
        for (final g in byCount.take(6)) OrbitBar(g.game.name, '${g.count}', _frac(g.count, maxCount)),
      ],
    ),
    'google': OrbitSectionInfo(
      cells: [
        OrbitMetric(l.orbAccounts, '${google.total}'),
        OrbitMetric(l.orbBoxesSet, '$boxesSet'),
        OrbitMetric(l.gradeDiamond, '$diamonds'),
        OrbitMetric(l.gradeInterdit, '${google.byGrade[Grade.interdit] ?? 0}'),
      ],
      gaugeA: _frac(boxesDone, boxesTotal),
      gaugeALabel: l.orbDone,
      gaugeB: _frac(premium, google.total),
      gaugeBLabel: l.orbPremium,
      bigLabel: l.orbGoogleAccounts,
      bigValue: '${google.total}',
      bars: [
        for (final g in Grade.values)
          OrbitBar(gradeLabel(g), '${google.byGrade[g] ?? 0}', _frac(google.byGrade[g] ?? 0, google.total)),
      ],
    ),
    'profile': OrbitSectionInfo(
      cells: [
        OrbitMetric(l.orbName, profile.name.trim().isEmpty ? l.orbNotSet : profile.name.trim()),
        OrbitMetric(l.orbUnlocked, l.fraction(achDone, ach.length)),
        OrbitMetric(l.orbPoints, '$points'),
        OrbitMetric(l.orbNextGoal, pending.isEmpty ? l.orbAllDone : pending.first.title),
      ],
      gaugeA: _frac(achDone, ach.length),
      gaugeALabel: l.orbUnlocked,
      gaugeB: _frac(points, pointsAll),
      gaugeBLabel: l.orbPoints,
      bigLabel: l.orbPoints,
      bigValue: '$points',
      bars: [
        for (final cat in AchievementCategory.values)
          () {
            final list = ach.where((a) => a.category == cat).toList();
            final done = list.where((a) => a.done).length;
            return OrbitBar(cat.label, l.fraction(done, list.length), _frac(done, list.length));
          }(),
      ],
    ),
    'settings': OrbitSectionInfo(
      cells: [
        OrbitMetric(l.orbTheme, styleName),
        OrbitMetric(l.orbMode, modeName),
        OrbitMetric(l.orbCurrency, cur.code),
        OrbitMetric(l.orbLanguage, kLanguages[lang] ?? lang),
      ],
      gaugeA: alertsOn ? 1.0 : 0.0,
      gaugeALabel: l.orbAlerts,
      gaugeB: remindersOn ? 1.0 : 0.0,
      gaugeBLabel: l.orbReminders,
      bigLabel: l.orbCurrency,
      bigValue: cur.code,
      bars: [
        OrbitBar(l.orbNotifications, alertsOn ? l.orbOn : l.orbOff, alertsOn ? 1.0 : 0.0),
        OrbitBar(l.orbReminders, remindersOn ? l.orbOn : l.orbOff, remindersOn ? 1.0 : 0.0),
        OrbitBar(l.orbInTrash, '${health.trashed}', _frac(health.trashed, accountsAll + health.trashed)),
        OrbitBar(l.orbDataIssues, '${health.issues}', _frac(health.issues, accountsAll)),
      ],
    ),
  };

  // ---- Insights row ----
  final pct = kpis.profitChangePct;
  final ranked = games.where((g) => g.count > 0).toList()
    ..sort((a, b) => b.profit.compareTo(a.profit));
  final top = ranked.isEmpty ? null : ranked.first;

  final insights = <OrbitInsight>[
    OrbitInsight(
      icon: Icons.payments_outlined,
      label: l.orbNetProfit,
      value: profitText,
      caption: pct == null
          ? l.orbNoMonthToCompare
          : l.orbPctOnLastMonth('${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(0)}'),
      captionIcon: pct != null && pct < 0 ? Icons.trending_down_rounded : Icons.trending_up_rounded,
      destId: 'profit',
    ),
    OrbitInsight(
      icon: Icons.sell_outlined,
      label: l.orbForSale,
      value: l.accountsCount(kpis.forSale),
      caption: kpis.forSale == 0 ? l.orbNothingListed : l.orbListedNoPrice,
      captionIcon: Icons.info_outline_rounded,
      destId: 'for-sale',
    ),
    OrbitInsight(
      icon: Icons.sports_esports_outlined,
      label: l.orbBestGame,
      value: top == null ? l.orbNoDataYet : top.game.name,
      caption: top == null
          ? l.orbAddToRank
          : l.orbFromAccounts(money(top.profit, currency: cur), top.count),
      captionIcon: Icons.info_outline_rounded,
      destId: 'games-stats',
    ),
    OrbitInsight(
      icon: Icons.workspace_premium_outlined,
      label: l.orbDiamondAccounts,
      value: '$diamonds',
      caption: l.orbOutOfGoogle(google.total),
      captionIcon: Icons.info_outline_rounded,
      destId: 'grades',
    ),
    OrbitInsight(
      icon: Icons.shield_outlined,
      label: l.orbDataHealth,
      value: health.issues == 0 ? l.orbAllClear : l.orbToReview(health.issues),
      caption: health.issues == 0
          ? l.orbNoDuplicatesOrIds
          : l.orbDuplicatesEmailsIds,
      captionIcon: health.issues == 0 ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
      destId: 'security',
    ),
    OrbitInsight(
      icon: Icons.military_tech_outlined,
      label: l.orbAchievements,
      value: l.fraction(achDone, ach.length),
      caption: pending.isEmpty ? l.orbEveryBadge : l.orbNext(pending.first.title),
      captionIcon: Icons.info_outline_rounded,
      destId: 'achievements',
    ),
  ];

  return OrbitData(sections: sections, insights: insights);
});
