import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n.dart';
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

Future<String?> _prompt(BuildContext context, {required String title, String initial = '', String? label}) async {
  final c = TextEditingController(text: initial);
  final r = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(controller: c, autofocus: true, decoration: InputDecoration(labelText: label ?? context.l10n.name)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: Text(context.l10n.save)),
      ],
    ),
  );
  return (r == null || r.isEmpty) ? null : r;
}

Future<bool> _confirm(BuildContext context, String title, String body, {String? action}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(action ?? context.l10n.confirm)),
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
    final name = await _prompt(context, title: context.l10n.renamePlayer, initial: p.name);
    if (name == null || !mounted) return;
    await _change(context, ref, t.id, (cur) => ArenaEngine.renameParticipant(cur, p.id, name), context.l10n.nameUpdated);
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
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel)),
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
    final l = context.l10n;
    final teams = noun == 'Team';
    final pair = await _pick(teams ? l.swapTeams : l.swapPlayers, teams ? l.teamA : l.playerA,
        teams ? l.teamB : l.playerB, items, l.swap);
    if (pair == null || !mounted) return;
    final a = t.participants.firstWhere((p) => p.id == pair.a);
    final b = t.participants.firstWhere((p) => p.id == pair.b);
    final ok = await _confirm(
      context,
      l.swapQuestion(a.name, b.name),
      teams ? l.swapTeamsBody(a.name, b.name) : l.swapSoloBody(a.name, b.name),
      action: teams ? l.swapTeams : l.swapPlayers,
    );
    if (!ok || !mounted) return;
    await _change(context, ref, t.id, (cur) => ArenaEngine.swapParticipants(cur, pair.a, pair.b),
        l.swapped(a.name, b.name));
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
          .showSnackBar(SnackBar(content: Text(context.l10n.addPlayersFirst)));
      return;
    }
    final l = context.l10n;
    final pair = await _pick(l.swapPlayers, l.playerA, l.playerB, items, l.swap);
    if (pair == null || !mounted) return;
    final a = pair.a.split('|');
    final b = pair.b.split('|');
    final pa = t.participants.firstWhere((p) => p.id == a[0]);
    final pb = t.participants.firstWhere((p) => p.id == b[0]);
    final na = pa.roster.firstWhere((r) => r.id == a[1]).name;
    final nb = pb.roster.firstWhere((r) => r.id == b[1]).name;
    final ok = await _confirm(
      context,
      l.swapQuestion(na, nb),
      l.swapPlayersBody(na, pa.name, nb, pb.name),
      action: l.swapPlayers,
    );
    if (!ok || !mounted) return;
    await _change(context, ref, t.id, (cur) => ArenaEngine.swapPlayers(cur, a[0], a[1], b[0], b[1]),
        l.swapped(na, nb));
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(arenaProvider).byId(widget.tournamentId);
    if (t == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.teamsAndPlayers)),
        body: Center(child: Text(context.l10n.tournamentGone, style: TextStyle(color: SpheraColors.muted))),
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
      appBar: AppBar(title: Text(teamMode ? context.l10n.teamsAndPlayers : context.l10n.players)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: teamMode ? context.l10n.searchTeamsOrPlayers : context.l10n.searchPlayers,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Text(
              teamMode
                  ? context.l10n.teamsAndPlayersCount(t.participants.length, totalPlayers)
                  : context.l10n.playersCount(t.participants.length),
              style: TextStyle(color: SpheraColors.muted, fontSize: 12),
            ),
            const Spacer(),
            if (t.hasConfirmedResults)
              Text(context.l10n.playedTeamsLocked, style: TextStyle(color: SpheraColors.gold, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: shown.isEmpty
              ? Center(child: Text(context.l10n.nothingFound, style: TextStyle(color: SpheraColors.muted)))
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
                    label: Text(context.l10n.swapTeams),
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
                  label: Text(context.l10n.swapPlayers),
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
                  child: Text(context.l10n.playersOfMax(p.players, maxPlayers),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              const SizedBox(width: 4),
              Icon(Icons.edit_outlined, size: 18, color: SpheraColors.muted),
            ]),
            if (teamMode) ...[
              const SizedBox(height: 10),
              if (p.roster.isEmpty)
                Text(context.l10n.noPlayerNamesTap,
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
      return SizedBox(height: 120, child: Center(child: Text(context.l10n.teamNotFound)));
    }
    final canAdd = !mode.fixedTeamSize && p.roster.length < mode.teamSize;
    final canRemove = !mode.fixedTeamSize && p.roster.length > 1;

    Future<void> rename() async {
      final name = await _prompt(context, title: context.l10n.renameTeam, initial: p.name, label: context.l10n.teamName);
      if (name == null || !context.mounted) return;
      await _change(context, ref, tournamentId, (cur) => ArenaEngine.renameParticipant(cur, participantId, name),
          context.l10n.teamRenamed);
    }

    Future<void> add() async {
      final name = await _prompt(context, title: context.l10n.addPlayer, label: context.l10n.playerName);
      if (name == null || !context.mounted) return;
      final player = ArenaPlayer(id: const Uuid().v4(), name: name);
      await _change(context, ref, tournamentId, (cur) {
        final pp = cur.participants.firstWhere((x) => x.id == participantId);
        return ArenaEngine.setRoster(cur, participantId, [...pp.roster, player]);
      }, context.l10n.nameAdded(name));
    }

    Future<void> renamePlayer(ArenaPlayer r) async {
      final name = await _prompt(context, title: context.l10n.renamePlayer, initial: r.name, label: context.l10n.playerName);
      if (name == null || !context.mounted) return;
      await _change(context, ref, tournamentId, (cur) {
        final pp = cur.participants.firstWhere((x) => x.id == participantId);
        return ArenaEngine.setRoster(
            cur, participantId, [for (final x in pp.roster) x.id == r.id ? x.copyWith(name: name) : x]);
      }, context.l10n.playerRenamed);
    }

    Future<void> remove(ArenaPlayer r) async {
      final ok = await _confirm(context, context.l10n.removeNameQ(r.name), context.l10n.leavesTeam(r.name, p.name), action: context.l10n.remove);
      if (!ok || !context.mounted) return;
      await _change(context, ref, tournamentId, (cur) {
        final pp = cur.participants.firstWhere((x) => x.id == participantId);
        return ArenaEngine.setRoster(cur, participantId, [for (final x in pp.roster) if (x.id != r.id) x]);
      }, context.l10n.nameRemoved(r.name));
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
        Text(context.l10n.playersOfMax(p.players, mode.teamSize),
            style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        if (mode.fixedTeamSize)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(context.l10n.fixedTeamSizeNote(mode.label, mode.teamSize),
                style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: p.roster.isEmpty
              ? Center(child: Text(context.l10n.noPlayerNamesYet, style: TextStyle(color: SpheraColors.muted)))
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
            label: Text(context.l10n.addPlayer),
          ),
        ),
      ]),
    );
  }
}
