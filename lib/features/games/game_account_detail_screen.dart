import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/format.dart';
import '../../core/game_logo.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/game_account_repository.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import 'game_account_form.dart';
import 'game_accounts_screen.dart';

class GameAccountDetailScreen extends ConsumerWidget {
  const GameAccountDetailScreen({super.key, required this.accountId});
  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(gameAccountProvider(accountId)).value;
    final games = ref.watch(activeGamesProvider).value ?? <Game>[];
    if (a == null || a.deletedAt != null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(context.l10n.accountNoLongerAvailable)));
    }
    final game = games.where((g) => g.id == a.gameId).firstOrNull;
    final profit = profitOf(a);
    final cur = ref.watch(currencyProvider);
    final color = profit >= 0 ? SpheraColors.done : SpheraColors.danger;

    Future<void> pickPhoto() async {
      final store = ref.read(gameImageStoreProvider);
      final repo = ref.read(gameAccountRepoProvider);
      final messenger = ScaffoldMessenger.of(context);
      final l = context.l10n;
      try {
        final path = await store.pickAndSaveForAccount(a.id);
        if (path == null) return;
        final old = a.photoPath;
        await repo.setPhoto(a.id, path);
        await store.deleteIfOurs(old);
      } catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(l.couldNotSetPhoto('$e'))));
      }
    }

    Future<void> resetPhoto() async {
      final store = ref.read(gameImageStoreProvider);
      await ref.read(gameAccountRepoProvider).setPhoto(a.id, null);
      await store.deleteIfOurs(a.photoPath);
    }

    Widget row(String k, String v) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(k, style: TextStyle(color: SpheraColors.muted)),
            Flexible(child: Text(v, textAlign: TextAlign.end)),
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: Text(a.name), actions: [
        IconButton(
          tooltip: context.l10n.edit,
          icon: Icon(Icons.edit_outlined),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => GameAccountForm(game: game, account: a))),
        ),
      ]),
      body: ListView(padding: EdgeInsets.all(20), children: [
        if (game != null)
          Center(
              child: GameImage(game,
                  kind: GameImageKind.account, photoPath: a.photoPath, width: 180, height: 180, radius: 16)),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton.icon(
            onPressed: pickPhoto,
            icon: Icon(Icons.photo_library_outlined, size: 18),
            label: Text(context.l10n.changePhoto),
          ),
          if (a.photoPath != null)
            TextButton(onPressed: resetPhoto, child: Text(context.l10n.reset)),
        ]),
        SizedBox(height: 4),
        Center(child: StatusBadge(a.status)),
        SizedBox(height: 20),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              row(context.l10n.game, game?.name ?? context.l10n.removedGame),
              row(context.l10n.idCompte, a.idCompte),
              row(context.l10n.purchasePrice, money(a.purchasePrice, currency: cur)),
              row(context.l10n.salePrice, money(a.salePrice, currency: cur)),
              Divider(color: SpheraColors.border),
              row(profit >= 0 ? context.l10n.profit : context.l10n.loss, signedMoney(profit, currency: cur)),
            ]),
          ),
        ),
        if (a.notes != null) ...[
          SizedBox(height: 12),
          Card(child: Padding(padding: EdgeInsets.all(16), child: Text(a.notes!))),
        ],
        SizedBox(height: 8),
        Center(
            child: Text(signedMoney(profit, currency: cur),
                style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.w700))),
        SizedBox(height: 24),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              foregroundColor: SpheraColors.danger, minimumSize: Size(48, 48)),
          icon: Icon(Icons.delete_outline),
          label: Text(context.l10n.moveToTrash),
          onPressed: () async {
            final repo = ref.read(gameAccountRepoProvider);
            final messenger = ScaffoldMessenger.of(context);
            final nav = Navigator.of(context);
            final l = context.l10n;
            await repo.moveToTrash(a.id);
            nav.pop();
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(l.movedToTrash(a.name)),
                  action: SnackBarAction(label: l.undo, onPressed: () => repo.restore(a.id))));
          },
        ),
      ]),
    );
  }
}
