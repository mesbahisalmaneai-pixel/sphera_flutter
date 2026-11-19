import 'package:flutter/material.dart' show IconData, Icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
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
        cells: [OrbitMetric('Screens', '$screens')],
        gaugeA: 0,
        gaugeALabel: '',
        gaugeB: 0,
        gaugeBLabel: '',
        bigLabel: 'Screens',
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

String _gradeName(Grade g) => g.name[0].toUpperCase() + g.name.substring(1);

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
    ThemeModeSetting.dark => 'Dark',
    ThemeModeSetting.light => 'Light',
    ThemeModeSetting.system => 'System',
  };
  final alertsOn = notif.enabled;
  final remindersOn = notif.enabled && notif.reminders;

  final sections = <String, OrbitSectionInfo>{
    'stats': OrbitSectionInfo(
      cells: [
        OrbitMetric('Net profit', profitText),
        OrbitMetric('Accounts', '${kpis.total}'),
        OrbitMetric('Sold', '${kpis.sold}'),
        OrbitMetric('For sale', '${kpis.forSale}'),
      ],
      gaugeA: _frac(kpis.active, kpis.total),
      gaugeALabel: 'Active',
      gaugeB: _frac(kpis.sold, kpis.total),
      gaugeBLabel: 'Sold',
      bigLabel: 'Net profit',
      bigValue: profitText,
      bars: [
        OrbitBar('Active', '${kpis.active}', _frac(kpis.active, kpis.total)),
        OrbitBar('Sold', '${kpis.sold}', _frac(kpis.sold, kpis.total)),
        OrbitBar('For sale', '${kpis.forSale}', _frac(kpis.forSale, kpis.total)),
        OrbitBar('Added this month', '${kpis.addedThisMonth}', _frac(kpis.addedThisMonth, kpis.total)),
      ],
    ),
    'cards': OrbitSectionInfo(
      cells: [
        OrbitMetric('Google accounts', '${google.total}'),
        OrbitMetric('Gaming accounts', '${kpis.total}'),
        OrbitMetric('Duplicates', '$duplicates'),
        OrbitMetric('In vault', '${vault.length}'),
      ],
      gaugeA: accountsAll == 0 ? 1.0 : 1.0 - _frac(health.issues, accountsAll),
      gaugeALabel: 'Clean',
      gaugeB: _frac(vault.length, accountsAll),
      gaugeBLabel: 'In vault',
      bigLabel: 'Duplicates',
      bigValue: '$duplicates',
      bars: [
        OrbitBar('Google duplicates', '${health.duplicates}', _frac(health.duplicates, google.total)),
        OrbitBar('Same account ID', '${health.gameDuplicates}', _frac(health.gameDuplicates, kpis.total)),
        OrbitBar('In vault', '${vault.length}', _frac(vault.length, accountsAll)),
      ],
    ),
    'games': OrbitSectionInfo(
      cells: [
        OrbitMetric('Games', '${games.length}'),
        OrbitMetric('Accounts', '${kpis.total}'),
        OrbitMetric('Active', '${kpis.active}'),
        OrbitMetric('For sale', '${kpis.forSale}'),
      ],
      gaugeA: _frac(kpis.active, kpis.total),
      gaugeALabel: 'Active',
      gaugeB: _frac(kpis.forSale, kpis.total),
      gaugeBLabel: 'Listed',
      bigLabel: 'Gaming accounts',
      bigValue: '${kpis.total}',
      bars: [
        for (final g in byCount.take(6)) OrbitBar(g.game.name, '${g.count}', _frac(g.count, maxCount)),
      ],
    ),
    'google': OrbitSectionInfo(
      cells: [
        OrbitMetric('Accounts', '${google.total}'),
        OrbitMetric('Boxes set', '$boxesSet'),
        OrbitMetric('Diamond', '$diamonds'),
        OrbitMetric('Interdit', '${google.byGrade[Grade.interdit] ?? 0}'),
      ],
      gaugeA: _frac(boxesDone, boxesTotal),
      gaugeALabel: 'Done',
      gaugeB: _frac(premium, google.total),
      gaugeBLabel: 'Premium',
      bigLabel: 'Google accounts',
      bigValue: '${google.total}',
      bars: [
        for (final g in Grade.values)
          OrbitBar(_gradeName(g), '${google.byGrade[g] ?? 0}', _frac(google.byGrade[g] ?? 0, google.total)),
      ],
    ),
    'profile': OrbitSectionInfo(
      cells: [
        OrbitMetric('Name', profile.name.trim().isEmpty ? 'Not set' : profile.name.trim()),
        OrbitMetric('Unlocked', '$achDone / ${ach.length}'),
        OrbitMetric('Points', '$points'),
        OrbitMetric('Next goal', pending.isEmpty ? 'All done' : pending.first.title),
      ],
      gaugeA: _frac(achDone, ach.length),
      gaugeALabel: 'Unlocked',
      gaugeB: _frac(points, pointsAll),
      gaugeBLabel: 'Points',
      bigLabel: 'Points',
      bigValue: '$points',
      bars: [
        for (final cat in AchievementCategory.values)
          () {
            final list = ach.where((a) => a.category == cat).toList();
            final done = list.where((a) => a.done).length;
            return OrbitBar(cat.label, '$done / ${list.length}', _frac(done, list.length));
          }(),
      ],
    ),
    'settings': OrbitSectionInfo(
      cells: [
        OrbitMetric('Theme', styleName),
        OrbitMetric('Mode', modeName),
        OrbitMetric('Currency', cur.code),
        OrbitMetric('Language', kLanguages[lang] ?? lang),
      ],
      gaugeA: alertsOn ? 1.0 : 0.0,
      gaugeALabel: 'Alerts',
      gaugeB: remindersOn ? 1.0 : 0.0,
      gaugeBLabel: 'Reminders',
      bigLabel: 'Currency',
      bigValue: cur.code,
      bars: [
        OrbitBar('Notifications', alertsOn ? 'On' : 'Off', alertsOn ? 1.0 : 0.0),
        OrbitBar('Reminders', remindersOn ? 'On' : 'Off', remindersOn ? 1.0 : 0.0),
        OrbitBar('In trash', '${health.trashed}', _frac(health.trashed, accountsAll + health.trashed)),
        OrbitBar('Data issues', '${health.issues}', _frac(health.issues, accountsAll)),
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
      label: 'Net profit',
      value: profitText,
      caption: pct == null
          ? 'No month to compare yet'
          : '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(0)}% on last month',
      captionIcon: pct != null && pct < 0 ? Icons.trending_down_rounded : Icons.trending_up_rounded,
      destId: 'profit',
    ),
    OrbitInsight(
      icon: Icons.sell_outlined,
      label: 'For sale',
      value: '${kpis.forSale} ${kpis.forSale == 1 ? 'account' : 'accounts'}',
      caption: kpis.forSale == 0 ? 'Nothing listed right now' : 'Listed, no price set yet',
      captionIcon: Icons.info_outline_rounded,
      destId: 'for-sale',
    ),
    OrbitInsight(
      icon: Icons.sports_esports_outlined,
      label: 'Best game',
      value: top == null ? 'No data yet' : top.game.name,
      caption: top == null
          ? 'Add a game account to rank games'
          : '${money(top.profit, currency: cur)} from ${top.count} accounts',
      captionIcon: Icons.info_outline_rounded,
      destId: 'games-stats',
    ),
    OrbitInsight(
      icon: Icons.workspace_premium_outlined,
      label: 'Diamond accounts',
      value: '$diamonds',
      caption: 'Out of ${google.total} Google accounts',
      captionIcon: Icons.info_outline_rounded,
      destId: 'grades',
    ),
    OrbitInsight(
      icon: Icons.shield_outlined,
      label: 'Data health',
      value: health.issues == 0 ? 'All clear' : '${health.issues} to review',
      caption: health.issues == 0
          ? 'No duplicates or missing IDs'
          : 'Duplicates, bad emails or missing IDs',
      captionIcon: health.issues == 0 ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
      destId: 'security',
    ),
    OrbitInsight(
      icon: Icons.military_tech_outlined,
      label: 'Achievements',
      value: '$achDone / ${ach.length}',
      caption: pending.isEmpty ? 'Every badge unlocked' : 'Next: ${pending.first.title}',
      captionIcon: Icons.info_outline_rounded,
      destId: 'achievements',
    ),
  ];

  return OrbitData(sections: sections, insights: insights);
});
