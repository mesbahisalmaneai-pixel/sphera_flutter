import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/dashboard.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../games/game_account_detail_screen.dart';
import '../games/game_accounts_screen.dart' show StatusBadge;

/// Searches every gaming account (name, ID compte, game name, notes).
/// Same scope as the dashboard: not trashed, game not archived.
class AccountSearchDelegate extends SearchDelegate<void> {
  AccountSearchDelegate() : super(searchFieldLabel: 'Search accounts');

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            tooltip: 'Clear',
            icon: Icon(Icons.clear),
            onPressed: () => query = '',
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        tooltip: 'Back',
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _Results(query: query);

  @override
  Widget buildSuggestions(BuildContext context) => _Results(query: query);
}

class _Results extends ConsumerWidget {
  const _Results({required this.query});
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(dashboardAccountsProvider);
    final games = ref.watch(activeGamesProvider).value ?? const <Game>[];
    final gameName = {for (final g in games) g.id: g.name};
    final cur = ref.watch(currencyProvider);

    final q = query.trim().toLowerCase();
    final matches = accounts.where((a) {
      if (q.isEmpty) return true;
      return a.name.toLowerCase().contains(q) ||
          a.idCompte.toLowerCase().contains(q) ||
          (gameName[a.gameId] ?? '').toLowerCase().contains(q) ||
          (a.notes ?? '').toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    // With an empty query only show the most recently touched accounts.
    final shown = q.isEmpty ? matches.take(20).toList() : matches;

    if (shown.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(q.isEmpty ? 'No accounts yet' : 'No account found for "$query"',
              textAlign: TextAlign.center, style: TextStyle(color: SpheraColors.muted)),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: shown.length,
      separatorBuilder: (_, __) => Divider(height: 1),
      itemBuilder: (context, i) {
        final a = shown[i];
        return ListTile(
          title: Text(a.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
              '${gameName[a.gameId] ?? ''} · ID ${a.idCompte}'
              '${a.status == GameAccountStatus.forSale ? '' : ' · ${money(a.salePrice, currency: cur)}'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          trailing: StatusBadge(a.status),
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => GameAccountDetailScreen(accountId: a.id))),
        );
      },
    );
  }
}
