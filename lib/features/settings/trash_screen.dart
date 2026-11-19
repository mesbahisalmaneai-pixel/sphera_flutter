import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/format.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/google_repository.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';

String _when(DateTime? d) => d == null ? '' : d.toLocal().toString().substring(0, 16);

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  Future<bool> _confirm(BuildContext context, String title, String body, String action) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(action, style: TextStyle(color: SpheraColors.danger))),
        ],
      ),
    );
    return ok == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final google = ref.watch(trashedGoogleAccountsProvider).value ?? <GoogleAccount>[];
    final gaming = ref.watch(trashedGameAccountsProvider).value ?? <GameAccount>[];
    final games = {for (final g in ref.watch(allGamesProvider).value ?? <Game>[]) g.id: g};
    final cur = ref.watch(currencyProvider);
    final gRepo = ref.read(googleRepoProvider);
    final aRepo = ref.read(gameAccountRepoProvider);
    final messenger = ScaffoldMessenger.of(context);
    final empty = google.isEmpty && gaming.isEmpty;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.trash),
          actions: [
            if (!empty)
              TextButton(
                onPressed: () async {
                  final ok = await _confirm(context, context.l10n.emptyTrashTitle,
                      context.l10n.emptyTrashBody(google.length + gaming.length),
                      context.l10n.deleteAll);
                  if (!ok) return;
                  for (final a in google) {
                    await gRepo.deletePermanently(a.id);
                  }
                  for (final a in gaming) {
                    await aRepo.deletePermanently(a.id);
                  }
                },
                child: Text(context.l10n.emptyAction, style: TextStyle(color: SpheraColors.danger)),
              ),
          ],
          bottom: TabBar(
            indicatorColor: SpheraColors.gold,
            labelColor: SpheraColors.gold,
            tabs: [Tab(text: context.l10n.googleTabCount(google.length)), Tab(text: context.l10n.gamesTabCount(gaming.length))],
          ),
        ),
        body: TabBarView(children: [
          google.isEmpty
              ? _Empty()
              : ListView(padding: EdgeInsets.all(12), children: [
                  for (final a in google)
                    Card(
                      child: ListTile(
                        title: Text(a.email, overflow: TextOverflow.ellipsis),
                        subtitle: Text(context.l10n.googleAccountDeleted(gradeLabel(a.grade), _when(a.deletedAt)),
                            style: TextStyle(fontSize: 12)),
                        isThreeLine: true,
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            tooltip: context.l10n.restore,
                            icon: Icon(Icons.restore, color: SpheraColors.gold),
                            onPressed: () async {
                              try {
                                await gRepo.restore(a.id);
                              } on DuplicateEmailException catch (e) {
                                messenger.showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            },
                          ),
                          IconButton(
                            tooltip: context.l10n.deletePermanently,
                            icon: Icon(Icons.delete_forever, color: SpheraColors.danger),
                            onPressed: () async {
                              if (await _confirm(context, context.l10n.deletePermanentlyTitle,
                                  context.l10n.deletedForGood(a.email), context.l10n.delete)) {
                                await gRepo.deletePermanently(a.id);
                              }
                            },
                          ),
                        ]),
                      ),
                    ),
                ]),
          gaming.isEmpty
              ? _Empty()
              : ListView(padding: EdgeInsets.all(12), children: [
                  for (final a in gaming)
                    Card(
                      child: ListTile(
                        title: Text(a.name, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                            '${games[a.gameId]?.name ?? context.l10n.unknownGame}${games[a.gameId]?.archivedAt != null ? context.l10n.removedSuffix : ''}'
                            ' · ${money(a.salePrice, currency: cur)}\n${context.l10n.deletedWhen(_when(a.deletedAt))}',
                            style: TextStyle(fontSize: 12)),
                        isThreeLine: true,
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            tooltip: context.l10n.restore,
                            icon: Icon(Icons.restore, color: SpheraColors.gold),
                            onPressed: () => aRepo.restore(a.id),
                          ),
                          IconButton(
                            tooltip: context.l10n.deletePermanently,
                            icon: Icon(Icons.delete_forever, color: SpheraColors.danger),
                            onPressed: () async {
                              if (await _confirm(context, context.l10n.deletePermanentlyTitle,
                                  context.l10n.deletedForGood(a.name), context.l10n.delete)) {
                                await aRepo.deletePermanently(a.id);
                              }
                            },
                          ),
                        ]),
                      ),
                    ),
                ]),
        ]),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.delete_outline, size: 48, color: SpheraColors.muted),
          SizedBox(height: 10),
          Text(context.l10n.trashIsEmpty, style: TextStyle(color: SpheraColors.muted)),
        ]),
      );
}
