import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import 'box_sheet.dart';
import 'google_account_form.dart';
import 'manage_games_sheet.dart';

class GoogleAccountsScreen extends ConsumerStatefulWidget {
  const GoogleAccountsScreen({super.key});
  @override
  ConsumerState<GoogleAccountsScreen> createState() => _GoogleAccountsScreenState();
}

class _GoogleAccountsScreenState extends ConsumerState<GoogleAccountsScreen> {
  String _query = '';
  Grade? _grade;
  BoxStatus? _status;

  Future<void> _openForm({GoogleAccount? account, Map<String, BoxStatus> statuses = const {}}) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GoogleAccountForm(account: account, initialStatuses: statuses)));
  }

  void _boxSheet(GoogleAccount a, {String? onlyGameId}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SpheraColors.surface,
      builder: (_) => BoxSheet(account: a, onlyGameId: onlyGameId),
    );
  }

  void _manageGames() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SpheraColors.surface,
      builder: (_) => ManageGamesSheet(),
    );
  }

  Future<void> _trash(GoogleAccount a) async {
    final repo = ref.read(googleRepoProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    await repo.moveToTrash(a.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.movedToTrash(a.email)),
        action: SnackBarAction(label: l.undo, onPressed: () => repo.restore(a.id)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(googleAccountsProvider);
    final boxes = ref.watch(googleBoxesProvider).value ?? <GoogleGameBox>[];
    final games = ref.watch(activeGamesProvider).value ?? <Game>[];

    final byAccount = <String, Map<String, BoxStatus>>{};
    final updatedAt = <String, Map<String, DateTime>>{};
    for (final b in boxes) {
      (byAccount[b.googleAccountId] ??= {})[b.gameId] = b.status;
      (updatedAt[b.googleAccountId] ??= {})[b.gameId] = b.updatedAt;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.googlePlayAccounts),
        actions: [
          IconButton(
            tooltip: context.l10n.manageGamesLower,
            icon: Icon(Icons.sports_esports_outlined),
            onPressed: _manageGames,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: SpheraColors.gold,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(Icons.add),
        label: Text(context.l10n.addGoogleAccount),
      ),
      body: accounts.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.l10n.couldNotLoadAccounts('$e'))),
        data: (all) {
          final list = all.where((a) {
            if (_query.isNotEmpty && !a.email.contains(_query.toLowerCase())) return false;
            if (_grade != null && a.grade != _grade) return false;
            if (_status != null && !(byAccount[a.id]?.values.contains(_status) ?? false)) {
              return false;
            }
            return true;
          }).toList();

          return Column(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: context.l10n.searchByEmail, prefixIcon: Icon(Icons.search)),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _chip(context.l10n.allGrades, _grade == null, () => setState(() => _grade = null)),
                  for (final g in Grade.values)
                    _chip(gradeLabel(g), _grade == g, () => setState(() => _grade = g)),
                  SizedBox(width: 12),
                  _chip(context.l10n.anyStatus, _status == null, () => setState(() => _status = null)),
                  for (final s in BoxStatus.values)
                    _chip(boxLabel(s), _status == s, () => setState(() => _status = s)),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? _Empty(hasAny: all.isNotEmpty, onAdd: () => _openForm())
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 96),
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final a = list[i];
                        final st = byAccount[a.id] ?? {};
                        return _AccountCard(
                          account: a,
                          games: games,
                          statuses: st,
                          updated: updatedAt[a.id] ?? {},
                          onTap: () => _openForm(account: a, statuses: st),
                          onTrash: () => _trash(a),
                          onBox: ({String? gameId}) => _boxSheet(a, onlyGameId: gameId),
                        );
                      },
                    ),
            ),
          ]);
        },
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: EdgeInsetsDirectional.only(end: 8),
        child: FilterChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
      );
}

class _AccountCard extends StatelessWidget {
  const _AccountCard(
      {required this.account,
      required this.games,
      required this.statuses,
      required this.updated,
      required this.onTap,
      required this.onTrash,
      required this.onBox});
  final GoogleAccount account;
  final List<Game> games;
  final Map<String, BoxStatus> statuses;
  final Map<String, DateTime> updated;
  final VoidCallback onTap, onTrash;
  final void Function({String? gameId}) onBox;

  @override
  Widget build(BuildContext context) {
    // Only boxes that were actually set (not EMPTY), and only the 2 most recently
    // changed ones are shown; the rest are reachable via the "+N" chip.
    final setBoxes = games.where((g) => (statuses[g.id] ?? BoxStatus.empty) != BoxStatus.empty).toList()
      ..sort((a, b) => (updated[b.id] ?? DateTime(0)).compareTo(updated[a.id] ?? DateTime(0)));
    final shown = setBoxes.take(2).toList();
    final hidden = setBoxes.length - shown.length;
    final c = gradeColor(account.grade);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: c.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(children: [
          // Grade-coloured accent bar on the left edge.
          PositionedDirectional(start: 0, top: 0, bottom: 0, child: Container(width: 4, color: c)),
          Padding(
            padding: EdgeInsets.fromLTRB(18, 14, 4, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(child: GradeMedal(account.grade, size: 42)),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(account.email,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    SizedBox(height: 3),
                    Text(
                      '${gradeLabel(account.grade)}  \u00b7  ${context.l10n.boxesSet(setBoxes.length)}',
                      style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ]),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: SpheraColors.muted),
                  onSelected: (v) => v == 'edit' ? onTap() : onTrash(),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'edit', child: Text(context.l10n.edit)),
                    PopupMenuItem(value: 'trash', child: Text(context.l10n.moveToTrash)),
                  ],
                ),
              ]),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsetsDirectional.only(end: 14),
                child: Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final g in shown)
                    _BoxPill(name: g.name, status: statuses[g.id]!, onTap: () => onBox(gameId: g.id)),
                  ActionChip(
                    avatar: Icon(Icons.add, size: 16, color: SpheraColors.gold),
                    label: Text(hidden > 0 ? '+$hidden' : (setBoxes.isEmpty ? context.l10n.setBoxes : context.l10n.box),
                        style: TextStyle(fontSize: 12, color: SpheraColors.gold)),
                    side: BorderSide(color: SpheraColors.border),
                    onPressed: () => onBox(),
                  ),
                ]),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _BoxPill extends StatelessWidget {
  const _BoxPill({required this.name, required this.status, required this.onTap});
  final String name;
  final BoxStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = boxColor(status);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.withValues(alpha: 0.6)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          SizedBox(width: 7),
          Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          SizedBox(width: 6),
          Text(boxLabel(status), style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.hasAny, required this.onAdd});
  final bool hasAny;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.mail_outline, size: 48, color: SpheraColors.muted),
            SizedBox(height: 12),
            Text(hasAny ? context.l10n.noAccountMatches : context.l10n.noGoogleAccountsYet,
                style: TextStyle(color: SpheraColors.muted)),
            if (!hasAny) ...[
              SizedBox(height: 16),
              FilledButton(onPressed: onAdd, child: Text(context.l10n.addFirstAccount)),
            ],
          ]),
        ),
      );
}
