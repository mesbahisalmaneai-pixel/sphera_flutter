import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme.dart';
import '../../data/arena/arena_engine.dart';
import '../../data/arena/arena_models.dart';
import '../../data/arena/arena_repository.dart';

/// Applies [change] to the latest copy of the tournament, saves it and tells
/// the organizer what happened. Returns true when the change was saved.
Future<bool> _change(
  BuildContext context,
  WidgetRef ref,
  String id,
  Tournament Function(Tournament t) change,
  String success,
) async {
  final current = ref.read(arenaProvider).byId(id);
  if (current == null) return false;
  var message = success;
  var ok = true;
  try {
    await ref.read(arenaProvider.notifier).update(change(current));
  } on ArenaError catch (e) {
    message = e.message;
    ok = false;
  }
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  return ok;
}

Future<String?> _prompt(BuildContext context, {required String title, String initial = '', String label = 'Name'}) async {
  final c = TextEditingController(text: initial);
  final r = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(controller: c, autofocus: true, decoration: InputDecoration(labelText: label)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: const Text('Save')),
      ],
    ),
  );
  return (r == null || r.isEmpty) ? null : r;
}

Future<bool> _confirm(BuildContext context, String title, String body, {String action = 'Confirm'}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(action)),
      ],
    ),
  );
  return r ?? false;
}

/// Teams and players of a tournament: search, edit rosters, swap two teams or
/// two players (also across teams). Works for every game and mode.
class TeamManagementScreen extends ConsumerStatefulWidget {
  const TeamManagementScreen({super.key, required this.tournamentId});
  final String tournamentId;

  @override
  ConsumerState<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends ConsumerState<TeamManagementScreen> {
  String _query = '';

  Future<void> _edit(Tournament t, ArenaParticipant p) async {
    if (t.gameMode?.isTeamMode ?? false) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => _TeamSheet(tournamentId: t.id, participantId: p.id),
      );
      return;
    }
    final name = await _prompt(context, title: 'Rename player', initial: p.name);
    if (name == null || !mounted) return;
    await _change(context, ref, t.id, (cur) => ArenaEngine.renameParticipant(cur, p.id, name), 'Name updated.');
  }

  Future<ArenaDropdownPair?> _pick(
    String title,
    String labelA,
    String labelB,
    List<DropdownMenuItem<String>> items,
    String action,
  ) {
    String? a;
    String? b;
    return showDialog<ArenaDropdownPair>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(title),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(
              initialValue: a,
              isExpanded: true,
              decoration: InputDecoration(labelText: labelA),
              items: items,
              onChanged: (v) => setS(() => a = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: b,
              isExpanded: true,
              decoration: InputDecoration(labelText: labelB),
              items: items,
              onChanged: (v) => setS(() => b = v),
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: a != null && b != null && a != b ? () => Navigator.pop(ctx, ArenaDropdownPair(a!, b!)) : null,
              child: Text(action),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _swapTeams(Tournament t, {required String noun}) async {
    if (t.participants.length < 2) return;
    final items = [
      for (final p in t.participants)
        DropdownMenuItem(value: p.id, child: Text(p.name, overflow: TextOverflow.ellipsis)),
    ];
    final pair = await _pick('Swap ${noun}s', '$noun A', '$noun B', items, 'Swap');
    if (pair == null || !mounted) return;
    final a = t.participants.firstWhere((p) => p.id == pair.a);
    final b = t.participants.firstWhere((p) => p.id == pair.b);
    final ok = await _confirm(
      context,
      'Swap ${a.name} and ${b.name}?',
      '${a.name} takes the place of ${b.name} in the draw, and the other way round. '
          'Each ${noun.toLowerCase()} keeps its own players.',
      action: 'Swap ${noun}s',
    );
    if (!ok || !mounted) return;
    await _change(context, ref, t.id, (cur) => ArenaEngine.swapParticipants(cur, pair.a, pair.b),
        '${a.name} and ${b.name} swapped.');
  }

  Future<void> _swapPlayers(Tournament t) async {
    final items = <DropdownMenuItem<String>>[
      for (final p in t.participants)
        for (final pl in p.roster)
          DropdownMenuItem(
            value: '${p.id}|${pl.id}',
            child: Text('${pl.name} · ${p.name}', overflow: TextOverflow.ellipsis),
          ),
    ];
    if (items.length < 2) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Add player names to at least two spots first.')));
      return;
    }
    final pair = await _pick('Swap Players', 'Player A', 'Player B', items, 'Swap');
    if (pair == null || !mounted) return;
    final a = pair.a.split('|');
    final b = pair.b.split('|');
    final pa = t.participants.firstWhere((p) => p.id == a[0]);
    final pb = t.participants.firstWhere((p) => p.id == b[0]);
    final na = pa.roster.firstWhere((r) => r.id == a[1]).name;
    final nb = pb.roster.firstWhere((r) => r.id == b[1]).name;
    final ok = await _confirm(
      context,
      'Swap $na and $nb?',
      '$na (${pa.name}) and $nb (${pb.name}) exchange teams. Team sizes do not change.',
      action: 'Swap Players',
    );
    if (!ok || !mounted) return;
    await _change(context, ref, t.id, (cur) => ArenaEngine.swapPlayers(cur, a[0], a[1], b[0], b[1]),
        '$na and $nb swapped.');
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(arenaProvider).byId(widget.tournamentId);
    if (t == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Teams and players')),
        body: Center(child: Text('This tournament no longer exists.', style: TextStyle(color: SpheraColors.muted))),
      );
    }
    final mode = t.gameMode;
    final teamMode = mode?.isTeamMode ?? false;
    final q = _query.trim().toLowerCase();
    final shown = [
      for (final p in t.participants)
        if (q.isEmpty || p.name.toLowerCase().contains(q) || p.roster.any((r) => r.name.toLowerCase().contains(q))) p,
    ];
    final totalPlayers = t.participants.fold<int>(0, (sum, p) => sum + p.players);
    return Scaffold(
      appBar: AppBar(title: Text(teamMode ? 'Teams and players' : 'Players')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: teamMode ? 'Search teams or players' : 'Search players',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Text(
              teamMode
                  ? '${t.participants.length} teams · $totalPlayers players'
                  : '${t.participants.length} players',
              style: TextStyle(color: SpheraColors.muted, fontSize: 12),
            ),
            const Spacer(),
            if (t.hasConfirmedResults)
              Text('Played teams are locked', style: TextStyle(color: SpheraColors.gold, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: shown.isEmpty
              ? Center(child: Text('Nothing found.', style: TextStyle(color: SpheraColors.muted)))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    for (final p in shown)
                      _TeamCard(
                        index: t.participants.indexOf(p) + 1,
                        participant: p,
                        maxPlayers: mode?.teamSize ?? 1,
                        teamMode: teamMode,
                        query: q,
                        onTap: () => _edit(t, p),
                      ),
                  ],
                ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(children: [
              if (teamMode) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    onPressed: t.participants.length < 2 ? null : () => _swapTeams(t, noun: 'Team'),
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Swap Teams'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  onPressed: t.participants.length < 2
                      ? null
                      : (teamMode ? () => _swapPlayers(t) : () => _swapTeams(t, noun: 'Player')),
                  icon: const Icon(Icons.swap_vert),
                  label: const Text('Swap Players'),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

/// The two ids picked in a swap dialog.
class ArenaDropdownPair {
  const ArenaDropdownPair(this.a, this.b);
  final String a;
  final String b;
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({
    required this.index,
    required this.participant,
    required this.maxPlayers,
    required this.teamMode,
    required this.query,
    required this.onTap,
  });
  final int index;
  final ArenaParticipant participant;
  final int maxPlayers;
  final bool teamMode;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = participant;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: SpheraColors.gold.withValues(alpha: 0.45)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: SpheraColors.gold.withValues(alpha: 0.18),
                child: Text('$index', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(p.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              if (teamMode)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: SpheraColors.surfaceHigh,
                    border: Border.all(color: SpheraColors.border),
                  ),
                  child: Text('${p.players} / $maxPlayers players',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              const SizedBox(width: 4),
              Icon(Icons.edit_outlined, size: 18, color: SpheraColors.muted),
            ]),
            if (teamMode) ...[
              const SizedBox(height: 10),
              if (p.roster.isEmpty)
                Text('No player names yet. Tap to add them.',
                    style: TextStyle(color: SpheraColors.muted, fontSize: 12))
              else
                Wrap(spacing: 6, runSpacing: 6, children: [
                  for (final r in p.roster)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: query.isNotEmpty && r.name.toLowerCase().contains(query)
                            ? SpheraColors.gold.withValues(alpha: 0.2)
                            : SpheraColors.surfaceHigh,
                        border: Border.all(
                            color: query.isNotEmpty && r.name.toLowerCase().contains(query)
                                ? SpheraColors.gold
                                : SpheraColors.border),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.person, size: 14, color: SpheraColors.gold),
                        const SizedBox(width: 4),
                        Text(r.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                ]),
            ],
          ]),
        ),
      ),
    );
  }
}

/// Edit one team: rename it, rename/add/remove its players.
class _TeamSheet extends ConsumerWidget {
  const _TeamSheet({required this.tournamentId, required this.participantId});
  final String tournamentId;
  final String participantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(arenaProvider).byId(tournamentId);
    final p = t?.participants.where((x) => x.id == participantId).firstOrNull;
    final mode = t?.gameMode;
    if (t == null || p == null || mode == null) {
      return const SizedBox(height: 120, child: Center(child: Text('Team not found.')));
    }
    final canAdd = !mode.fixedTeamSize && p.roster.length < mode.teamSize;
    final canRemove = !mode.fixedTeamSize && p.roster.length > 1;

    Future<void> rename() async {
      final name = await _prompt(context, title: 'Rename team', initial: p.name, label: 'Team name');
      if (name == null || !context.mounted) return;
      await _change(context, ref, tournamentId, (cur) => ArenaEngine.renameParticipant(cur, participantId, name),
          'Team renamed.');
    }

    Future<void> add() async {
      final name = await _prompt(context, title: 'Add player', label: 'Player name');
      if (name == null || !context.mounted) return;
      final player = ArenaPlayer(id: const Uuid().v4(), name: name);
      await _change(context, ref, tournamentId, (cur) {
        final pp = cur.participants.firstWhere((x) => x.id == participantId);
        return ArenaEngine.setRoster(cur, participantId, [...pp.roster, player]);
      }, '$name added.');
    }

    Future<void> renamePlayer(ArenaPlayer r) async {
      final name = await _prompt(context, title: 'Rename player', initial: r.name, label: 'Player name');
      if (name == null || !context.mounted) return;
      await _change(context, ref, tournamentId, (cur) {
        final pp = cur.participants.firstWhere((x) => x.id == participantId);
        return ArenaEngine.setRoster(
            cur, participantId, [for (final x in pp.roster) x.id == r.id ? x.copyWith(name: name) : x]);
      }, 'Player renamed.');
    }

    Future<void> remove(ArenaPlayer r) async {
      final ok = await _confirm(context, 'Remove ${r.name}?', '${r.name} leaves ${p.name}.', action: 'Remove');
      if (!ok || !context.mounted) return;
      await _change(context, ref, tournamentId, (cur) {
        final pp = cur.participants.firstWhere((x) => x.id == participantId);
        return ArenaEngine.setRoster(cur, participantId, [for (final x in pp.roster) if (x.id != r.id) x]);
      }, '${r.name} removed.');
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(p.name,
                maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          IconButton(onPressed: rename, icon: const Icon(Icons.edit_outlined)),
        ]),
        Text('${p.players} / ${mode.teamSize} players',
            style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        if (mode.fixedTeamSize)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text('Teams in ${mode.label} always have exactly ${mode.teamSize} players. Use Swap Players to exchange members.',
                style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: p.roster.isEmpty
              ? Center(child: Text('No player names yet.', style: TextStyle(color: SpheraColors.muted)))
              : ListView(children: [
                  for (final r in p.roster)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.person, color: SpheraColors.gold),
                      title: Text(r.name),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(onPressed: () => renamePlayer(r), icon: const Icon(Icons.edit_outlined, size: 20)),
                        IconButton(
                            onPressed: canRemove ? () => remove(r) : null,
                            icon: const Icon(Icons.delete_outline, size: 20)),
                      ]),
                    ),
                ]),
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: canAdd ? add : null,
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Add player'),
          ),
        ),
      ]),
    );
  }
}
