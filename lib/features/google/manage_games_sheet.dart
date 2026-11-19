import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/game_repository.dart';
import '../../data/providers.dart';

/// Add a game (creates an EMPTY box on every Google account) or remove one
/// (archived: accounts and statuses are kept, the game just disappears).
class ManageGamesSheet extends ConsumerStatefulWidget {
  const ManageGamesSheet({super.key});
  @override
  ConsumerState<ManageGamesSheet> createState() => _ManageGamesSheetState();
}

class _ManageGamesSheetState extends ConsumerState<ManageGamesSheet> {
  final _name = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    if (_busy) return;
    final l = context.l10n;
    final n = _name.text.trim();
    if (n.isEmpty) {
      setState(() => _error = l.enterGameName);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(gameRepoProvider).addGame(n);
      _name.clear();
    } on DuplicateGameException catch (e) {
      _error = l.errDuplicateGame(e.name);
    } catch (e) {
      _error = l.couldNotAddGame('$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(Game g) async {
    final repo = ref.read(gameRepoProvider);
    final count = await repo.countGameAccounts(g.id);
    if (!mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.removeGameTitle(g.name)),
        content: Text(count > 0
            ? context.l10n.removeGameWithAccounts(g.name, count)
            : context.l10n.removeGameNoAccounts),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(context.l10n.remove, style: TextStyle(color: SpheraColors.danger))),
        ],
      ),
    );
    if (ok == true) await repo.archiveGame(g.id);
  }

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(activeGamesProvider).value ?? <Game>[];
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.l10n.manageGamesLower, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: context.l10n.newGameName),
                  onSubmitted: (_) => _add(),
                ),
              ),
              SizedBox(width: 10),
              FilledButton(onPressed: _busy ? null : _add, child: Text(context.l10n.add)),
            ]),
            if (_error != null)
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(_error!, style: TextStyle(color: SpheraColors.danger)),
              ),
            SizedBox(height: 12),
            for (final g in games)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(g.name),
                trailing: IconButton(
                  tooltip: context.l10n.removeGame,
                  icon: Icon(Icons.delete_outline, color: SpheraColors.muted),
                  onPressed: () => _remove(g),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
