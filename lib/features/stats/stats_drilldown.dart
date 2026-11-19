import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/format.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../games/game_account_detail_screen.dart';
import '../games/game_accounts_screen.dart' show StatusBadge;

/// Les comptes Google d'un grade (mli tclicki 3la medaille).
class GradeAccountsScreen extends ConsumerWidget {
  const GradeAccountsScreen({super.key, required this.grade});
  final Grade grade;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(googleAccountsProvider).value ?? <GoogleAccount>[];
    final list = all.where((a) => a.deletedAt == null && a.grade == grade).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          GradeMedal(grade, size: 28),
          SizedBox(width: 10),
          Text('${gradeLabel(grade)} (${list.length})'),
        ]),
      ),
      body: list.isEmpty
          ? Center(child: Text(context.l10n.noAccountsInGrade, style: TextStyle(color: SpheraColors.muted)))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  leading: GradeMedal(grade, size: 34),
                  title: Text(list[i].email, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
    );
  }
}

/// Les comptes d'un game avec filtre All / Active / Sell.
class GameStatusAccountsScreen extends ConsumerStatefulWidget {
  const GameStatusAccountsScreen({super.key, required this.game, this.initial = 'all'});
  final Game game;
  final String initial; // 'all' | 'active' | 'sell'

  @override
  ConsumerState<GameStatusAccountsScreen> createState() => _GameStatusAccountsScreenState();
}

class _GameStatusAccountsScreenState extends ConsumerState<GameStatusAccountsScreen> {
  late String _filter = widget.initial;

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(gameAccountsProvider(widget.game.id));
    final cur = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.game.name)),
      body: accounts.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.l10n.couldNotLoadAccounts('$e'))),
        data: (all) {
          final live = all.where((a) => a.deletedAt == null).toList();
          final nActive = live.where((a) => a.status == GameAccountStatus.active).length;
          final nSell = live.where((a) => a.status == GameAccountStatus.sell).length;
          final list = live.where((a) {
            if (_filter == 'active') return a.status == GameAccountStatus.active;
            if (_filter == 'sell') return a.status == GameAccountStatus.sell;
            return true;
          }).toList();

          return Column(children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'all', label: Text('All ${live.length}')),
                  ButtonSegment(value: 'active', label: Text('Active $nActive')),
                  ButtonSegment(value: 'sell', label: Text('Sold $nSell')),
                ],
                selected: {_filter},
                onSelectionChanged: (s) => setState(() => _filter = s.first),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? Center(child: Text(context.l10n.noAccounts, style: TextStyle(color: SpheraColors.muted)))
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final a = list[i];
                        return Card(
                          child: ListTile(
                            title: Text(a.name, overflow: TextOverflow.ellipsis),
                            subtitle: Text(money(a.salePrice, currency: cur),
                                style: TextStyle(color: SpheraColors.gold)),
                            trailing: StatusBadge(a.status),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => GameAccountDetailScreen(accountId: a.id))),
                          ),
                        );
                      },
                    ),
            ),
          ]);
        },
      ),
    );
  }
}
