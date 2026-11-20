import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/arena/arena_engine.dart';
import '../../data/arena/arena_models.dart';
import '../../data/arena/arena_repository.dart';
import 'create_tournament_screen.dart';
import 'tournament_details_screen.dart';

/// SPHERA TOURNAMENT ARENA: list of the user's tournaments.
class ArenaScreen extends ConsumerWidget {
  const ArenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(arenaProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.arenaTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const CreateTournamentScreen())),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.create),
      ),
      body: !st.loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                _Hero(count: st.tournaments.length),
                if (st.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(st.error!, style: const TextStyle(color: SpheraColors.danger)),
                  ),
                const SizedBox(height: 12),
                if (st.tournaments.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Column(children: [
                      Icon(Icons.emoji_events_outlined, size: 56, color: SpheraColors.gold),
                      const SizedBox(height: 12),
                      Text(context.l10n.noTournamentsYet,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(context.l10n.createFirstTournament,
                          textAlign: TextAlign.center, style: TextStyle(color: SpheraColors.muted)),
                    ]),
                  )
                else
                  for (final t in st.tournaments) _TournamentCard(t: t),
              ],
            ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SpheraColors.gold.withValues(alpha: 0.5)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SpheraColors.surfaceHigh, SpheraColors.surface],
        ),
      ),
      child: Row(children: [
        Icon(Icons.emoji_events, size: 40, color: SpheraColors.gold),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.l10n.tournamentArena,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(context.l10n.tournamentsOnDevice(count),
                style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          ]),
        ),
      ]),
    );
  }
}

class _TournamentCard extends StatelessWidget {
  const _TournamentCard({required this.t});
  final Tournament t;

  @override
  Widget build(BuildContext context) {
    final playable = t.matches.where((m) => !m.bye && m.status != MatchStatus.cancelled).toList();
    final total = t.isBattleRoyale ? t.brRounds.length : playable.length;
    final done = t.isBattleRoyale
        ? t.brRounds.where((r) => r.confirmed).length
        : playable.where((m) => m.isConfirmed).length;
    final champ = ArenaEngine.champion(t);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TournamentDetailsScreen(tournamentId: t.id))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(t.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              if (champ != null) Icon(Icons.emoji_events, color: SpheraColors.gold, size: 22),
            ]),
            const SizedBox(height: 4),
            Text('${t.game} · ${t.mode}', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 6, children: [
              _Chip(t.isBattleRoyale ? 'Battle Royale' : t.structure.label),
              _Chip(context.l10n.participantsCount(t.participants.length)),
              if (champ != null) _Chip(context.l10n.champion(t.participantName(champ)), gold: true),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
                minHeight: 6,
                backgroundColor: SpheraColors.border,
                color: SpheraColors.gold,
              ),
            ),
            const SizedBox(height: 4),
            Text(t.isBattleRoyale ? context.l10n.roundsConfirmed(done, total) : context.l10n.matchesConfirmed(done, total),
                style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
          ]),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text, {this.gold = false});
  final String text;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: gold ? SpheraColors.gold.withValues(alpha: 0.15) : SpheraColors.surfaceHigh,
        border: Border.all(color: gold ? SpheraColors.gold : SpheraColors.border),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
