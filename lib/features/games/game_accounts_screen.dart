import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/format.dart';
import '../../core/game_logo.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import 'game_account_detail_screen.dart';
import 'game_account_form.dart';

Color statusColor(GameAccountStatus s) => switch (s) {
      GameAccountStatus.active => SpheraColors.done,
      GameAccountStatus.sell => SpheraColors.danger,
      GameAccountStatus.forSale => SpheraColors.coming,
    };
String statusLabel(GameAccountStatus s) => switch (s) {
      GameAccountStatus.active => appL10n.statusActive,
      GameAccountStatus.sell => appL10n.statusSold,
      GameAccountStatus.forSale => appL10n.statusForSale,
    };

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key});
  final GameAccountStatus status;
  @override
  Widget build(BuildContext context) {
    final c = statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: c.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.withValues(alpha: 0.7))),
      child: Text(statusLabel(status), style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class GameAccountsScreen extends ConsumerWidget {
  const GameAccountsScreen({super.key, required this.game});
  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Re-read the game so a rename is reflected immediately.
    final games = ref.watch(activeGamesProvider).value ?? <Game>[];
    final g = games.where((x) => x.id == game.id).firstOrNull ?? game;
    final accounts = ref.watch(gameAccountsProvider(game.id));
    final cur = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          GameLogo(g, size: 28),
          SizedBox(width: 10),
          Expanded(child: Text(g.name, overflow: TextOverflow.ellipsis)),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => GameAccountForm(game: g))),
        backgroundColor: SpheraColors.gold,
        foregroundColor: Colors.black,
        icon: Icon(Icons.add),
        label: Text(context.l10n.addAccountShort),
      ),
      body: accounts.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.l10n.couldNotLoadAccounts('$e'))),
        data: (list) => list.isEmpty
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  GameImage(g, width: 160, height: 100),
                  SizedBox(height: 12),
                  Text(context.l10n.noAccountsYetShort, style: TextStyle(color: SpheraColors.muted)),
                ]),
              )
            : GridView.builder(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 96),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.78),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final a = list[i];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => GameAccountDetailScreen(accountId: a.id))),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Expanded(
                            child: GameImage(g,
                                kind: GameImageKind.account,
                                photoPath: a.photoPath,
                                width: double.infinity,
                                height: double.infinity,
                                radius: 10),
                          ),
                          SizedBox(height: 8),
                          Text(a.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text(money(a.salePrice, currency: cur), style: TextStyle(color: SpheraColors.gold)),
                          SizedBox(height: 6),
                          StatusBadge(a.status),
                        ]),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
