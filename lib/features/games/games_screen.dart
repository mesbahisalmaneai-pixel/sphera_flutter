import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/game_logo.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/game_image_store.dart';
import '../../data/game_repository.dart';
import '../../data/providers.dart';
import 'game_accounts_screen.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  Future<String?> _askName(BuildContext context, String title, {String initial = ''}) {
    final c = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
            controller: c, autofocus: true, textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(hintText: 'Game name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: Text('Save')),
        ],
      ),
    );
  }

  void _toast(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final name = await _askName(context, 'Add game');
    if (name == null || name.isEmpty || !context.mounted) return;
    try {
      await ref.read(gameRepoProvider).addGame(name);
    } on DuplicateGameException catch (e) {
      if (context.mounted) _toast(context, e.toString());
    }
  }

  Future<void> _rename(BuildContext context, WidgetRef ref, Game g) async {
    final name = await _askName(context, 'Rename game', initial: g.name);
    if (name == null || name.isEmpty || !context.mounted) return;
    try {
      await ref.read(gameRepoProvider).renameGame(g.id, name);
    } on DuplicateGameException catch (e) {
      if (context.mounted) _toast(context, e.toString());
    }
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref, Game g, GameImageSlot slot) async {
    final store = ref.read(gameImageStoreProvider);
    final repo = ref.read(gameRepoProvider);
    try {
      final path = await store.pickAndSave(g.id, slot);
      if (path == null) return;
      final old = slot == GameImageSlot.card ? g.logoAssetPath : g.accountImagePath;
      if (slot == GameImageSlot.card) {
        await repo.setCardImage(g.id, path);
      } else {
        await repo.setAccountImage(g.id, path);
      }
      await store.deleteIfOurs(old);
    } catch (e) {
      if (context.mounted) _toast(context, 'Could not set image: $e');
    }
  }

  Future<void> _resetImages(WidgetRef ref, Game g) async {
    final store = ref.read(gameImageStoreProvider);
    final repo = ref.read(gameRepoProvider);
    await repo.setCardImage(g.id, null);
    await repo.setAccountImage(g.id, null);
    await store.deleteIfOurs(g.logoAssetPath);
    await store.deleteIfOurs(g.accountImagePath);
  }

  Future<void> _remove(BuildContext context, WidgetRef ref, Game g) async {
    final repo = ref.read(gameRepoProvider);
    final count = await repo.countGameAccounts(g.id);
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove ${g.name}?'),
        content: Text(count > 0
            ? '${g.name} has $count account(s). They are kept, but the game is hidden from the lists.'
            : 'The game will be hidden from the lists.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Remove', style: TextStyle(color: SpheraColors.danger))),
        ],
      ),
    );
    if (ok == true) await repo.archiveGame(g.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(activeGamesProvider).value ?? <Game>[];
    final counts = ref.watch(gameAccountCountsProvider).value ?? <String, int>{};
    return Scaffold(
      appBar: AppBar(title: Text('Games')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        backgroundColor: SpheraColors.gold,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(Icons.add),
        label: Text('Add game'),
      ),
      body: games.isEmpty
          ? Center(child: Text('No games yet', style: TextStyle(color: SpheraColors.muted)))
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 96),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.9),
              itemCount: games.length,
              itemBuilder: (_, i) {
                final g = games[i];
                final n = counts[g.id] ?? 0;
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => GameAccountsScreen(game: g))),
                    child: Stack(children: [
                      Column(children: [
                        Expanded(
                          child: GameImage(g,
                              width: double.infinity, height: double.infinity, radius: 0),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
                          child: Column(children: [
                            Text(g.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text('$n account${n == 1 ? '' : 's'}',
                                style: TextStyle(color: SpheraColors.gold, fontSize: 12)),
                          ]),
                        ),
                      ]),
                      Positioned(
                        top: 0, right: 0,
                        child: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, size: 20, color: SpheraColors.muted),
                          onSelected: (v) {
                            switch (v) {
                              case 'rename':
                                _rename(context, ref, g);
                              case 'card':
                                _pickImage(context, ref, g, GameImageSlot.card);
                              case 'account':
                                _pickImage(context, ref, g, GameImageSlot.account);
                              case 'reset':
                                _resetImages(ref, g);
                              case 'remove':
                                _remove(context, ref, g);
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(value: 'rename', child: Text('Rename')),
                            PopupMenuItem(value: 'card', child: Text('Change game image')),
                            PopupMenuItem(value: 'account', child: Text('Change account photo')),
                            PopupMenuItem(value: 'reset', child: Text('Reset images')),
                            PopupMenuItem(value: 'remove', child: Text('Remove')),
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
