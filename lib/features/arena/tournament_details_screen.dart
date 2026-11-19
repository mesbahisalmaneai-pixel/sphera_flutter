import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/arena/arena_engine.dart';
import '../../data/arena/arena_models.dart';
import '../../data/arena/arena_repository.dart';
import 'team_management_screen.dart';

/// Runs [change] on the latest copy of the tournament and saves the result.
/// Returns false (after showing the reason) when the engine rejects it.
Future<bool> _apply(BuildContext context, WidgetRef ref, String id, Tournament Function(Tournament t) change) async {
  final current = ref.read(arenaProvider).byId(id);
  if (current == null) return false;
  try {
    await ref.read(arenaProvider.notifier).update(change(current));
    return true;
  } on ArenaError catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
    return false;
  }
}

class TournamentDetailsScreen extends ConsumerWidget {
  const TournamentDetailsScreen({super.key, required this.tournamentId});
  final String tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(arenaProvider).byId(tournamentId);
    if (t == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tournament')),
        body: Center(child: Text('This tournament no longer exists.', style: TextStyle(color: SpheraColors.muted))),
      );
    }
    final br = t.isBattleRoyale;
    final showStandings = !br && t.structure != ArenaStructure.knockoutOnly;
    final showBracket = !br && t.structure.hasKnockout;
    final tabs = <String>[
      if (br) ...['Standings', 'Rounds'],
      if (showStandings) 'Standings',
      if (!br) 'Matches',
      if (showBracket) 'Bracket',
      'Info',
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.name, overflow: TextOverflow.ellipsis),
          actions: [
            PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'reset') {
                  final ok = await _confirm(context, 'Reset all results?',
                      'Every confirmed result is cleared${t.structure.hasKnockout && t.structure != ArenaStructure.knockoutOnly ? ' and the knockout bracket is removed' : ''}. '
                          'The reset is recorded in the audit log.');
                  if (ok && context.mounted) {
                    await _apply(context, ref, t.id, ArenaEngine.resetResults);
                  }
                } else if (v == 'delete') {
                  final ok = await _confirm(context, 'Delete tournament?', 'This cannot be undone.');
                  if (ok && context.mounted) {
                    await ref.read(arenaProvider.notifier).remove(t.id);
                    if (context.mounted) Navigator.of(context).pop();
                  }
                }
              },
              itemBuilder: (_) => [
                if (t.hasConfirmedResults) const PopupMenuItem(value: 'reset', child: Text('Reset results')),
                const PopupMenuItem(value: 'delete', child: Text('Delete tournament')),
              ],
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: SpheraColors.gold,
            labelColor: SpheraColors.gold,
            unselectedLabelColor: SpheraColors.muted,
            tabs: [for (final x in tabs) Tab(text: x)],
          ),
        ),
        body: TabBarView(children: [
          if (br) ...[_BrStandingsTab(t: t), _BrRoundsTab(t: t)],
          if (showStandings) _StandingsTab(t: t),
          if (!br) _MatchesTab(t: t),
          if (showBracket) _BracketTab(t: t),
          _InfoTab(t: t),
        ]),
      ),
    );
  }
}

Future<bool> _confirm(BuildContext context, String title, String body) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
      ],
    ),
  );
  return r ?? false;
}

// ============================================================ standings tab

class _StandingsTab extends ConsumerWidget {
  const _StandingsTab({required this.t});
  final Tournament t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final champ = ArenaEngine.champion(t);
    final needsKnockout = t.structure.hasKnockout && !t.knockoutGenerated;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (champ != null) _ChampionBanner(name: t.participantName(champ)),
        for (final league in t.leagues) ...[
          if (t.leagues.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(league.name.toUpperCase(),
                  style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
          for (final g in league.groups) _GroupTable(t: t, group: g),
        ],
        if (needsKnockout)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Knockout stage', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  'Top ${t.qualifiersPerGroup} of every group qualify.',
                  style: TextStyle(color: SpheraColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: ArenaEngine.groupStageComplete(t)
                      ? () => _apply(context, ref, t.id, ArenaEngine.generateKnockout)
                      : null,
                  icon: const Icon(Icons.account_tree_outlined),
                  label: Text(ArenaEngine.groupStageComplete(t)
                      ? 'Generate knockout'
                      : 'Confirm all group matches first'),
                ),
              ]),
            ),
          ),
      ],
    );
  }
}

class _ChampionBanner extends StatelessWidget {
  const _ChampionBanner({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SpheraColors.gold, width: 1.5),
        gradient: LinearGradient(colors: [
          SpheraColors.gold.withValues(alpha: 0.25),
          SpheraColors.surface,
        ]),
      ),
      child: Row(children: [
        Icon(Icons.emoji_events, size: 44, color: SpheraColors.gold),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('CHAMPION', style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w800, letterSpacing: 2, fontSize: 12)),
            const SizedBox(height: 2),
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ]),
        ),
      ]),
    );
  }
}

class _GroupTable extends StatelessWidget {
  const _GroupTable({required this.t, required this.group});
  final Tournament t;
  final ArenaGroup group;

  @override
  Widget build(BuildContext context) {
    final rows = ArenaEngine.groupStandings(t, group);
    final qualifies = t.structure.hasKnockout && t.structure != ArenaStructure.knockoutOnly;
    final notes = [
      for (final r in rows)
        if (r.rankedBy.isNotEmpty && r.rankedBy != 'Points' && r.note.isNotEmpty)
          '#${r.position} ${t.participantName(r.id)}: ${r.note}',
    ];
    final allowed = t.gameMode?.standingColumns ?? StatColumn.values;
    final cols = [
      for (final c in t.standingsColumns)
        if (allowed.contains(c)) c
    ];
    String stat(StandingRow r, StatColumn c) => switch (c) {
          StatColumn.played => '${r.played}',
          StatColumn.won => '${r.won}',
          StatColumn.drawn => '${r.drawn}',
          StatColumn.lost => '${r.lost}',
          StatColumn.goalsFor => '${r.gf}',
          StatColumn.goalsAgainst => '${r.ga}',
          StatColumn.goalDifference => r.gd > 0 ? '+${r.gd}' : '${r.gd}',
          StatColumn.points => '${r.points}',
        };
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(group.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            ),
            if (qualifies)
              Text('Top ${t.qualifiersPerGroup} qualify',
                  style: TextStyle(color: SpheraColors.gold, fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 14,
              horizontalMargin: 4,
              headingRowHeight: 32,
              dataRowMinHeight: 38,
              dataRowMaxHeight: 44,
              headingTextStyle: TextStyle(color: SpheraColors.muted, fontSize: 12, fontWeight: FontWeight.w700),
              columns: [
                const DataColumn(label: Text('#')),
                const DataColumn(label: Text('Name')),
                for (final c in cols) DataColumn(label: Text(c.short), numeric: true),
              ],
              rows: [
                for (final r in rows)
                  DataRow(cells: [
                    DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 3,
                        height: 22,
                        margin: const EdgeInsets.only(right: 6),
                        color: qualifies && r.position <= t.qualifiersPerGroup ? SpheraColors.gold : Colors.transparent,
                      ),
                      Text('${r.position}'),
                    ])),
                    DataCell(ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 140),
                      child: Text(t.participantName(r.id), overflow: TextOverflow.ellipsis),
                    )),
                    for (final c in cols)
                      DataCell(Text(stat(r, c),
                          style: c == StatColumn.points
                              ? const TextStyle(fontWeight: FontWeight.w800)
                              : null)),
                  ]),
              ],
            ),
          ),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('How ties were resolved', style: TextStyle(color: SpheraColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
            for (final n in notes) Text(n, style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
          ],
        ]),
      ),
    );
  }
}

// ============================================================== matches tab

enum _Filter { all, pending, played }

class _MatchesTab extends ConsumerStatefulWidget {
  const _MatchesTab({required this.t});
  final Tournament t;

  @override
  ConsumerState<_MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends ConsumerState<_MatchesTab> {
  _Filter _filter = _Filter.all;

  bool _show(ArenaMatch m) => switch (_filter) {
        _Filter.all => true,
        _Filter.pending => !m.isConfirmed && !m.bye,
        _Filter.played => m.isConfirmed && !m.bye,
      };

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final children = <Widget>[];

    // Group stage, per league/group, then per matchday.
    for (final league in t.leagues) {
      for (final g in league.groups) {
        final ms = t.groupMatches.where((m) => m.groupId == g.id && _show(m)).toList()
          ..sort((a, b) => a.round != b.round ? a.round.compareTo(b.round) : a.slot.compareTo(b.slot));
        if (ms.isEmpty) continue;
        children.add(_sectionTitle(t.leagues.length > 1 && league.groups.length > 1 ? '${league.name} · ${g.name}' : g.name));
        int? lastRound;
        for (final m in ms) {
          if (m.round != lastRound) {
            lastRound = m.round;
            children.add(Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 4),
              child: Text('Matchday ${m.round}', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            ));
          }
          children.add(_MatchTile(t: t, m: m));
        }
      }
    }

    // Knockout rounds.
    final ko = t.knockoutMatches.where(_show).toList()
      ..sort((a, b) => a.round != b.round ? a.round.compareTo(b.round) : a.slot.compareTo(b.slot));
    String? lastLabel;
    for (final m in ko) {
      if (m.label != lastLabel) {
        lastLabel = m.label;
        children.add(_sectionTitle(m.label));
      }
      children.add(_MatchTile(t: t, m: m));
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Wrap(spacing: 8, children: [
          for (final f in _Filter.values)
            ChoiceChip(
              label: Text(switch (f) {
                _Filter.all => 'All',
                _Filter.pending => 'To play',
                _Filter.played => 'Played',
              }),
              selected: _filter == f,
              onSelected: (_) => setState(() => _filter = f),
            ),
        ]),
      ),
      Expanded(
        child: children.isEmpty
            ? Center(child: Text('No matches here.', style: TextStyle(color: SpheraColors.muted)))
            : ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: children),
      ),
    ]);
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 2),
        child: Text(text.toUpperCase(),
            style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w800, letterSpacing: 1)),
      );
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({required this.t, required this.m});
  final Tournament t;
  final ArenaMatch m;

  @override
  Widget build(BuildContext context) {
    final winnerOnly = t.gameMode?.winnerOnly ?? false;
    final w = m.winnerId;
    final score = m.bye
        ? 'BYE'
        : (m.isConfirmed ? (winnerOnly ? (w == m.homeId ? '◀ Win' : 'Win ▶') : m.scoreText) : 'vs');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: m.playable ? () => showResultSheet(context, t.id, m.id) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(children: [
            Expanded(
              child: Text(t.participantName(m.homeId),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, color: m.homeId == null ? SpheraColors.muted : null)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: m.isConfirmed ? SpheraColors.gold.withValues(alpha: 0.15) : SpheraColors.surfaceHigh,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: m.isConfirmed ? SpheraColors.gold : SpheraColors.border),
              ),
              child: Text(score, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            Expanded(
              child: Text(t.participantName(m.awayId),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, color: m.awayId == null && !m.bye ? SpheraColors.muted : null)),
            ),
          ]),
        ),
      ),
    );
  }
}

// ================================================================ result sheet

Future<void> showResultSheet(BuildContext context, String tournamentId, String matchId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _ResultSheet(tournamentId: tournamentId, matchId: matchId),
  );
}

class _ResultSheet extends ConsumerStatefulWidget {
  const _ResultSheet({required this.tournamentId, required this.matchId});
  final String tournamentId;
  final String matchId;

  @override
  ConsumerState<_ResultSheet> createState() => _ResultSheetState();
}

class _ResultSheetState extends ConsumerState<_ResultSheet> {
  late final TextEditingController _home;
  late final TextEditingController _away;
  late final TextEditingController _homePens;
  late final TextEditingController _awayPens;
  bool _extra = false;
  String? _winner;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final t = ref.read(arenaProvider).byId(widget.tournamentId);
    final m = t?.matches.where((x) => x.id == widget.matchId).firstOrNull;
    _home = TextEditingController(text: m?.homeScore?.toString() ?? '');
    _away = TextEditingController(text: m?.awayScore?.toString() ?? '');
    _homePens = TextEditingController(text: m?.homePens?.toString() ?? '');
    _awayPens = TextEditingController(text: m?.awayPens?.toString() ?? '');
    _extra = m?.decidedBy == MatchDecider.extraTime;
    _winner = m?.winnerId;
  }

  @override
  void dispose() {
    _home.dispose();
    _away.dispose();
    _homePens.dispose();
    _awayPens.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final h = int.tryParse(_home.text.trim());
    final a = int.tryParse(_away.text.trim());
    if (h == null || a == null) {
      setState(() => _error = 'Enter both scores as whole numbers.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final current = ref.read(arenaProvider).byId(widget.tournamentId);
    if (current == null) {
      if (mounted) Navigator.pop(context);
      return;
    }
    try {
      await ref.read(arenaProvider.notifier).update(ArenaEngine.submitResult(
            current,
            widget.matchId,
            h,
            a,
            homePens: int.tryParse(_homePens.text.trim()),
            awayPens: int.tryParse(_awayPens.text.trim()),
            decidedBy: _extra ? MatchDecider.extraTime : MatchDecider.regular,
          ));
      if (mounted) Navigator.pop(context);
    } on ArenaError catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _saving = false;
        });
      }
    }
  }

  Future<void> _saveWinner() async {
    final w = _winner;
    if (w == null) {
      setState(() => _error = 'Pick the winner.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final current = ref.read(arenaProvider).byId(widget.tournamentId);
    if (current == null) {
      if (mounted) Navigator.pop(context);
      return;
    }
    try {
      await ref.read(arenaProvider.notifier).update(ArenaEngine.submitWinner(current, widget.matchId, w));
      if (mounted) Navigator.pop(context);
    } on ArenaError catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(arenaProvider).byId(widget.tournamentId);
    final m = t?.matches.where((x) => x.id == widget.matchId).firstOrNull;
    if (t == null || m == null) return const SizedBox(height: 120, child: Center(child: Text('Match not found.')));
    if (t.gameMode?.winnerOnly ?? false) {
      Widget side(String? id) {
        final picked = id != null && _winner == id;
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: picked ? SpheraColors.gold : SpheraColors.border, width: picked ? 2 : 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: id == null
                ? null
                : () => setState(() {
                      _winner = id;
                      _error = null;
                    }),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Icon(picked ? Icons.emoji_events : Icons.radio_button_off,
                    color: picked ? SpheraColors.gold : SpheraColors.muted),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(t.participantName(id),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ]),
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m.isConfirmed ? 'Amend result' : 'Who won?',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Pick the winning side.', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          const SizedBox(height: 12),
          side(m.homeId),
          side(m.awayId),
          if (m.isConfirmed)
            Text('Amendments are recorded in the audit log.',
                style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: const TextStyle(color: SpheraColors.danger)),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _saveWinner,
              child: Text(m.isConfirmed ? 'Save amendment' : 'Confirm result'),
            ),
          ),
        ]),
      );
    }
    Widget field(TextEditingController c, {double size = 24}) => TextField(
          controller: c,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
          textAlign: TextAlign.center,
          onChanged: (_) => setState(() {}),
          style: TextStyle(fontSize: size, fontWeight: FontWeight.w800),
        );
    final ko = m.stage == MatchStage.knockout;
    final rule = t.rules.knockoutDraw;
    final hs = int.tryParse(_home.text.trim());
    final as_ = int.tryParse(_away.text.trim());
    final level = hs != null && as_ != null && hs == as_;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(m.isConfirmed ? 'Amend result' : 'Enter result',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Text(t.participantName(m.homeId), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(width: 12),
          Expanded(child: Text(t.participantName(m.awayId), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: field(_home)),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('-', style: TextStyle(fontSize: 24))),
          Expanded(child: field(_away)),
        ]),
        const SizedBox(height: 8),
        if (ko) Text('${rule.label}: ${rule.hint}', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        if (ko && rule == KnockoutDraw.extraTime && !level)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text('Decided in extra time'),
            value: _extra,
            onChanged: (v) => setState(() => _extra = v),
          ),
        if (ko && level && rule != KnockoutDraw.replay) ...[
          const SizedBox(height: 12),
          const Text('Penalty shoot-out', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(child: field(_homePens, size: 20)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('-', style: TextStyle(fontSize: 20))),
            Expanded(child: field(_awayPens, size: 20)),
          ]),
        ],
        if (ko && level && rule == KnockoutDraw.replay)
          Text('Level score: this match goes back to "to play" and is played again.',
              style: TextStyle(color: SpheraColors.gold, fontSize: 12)),
        if (m.replays.isNotEmpty)
          Text('Earlier draws: ${m.replays.map((r) => '${r.home}-${r.away}').join(', ')}',
              style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        if (m.isConfirmed)
          Text('Amendments are recorded in the audit log.', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: SpheraColors.danger)),
          ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(m.isConfirmed ? 'Save amendment' : 'Confirm result'),
          ),
        ),
      ]),
    );
  }
}

// ============================================================ battle royale

class _BrStandingsTab extends StatelessWidget {
  const _BrStandingsTab({required this.t});
  final Tournament t;

  @override
  Widget build(BuildContext context) {
    final rows = ArenaEngine.brStandings(t);
    final champ = ArenaEngine.champion(t);
    final confirmed = t.brRounds.where((r) => r.confirmed).length;
    final notes = [
      for (final r in rows)
        if (r.note.isNotEmpty && r.rankedBy != 'Points') '#${r.position} ${t.participantName(r.id)}: ${r.note}',
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (champ != null) _ChampionBanner(name: t.participantName(champ)),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(child: Text('Overall standings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                Text('$confirmed / ${t.brRounds.length} rounds',
                    style: TextStyle(color: SpheraColors.gold, fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 2),
              Text('Total = placement points + kills x ${t.brScoring.killPoints}',
                  style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 14,
                  horizontalMargin: 4,
                  headingRowHeight: 32,
                  dataRowMinHeight: 38,
                  dataRowMaxHeight: 44,
                  headingTextStyle:
                      TextStyle(color: SpheraColors.muted, fontSize: 12, fontWeight: FontWeight.w700),
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Rnd'), numeric: true),
                    DataColumn(label: Text('Place'), numeric: true),
                    DataColumn(label: Text('Kills'), numeric: true),
                    DataColumn(label: Text('Kill pts'), numeric: true),
                    DataColumn(label: Text('Total'), numeric: true),
                  ],
                  rows: [
                    for (final r in rows)
                      DataRow(cells: [
                        DataCell(Text('${r.position}')),
                        DataCell(ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 140),
                          child: Text(t.participantName(r.id), overflow: TextOverflow.ellipsis),
                        )),
                        DataCell(Text('${r.rounds}')),
                        DataCell(Text('${r.placementPts}')),
                        DataCell(Text('${r.kills}')),
                        DataCell(Text('${r.killPts}')),
                        DataCell(Text('${r.points}', style: const TextStyle(fontWeight: FontWeight.w800))),
                      ]),
                  ],
                ),
              ),
              if (notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('How ties were resolved',
                    style: TextStyle(color: SpheraColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
                for (final n in notes) Text(n, style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
              ],
            ]),
          ),
        ),
      ],
    );
  }
}

class _BrRoundsTab extends ConsumerWidget {
  const _BrRoundsTab({required this.t});
  final Tournament t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        for (final r in t.brRounds)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => _BrRoundSheet(tournamentId: t.id, roundId: r.id),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Icon(r.confirmed ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: r.confirmed ? SpheraColors.gold : SpheraColors.muted),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Round ${r.number}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(r.confirmed ? 'Confirmed · tap to amend' : 'Tap to enter placements and kills',
                          style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right),
                ]),
              ),
            ),
          ),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: () => _apply(context, ref, t.id, ArenaEngine.brAddRound),
          icon: const Icon(Icons.add),
          label: const Text('Add a round'),
        ),
      ],
    );
  }
}

class _BrRoundSheet extends ConsumerStatefulWidget {
  const _BrRoundSheet({required this.tournamentId, required this.roundId});
  final String tournamentId;
  final String roundId;

  @override
  ConsumerState<_BrRoundSheet> createState() => _BrRoundSheetState();
}

class _BrRoundSheetState extends ConsumerState<_BrRoundSheet> {
  final Map<String, TextEditingController> _place = {};
  final Map<String, TextEditingController> _kills = {};
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final t = ref.read(arenaProvider).byId(widget.tournamentId);
    final round = t?.brRounds.where((r) => r.id == widget.roundId).firstOrNull;
    for (final p in t?.participants ?? const <ArenaParticipant>[]) {
      final res = round?.results[p.id];
      _place[p.id] = TextEditingController(text: res?.placement.toString() ?? '');
      _kills[p.id] = TextEditingController(text: res == null ? '0' : res.kills.toString());
    }
  }

  @override
  void dispose() {
    for (final c in [..._place.values, ..._kills.values]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final current = ref.read(arenaProvider).byId(widget.tournamentId);
    if (current == null) {
      Navigator.pop(context);
      return;
    }
    final results = <String, BrResult>{};
    for (final p in current.participants) {
      final place = int.tryParse(_place[p.id]?.text.trim() ?? '');
      final kills = int.tryParse(_kills[p.id]?.text.trim() ?? '');
      if (place == null || kills == null) {
        setState(() => _error = 'Enter a placement and a kill count (0 or more) for "${p.name}".');
        return;
      }
      results[p.id] = BrResult(placement: place, kills: kills);
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(arenaProvider.notifier).update(ArenaEngine.brSubmitRound(current, widget.roundId, results));
      if (mounted) Navigator.pop(context);
    } on ArenaError catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(arenaProvider).byId(widget.tournamentId);
    final round = t?.brRounds.where((r) => r.id == widget.roundId).firstOrNull;
    if (t == null || round == null) {
      return const SizedBox(height: 120, child: Center(child: Text('Round not found.')));
    }
    Widget numField(TextEditingController c, String label) => SizedBox(
          width: 64,
          child: TextField(
            controller: c,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
            textAlign: TextAlign.center,
            decoration: InputDecoration(labelText: label, isDense: true),
          ),
        );
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Round ${round.number}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('Placement 1 to ${t.participants.length} (no repeats). Each kill = ${t.brScoring.killPoints} points.',
            style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(children: [
            for (final p in t.participants)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: [
                  Expanded(child: Text(p.display, overflow: TextOverflow.ellipsis, maxLines: 2)),
                  const SizedBox(width: 8),
                  numField(_place[p.id]!, 'Place'),
                  const SizedBox(width: 8),
                  numField(_kills[p.id]!, 'Kills'),
                ]),
              ),
          ]),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: SpheraColors.danger)),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(round.confirmed ? 'Save amendment' : 'Confirm round'),
          ),
        ),
      ]),
    );
  }
}

// ================================================================ bracket tab

class _BracketTab extends StatelessWidget {
  const _BracketTab({required this.t});
  final Tournament t;

  @override
  Widget build(BuildContext context) {
    final ko = t.knockoutMatches;
    if (ko.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'The bracket appears after the group stage is complete.\nOpen Standings and tap "Generate knockout".',
            textAlign: TextAlign.center,
            style: TextStyle(color: SpheraColors.muted),
          ),
        ),
      );
    }
    final rounds = ko.map((m) => m.round).toSet().toList()..sort();
    final firstCount = ko.where((m) => m.round == rounds.first).length;
    final height = (firstCount < 1 ? 1 : firstCount) * 104.0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (final r in rounds)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 200,
                child: Column(children: [
                  Text(ko.firstWhere((m) => m.round == r).label.toUpperCase(),
                      style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (final m in (ko.where((x) => x.round == r).toList()..sort((a, b) => a.slot.compareTo(b.slot))))
                          _BracketCard(t: t, m: m),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}

class _BracketCard extends StatelessWidget {
  const _BracketCard({required this.t, required this.m});
  final Tournament t;
  final ArenaMatch m;

  @override
  Widget build(BuildContext context) {
    final winner = ArenaEngine.winnerOf(m);
    Widget line(String? id, int? score) {
      final won = winner != null && winner == id;
      return Row(children: [
        Expanded(
          child: Text(
            id == null ? (m.bye ? 'BYE' : 'TBD') : t.participantName(id),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: won ? FontWeight.w800 : FontWeight.w500,
              color: won ? SpheraColors.gold : (id == null ? SpheraColors.muted : null),
            ),
          ),
        ),
        if (score != null) Text('$score', style: const TextStyle(fontWeight: FontWeight.w800)),
      ]);
    }

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: m.playable ? () => showResultSheet(context, t.id, m.id) : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            line(m.homeId, m.isConfirmed ? m.homeScore : null),
            Divider(height: 12, color: SpheraColors.border),
            line(m.awayId, m.isConfirmed ? m.awayScore : null),
          ]),
        ),
      ),
    );
  }
}

// ================================================================== info tab

class _InfoTab extends ConsumerWidget {
  const _InfoTab({required this.t});
  final Tournament t;

  String _date(DateTime? d) =>
      d == null ? '-' : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _rename(BuildContext context, WidgetRef ref, ArenaParticipant p) async {
    final c = TextEditingController(text: p.name);
    final team = TextEditingController(text: p.team);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit participant'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: c, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 8),
          TextField(controller: team, decoration: const InputDecoration(labelText: 'Team / club')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    final name = c.text.trim();
    final teamName = team.text.trim();
    c.dispose();
    team.dispose();
    if (ok != true || name.isEmpty || !context.mounted) return;
    await _apply(context, ref, t.id, (cur) {
      if (cur.participants.any((x) => x.id != p.id && x.name.toLowerCase() == name.toLowerCase())) {
        throw ArenaError('"$name" is already registered.');
      }
      return cur.copyWith(
        participants: [for (final x in cur.participants) x.id == p.id ? x.copyWith(name: name, team: teamName) : x],
        audit: [...cur.audit, AuditEvent(at: DateTime.now(), text: 'Participant edited: ${p.name} -> $name')],
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 110, child: Text(k, style: TextStyle(color: SpheraColors.muted))),
            Expanded(child: Text(v)),
          ]),
        );
    final audit = t.audit.reversed.take(40).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (t.description.isNotEmpty) ...[Text(t.description), const SizedBox(height: 10)],
              row('Game', '${t.game} · ${t.mode}'),
              if (t.isBattleRoyale)
                row('Scoring',
                    'Placement points + kills x ${t.brScoring.killPoints} (${t.brRoundsPlanned} planned rounds)')
              else
                row('Structure', t.structure.label),
              row('Organizer', t.organizer.isEmpty ? '-' : t.organizer),
              row('Start', _date(t.startDate)),
              row('Registration', 'until ${_date(t.registrationDeadline)}'),
              if (!t.isBattleRoyale && t.structure != ArenaStructure.knockoutOnly) ...[
                row(
                    'Points',
                    (t.gameMode?.winnerOnly ?? false)
                        ? 'Win ${t.rules.pointsWin} · Loss ${t.rules.pointsLoss}'
                        : 'W ${t.rules.pointsWin} · D ${t.rules.pointsDraw} · L ${t.rules.pointsLoss}'),
                row('Ranking',
                    'Pts → ${ArenaEngine.effectiveRules(t).tiebreakers.map((x) => x.short).join(' → ')}'),
              ],
              if (!t.isBattleRoyale && t.structure.hasKnockout && !(t.gameMode?.winnerOnly ?? false))
                row('If level', t.rules.knockoutDraw.label),
            ]),
          ),
        ),
        if (t.rulesText.isNotEmpty) ...[
          const SizedBox(height: 12),
          _Section(title: 'Rules', child: Text(t.rulesText)),
        ],
        if (t.roomId.isNotEmpty || t.roomPassword.isNotEmpty) ...[
          const SizedBox(height: 12),
          _RoomCard(roomId: t.roomId, password: t.roomPassword),
        ],
        const SizedBox(height: 12),
        _Section(
          title: 'Participants (${t.participants.length})',
          child: Column(children: [
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => TeamManagementScreen(tournamentId: t.id))),
                icon: const Icon(Icons.swap_horiz),
                label: Text(t.gameMode?.isTeamMode ?? false ? 'Teams and players' : 'Edit and swap players'),
              ),
            ),
            for (final p in t.participants)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(p.display),
                subtitle: p.roster.isNotEmpty
                    ? Text(p.roster.map((x) => x.name).join(', '))
                    : (p.players > 1 ? Text('${p.players} players') : null),
                trailing: const Icon(Icons.edit_outlined, size: 18),
                onTap: () => _rename(context, ref, p),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        _Section(
          title: 'Audit log',
          child: audit.isEmpty
              ? Text('No events yet.', style: TextStyle(color: SpheraColors.muted))
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (final e in audit)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        '${e.at.year}-${e.at.month.toString().padLeft(2, '0')}-${e.at.day.toString().padLeft(2, '0')} '
                        '${e.at.hour.toString().padLeft(2, '0')}:${e.at.minute.toString().padLeft(2, '0')}  ${e.text}',
                        style: TextStyle(color: SpheraColors.muted, fontSize: 12),
                      ),
                    ),
                ]),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          child,
        ]),
      ),
    );
  }
}

class _RoomCard extends StatefulWidget {
  const _RoomCard({required this.roomId, required this.password});
  final String roomId;
  final String password;

  @override
  State<_RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<_RoomCard> {
  bool _reveal = false;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Room',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Room ID: ${widget.roomId.isEmpty ? '-' : widget.roomId}'),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(
            child: Text('Password: ${widget.password.isEmpty ? '-' : (_reveal ? widget.password : '••••••')}'),
          ),
          if (widget.password.isNotEmpty)
            IconButton(
              icon: Icon(_reveal ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              onPressed: () => setState(() => _reveal = !_reveal),
            ),
        ]),
        Text('Stored on this device only. Never shared automatically.',
            style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
      ]),
    );
  }
}
