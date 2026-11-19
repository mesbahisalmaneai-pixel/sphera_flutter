import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/achievements.dart';
import '../../data/arena/arena_repository.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../../data/smart_tools.dart';
import '../shell/header_actions.dart';
import '../tools/duplicate_scanner_screen.dart';
import '../tools/inventory_vault_screen.dart';
import '../tools/security_center_screen.dart';
import '../tools/smart_organizer_screen.dart';

/// "Cards" tab: all the app cards (moved from Home) + the Smart Tools.
class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  Widget _section(String t) => Padding(
        padding: EdgeInsets.fromLTRB(4, 14, 0, 8),
        child: Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final google = ref.watch(googleAccountCountProvider).value ?? 0;
    final games = ref.watch(gameCountProvider).value ?? 0;
    final accounts = ref.watch(gameAccountCountProvider).value ?? 0;
    final profit = ref.watch(totalProfitProvider).value ?? 0.0;
    final cur = ref.watch(currencyProvider);
    final ach = ref.watch(achievementsProvider);
    final achSummary = '${ach.where((a) => a.done).length} / ${ach.length} unlocked';
    final arenaCount = ref.watch(arenaProvider).tournaments.length;
    final dups = ref.watch(duplicateGroupsProvider).length + ref.watch(gameDuplicateGroupsProvider).length;
    final vault = ref.watch(vaultProvider).length;
    final health = ref.watch(dataHealthProvider);

    void open(Widget screen) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    void named(String route) => Navigator.of(context).pushNamed(route);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cards'),
        actions: [HeaderActions(), SizedBox(width: 4)],
      ),
      body: ListView(padding: EdgeInsets.all(16), children: [
        _CardTile(
          icon: Icons.mail_outline,
          title: 'Google Play Accounts',
          subtitle: 'Grades & game boxes',
          summary: '$google accounts',
          onTap: () => named('/google'),
        ),
        _CardTile(
          icon: Icons.sports_esports_outlined,
          title: 'Games',
          subtitle: 'Gaming account inventory',
          summary: '$games games · $accounts accounts',
          onTap: () => named('/games'),
        ),
        _CardTile(
          icon: Icons.bar_chart_rounded,
          title: 'Statistics',
          subtitle: 'Profit, counts & statuses',
          summary: money(profit, currency: cur),
          onTap: () => named('/stats'),
        ),
        _CardTile(
          icon: Icons.tune_rounded,
          title: 'Tools & Settings',
          subtitle: 'Backup, trash, profile',
          summary: 'Manage',
          onTap: () => named('/tools'),
        ),
        _CardTile(
          icon: Icons.emoji_events_outlined,
          title: 'SPHERA TOURNAMENT ARENA',
          subtitle: 'Leagues, groups & knockouts',
          summary: arenaCount == 0 ? 'Create one' : '$arenaCount tournament${arenaCount == 1 ? '' : 's'}',
          onTap: () => named('/arena'),
        ),
        _CardTile(
          icon: Icons.military_tech_outlined,
          title: 'Achievements',
          subtitle: 'Badges & milestones',
          summary: achSummary,
          onTap: () => named('/achievements'),
        ),
        _section('Smart Tools'),
        _CardTile(
          icon: Icons.content_copy_outlined,
          title: 'Duplicate Scanner',
          subtitle: 'Find duplicate accounts, review manually',
          summary: dups == 0 ? 'No duplicates' : '$dups to review',
          onTap: () => open(DuplicateScannerScreen()),
        ),
        _CardTile(
          icon: Icons.manage_search_rounded,
          title: 'Smart Organizer',
          subtitle: 'Search, filter & sort accounts',
          summary: 'By game, status, grade & date',
          onTap: () => open(SmartOrganizerScreen()),
        ),
        _CardTile(
          icon: Icons.inventory_2_outlined,
          title: 'Inventory Vault',
          subtitle: 'Favourite, rare & high-value accounts',
          summary: '$vault in vault',
          onTap: () => open(InventoryVaultScreen()),
        ),
        _CardTile(
          icon: Icons.shield_outlined,
          title: 'Security Center',
          subtitle: 'Data health, backup & sync status',
          summary: health.issues == 0 ? 'All good' : '${health.issues} to review',
          onTap: () => open(SecurityCenterScreen()),
        ),
      ]),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.summary,
      required this.onTap});
  final IconData icon;
  final String title, subtitle, summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Row(children: [
            Icon(icon, color: SpheraColors.gold, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                SizedBox(height: 6),
                Text(summary, style: TextStyle(color: SpheraColors.gold, fontSize: 12)),
              ]),
            ),
            Icon(Icons.chevron_right, color: SpheraColors.muted),
          ]),
        ),
      ),
    );
  }
}
