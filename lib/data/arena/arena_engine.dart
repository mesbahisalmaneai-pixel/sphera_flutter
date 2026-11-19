import 'dart:math';

import 'package:uuid/uuid.dart';

import 'arena_models.dart';

const _uuid = Uuid();

/// A user-facing validation problem (bad config, invalid result, ...).
class ArenaError implements Exception {
  ArenaError(this.message);
  final String message;
  @override
  String toString() => message;
}

class Pair {
  const Pair(this.home, this.away);
  final String home;
  final String away;
}

class StandingRow {
  StandingRow(this.id);
  final String id;
  int played = 0, won = 0, drawn = 0, lost = 0, gf = 0, ga = 0, points = 0;
  int position = 0;

  /// Why this row is ranked below the row above it (empty for the leader).
  String rankedBy = '';

  /// A full sentence explaining that ranking, naming the teams involved
  /// (e.g. "Level on 6 pts. Head-to-head: P1 beat P2 2-1."). Empty for the
  /// leader and when nothing needs explaining.
  String note = '';

  int get gd => gf - ga;
}

class _H2H {
  int pts = 0, gf = 0, ga = 0;
  int get gd => gf - ga;
}

/// One line of a Battle Royale table (derived from confirmed rounds only).
class BrStandingRow {
  BrStandingRow(this.id);
  final String id;
  int rounds = 0, points = 0, kills = 0, wins = 0;

  /// [points] split into its two parts.
  int placementPts = 0, killPts = 0;

  /// Placement in the most recent confirmed round (large when none).
  int lastPlacement = 1 << 30;
  int position = 0;
  String rankedBy = '';
  String note = '';
}

class ArenaEngine {
  ArenaEngine._();

  // ---------------------------------------------------------------- validation

  /// Returns a list of problems; empty means the configuration is valid.
  static List<String> validate(Tournament d) {
    final errors = <String>[];
    final n = d.participants.length;
    if (d.name.trim().isEmpty) errors.add('Tournament name is required.');
    if (n < 2) errors.add('Add at least 2 participants.');
    if (n > d.maxParticipants) {
      errors.add('Participants ($n) exceed the maximum (${d.maxParticipants}).');
    }
    if (d.startDate != null &&
        d.registrationDeadline != null &&
        d.registrationDeadline!.isAfter(d.startDate!)) {
      errors.add('Registration deadline must be on or before the start date.');
    }
    if (d.rules.pointsWin < d.rules.pointsDraw) {
      errors.add('Win points must be at least the draw points.');
    }
    if (d.standingsColumns.isEmpty) errors.add('Show at least 1 column in the standings table.');
    if (d.standingsColumns.length > kMaxStandingColumns) {
      errors.add('The standings table can show at most $kMaxStandingColumns columns.');
    }
    errors.addAll(_validateMode(d));
    final s = d.structure;
    if (d.isBattleRoyale && d.brRoundsPlanned < 1) {
      errors.add('Plan at least 1 round.');
    }
    if (!d.isBattleRoyale && s != ArenaStructure.knockoutOnly && n >= 2) {
      final leagues = s.usesLeagues ? d.leaguesCount : 1;
      final groups = s.usesGroups ? d.groupsPerLeague : 1;
      if (s.usesLeagues && leagues < 2) errors.add('Use at least 2 leagues.');
      if (s.usesGroups && groups < 2) errors.add('Use at least 2 groups per league.');
      final totalGroups = leagues * groups;
      if (n < totalGroups * 2) {
        errors.add('Not enough participants: $leagues league(s) x $groups group(s) '
            'need at least ${totalGroups * 2}.');
      } else if (s.hasKnockout) {
        final minGroup = n ~/ totalGroups;
        if (d.qualifiersPerGroup < 1) errors.add('At least 1 qualifier per group is required.');
        if (d.qualifiersPerGroup > minGroup) {
          errors.add('Qualifiers per group (${d.qualifiersPerGroup}) exceed the smallest '
              'group size ($minGroup).');
        }
        if (totalGroups * d.qualifiersPerGroup < 2) {
          errors.add('At least 2 participants must qualify for the knockout.');
        }
      }
    }
    return errors;
  }

  /// Limits that come from the game mode (see [ArenaGameMode]).
  static List<String> _validateMode(Tournament d) {
    final mode = d.gameMode;
    if (mode == null) return const [];
    final errors = <String>[];
    if (mode.winnerOnly) {
      // Columns the mode cannot show (goals, draws) are simply left out of the
      // table (the standings screen filters them), so they are not an error.
      // Only refuse when nothing displayable would remain.
      final usable = d.standingsColumns.where(mode.standingColumns.contains);
      if (d.standingsColumns.isNotEmpty && usable.isEmpty) {
        errors.add('${mode.label} is decided by the winner: pick at least one of '
            '${mode.standingColumns.map((c) => c.label.toLowerCase()).join(', ')}.');
      }
    }
    final n = d.participants.length;
    final unit = mode.isTeamMode ? 'teams' : 'players';
    final cap = mode.maxParticipants;
    if (cap != null && n > cap) {
      errors.add('${mode.label} allows at most $cap $unit (you have $n).');
    }
    if (n >= 2 && n < mode.minParticipants) {
      errors.add('${mode.label} needs at least ${mode.minParticipants} $unit '
          '(placement points are not awarded to the last ${BrScoring.zeroTail} places).');
    }
    for (final p in d.participants) {
      if (mode.fixedTeamSize) {
        if (p.players != mode.teamSize) {
          errors.add('"${p.name}" must have exactly ${mode.teamSize} players.');
        }
      } else if (p.players < 1 || p.players > mode.teamSize) {
        errors.add('"${p.name}" must have between 1 and ${mode.teamSize} players.');
      }
    }
    final seenIds = <String>{};
    final seenNames = <String>{};
    for (final p in d.participants) {
      for (final pl in p.roster) {
        if (!seenIds.add(pl.id)) {
          errors.add('Player "${pl.name}" is assigned twice.');
        } else if (!seenNames.add(pl.name.trim().toLowerCase())) {
          errors.add('Player "${pl.name}" appears more than once.');
        }
      }
    }
    if (mode.minTotalPlayers > 0) {
      final total = d.participants.fold<int>(0, (sum, p) => sum + p.players);
      if (total < mode.minTotalPlayers) {
        errors.add('At least ${mode.minTotalPlayers} players must be registered in total '
            '(currently $total).');
      }
    }
    if (mode.isBattleRoyale && n >= 2) {
      errors.addAll(d.brScoring.validate(n));
    }
    return errors;
  }

  // ----------------------------------------------------------------- building

  /// Draws participants into leagues/groups and generates the first fixtures.
  /// Knockout-only tournaments get their bracket immediately.
  static Tournament build(Tournament draft, {Random? rng}) {
    final errors = validate(draft);
    if (errors.isNotEmpty) throw ArenaError(errors.first);
    if (draft.isBattleRoyale) {
      return draft.copyWith(
        leagues: const [],
        matches: const [],
        knockoutGenerated: false,
        brRounds: [
          for (var i = 1; i <= draft.brRoundsPlanned; i++) BrRound(id: _uuid.v4(), number: i),
        ],
        audit: [_event('Tournament created: ${draft.brRoundsPlanned} Battle Royale round(s)')],
      );
    }
    final ids = draft.participants.map((p) => p.id).toList();
    if (draft.randomDraw) ids.shuffle(rng ?? Random());

    if (draft.structure == ArenaStructure.knockoutOnly) {
      final ko = buildKnockout(seededSlots(ids));
      return draft.copyWith(
        leagues: const [],
        matches: ko,
        knockoutGenerated: true,
        audit: [_event('Tournament created: knockout bracket generated')],
      );
    }

    final leagues = distribute(
      ids,
      leagues: draft.structure.usesLeagues ? draft.leaguesCount : 1,
      groupsPerLeague: draft.structure.usesGroups ? draft.groupsPerLeague : 1,
    );
    final matches = groupFixtures(leagues, doubleRound: draft.doubleRound);
    return draft.copyWith(
      leagues: leagues,
      matches: matches,
      knockoutGenerated: false,
      audit: [_event('Tournament created: ${matches.length} fixtures generated')],
    );
  }

  /// Deals [ids] (in the given order) into leagues, then groups.
  static List<ArenaLeague> distribute(List<String> ids,
      {required int leagues, required int groupsPerLeague}) {
    final perLeague = List.generate(leagues, (_) => <String>[]);
    for (var i = 0; i < ids.length; i++) {
      perLeague[i % leagues].add(ids[i]);
    }
    final out = <ArenaLeague>[];
    for (var l = 0; l < leagues; l++) {
      final letter = String.fromCharCode(65 + l);
      final perGroup = List.generate(groupsPerLeague, (_) => <String>[]);
      for (var i = 0; i < perLeague[l].length; i++) {
        perGroup[i % groupsPerLeague].add(perLeague[l][i]);
      }
      final leagueName = leagues == 1 ? 'League' : 'League $letter';
      final groups = <ArenaGroup>[];
      for (var g = 0; g < groupsPerLeague; g++) {
        final String name;
        if (groupsPerLeague == 1) {
          name = leagueName;
        } else if (leagues == 1) {
          name = 'Group ${String.fromCharCode(65 + g)}';
        } else {
          name = 'Group $letter${g + 1}';
        }
        groups.add(ArenaGroup(id: _uuid.v4(), name: name, participantIds: perGroup[g]));
      }
      out.add(ArenaLeague(id: _uuid.v4(), name: leagueName, groups: groups));
    }
    return out;
  }

  /// Round-robin by the circle method. Odd counts get a bye (that pairing is
  /// simply skipped). Never pairs a participant with themselves or twice
  /// (per leg).
  static List<List<Pair>> roundRobin(List<String> ids, {bool doubleRound = false}) {
    final list = <String?>[...ids];
    if (list.length < 2) return [];
    if (list.length.isOdd) list.add(null);
    final n = list.length;
    final rounds = <List<Pair>>[];
    for (var r = 0; r < n - 1; r++) {
      final pairs = <Pair>[];
      for (var i = 0; i < n ~/ 2; i++) {
        final a = list[i];
        final b = list[n - 1 - i];
        if (a == null || b == null) continue;
        // Alternate home/away to balance.
        final flip = (r + i).isOdd;
        pairs.add(flip ? Pair(b, a) : Pair(a, b));
      }
      rounds.add(pairs);
      // Rotate everything except the first element.
      final last = list.removeLast();
      list.insert(1, last);
    }
    if (doubleRound) {
      final second = rounds.map((r) => r.map((p) => Pair(p.away, p.home)).toList()).toList();
      rounds.addAll(second);
    }
    return rounds;
  }

  static List<ArenaMatch> groupFixtures(List<ArenaLeague> leagues, {bool doubleRound = false}) {
    final out = <ArenaMatch>[];
    for (final league in leagues) {
      for (final group in league.groups) {
        final rounds = roundRobin(group.participantIds, doubleRound: doubleRound);
        for (var r = 0; r < rounds.length; r++) {
          for (var i = 0; i < rounds[r].length; i++) {
            out.add(ArenaMatch(
              id: _uuid.v4(),
              stage: MatchStage.group,
              round: r + 1,
              slot: i,
              leagueId: league.id,
              groupId: group.id,
              homeId: rounds[r][i].home,
              awayId: rounds[r][i].away,
            ));
          }
        }
      }
    }
    return out;
  }

  // ----------------------------------------------------------------- knockout

  static int _nextPow2(int n) {
    var s = 2;
    while (s < n) {
      s *= 2;
    }
    return s;
  }

  /// Standard bracket seed order: size 8 -> [1,8,4,5,2,7,3,6].
  static List<int> seedOrder(int size) {
    var order = <int>[1];
    while (order.length < size) {
      final sum = order.length * 2 + 1;
      order = [for (final s in order) ...[s, sum - s]];
    }
    return order;
  }

  /// [ranked] is best-first. Missing seeds become byes (null).
  static List<String?> seededSlots(List<String> ranked) {
    final size = _nextPow2(ranked.length);
    return seedOrder(size).map((seed) => seed <= ranked.length ? ranked[seed - 1] : null).toList();
  }

  static String _roundLabel(int roundsLeft) => switch (roundsLeft) {
        1 => 'Final',
        2 => 'Semi-finals',
        3 => 'Quarter-finals',
        _ => 'Round of ${1 << roundsLeft}',
      };

  /// [slots] length must be a power of two (>= 2); null = bye.
  static List<ArenaMatch> buildKnockout(List<String?> slots) {
    final size = slots.length;
    var rounds = 0;
    while ((1 << rounds) < size) {
      rounds++;
    }
    final out = <ArenaMatch>[];
    for (var r = 0; r < rounds; r++) {
      final count = size >> (r + 1);
      for (var s = 0; s < count; s++) {
        String? home;
        String? away;
        var bye = false;
        if (r == 0) {
          home = slots[2 * s];
          away = slots[2 * s + 1];
          if (home == null && away != null) {
            home = away;
            away = null;
          }
          bye = away == null;
        }
        out.add(ArenaMatch(
          id: _uuid.v4(),
          stage: MatchStage.knockout,
          round: r,
          slot: s,
          homeId: home,
          awayId: away,
          bye: bye,
          status: bye ? MatchStatus.confirmed : MatchStatus.scheduled,
          label: _roundLabel(rounds - r),
        ));
      }
    }
    return propagate(out);
  }

  /// Winner of a confirmed match, or null.
  static String? winnerOf(ArenaMatch m) => m.winnerId;

  /// Pushes confirmed winners into the next round. Unconfirmed matches clear
  /// their slot downstream, so unconfirmed results never advance anyone.
  static List<ArenaMatch> propagate(List<ArenaMatch> matches) {
    final ko = matches.where((m) => m.stage == MatchStage.knockout).toList();
    if (ko.isEmpty) return matches;
    final maxRound = ko.map((m) => m.round).reduce(max);
    final byKey = <String, ArenaMatch>{for (final m in ko) '${m.round}:${m.slot}': m};
    for (var r = 0; r < maxRound; r++) {
      final thisRound = ko.where((m) => m.round == r).toList()..sort((a, b) => a.slot.compareTo(b.slot));
      for (final m in thisRound) {
        final current = byKey['${m.round}:${m.slot}']!;
        final w = winnerOf(current);
        final nextKey = '${r + 1}:${m.slot ~/ 2}';
        final next = byKey[nextKey];
        if (next == null) continue;
        byKey[nextKey] = m.slot.isEven ? next.copyWith(homeId: w) : next.copyWith(awayId: w);
      }
    }
    return [
      for (final m in matches)
        m.stage == MatchStage.knockout ? byKey['${m.round}:${m.slot}']! : m,
    ];
  }

  /// Bracket order for 2 qualifiers per group and an even number of groups
  /// whose total is a power of two: A1-B2 and B1-A2 sit in opposite halves.
  /// Returns null when this scheme does not apply.
  static List<String?>? crossGroupSlots(List<List<String>> qualifiersByGroup) {
    final g = qualifiersByGroup.length;
    if (g < 2 || g.isOdd || qualifiersByGroup.any((q) => q.length != 2)) return null;
    final total = g * 2;
    if ((total & (total - 1)) != 0) return null;
    final firstHalf = <String?>[];
    final secondHalf = <String?>[];
    for (var i = 0; i < g; i += 2) {
      final a = qualifiersByGroup[i], b = qualifiersByGroup[i + 1];
      firstHalf..add(a[0])..add(b[1]);
      secondHalf..add(b[0])..add(a[1]);
    }
    return [...firstHalf, ...secondHalf];
  }

  // ---------------------------------------------------------------- standings

  static List<StandingRow> groupStandings(Tournament t, ArenaGroup g) => standings(
        g.participantIds,
        t.matches.where((m) => m.stage == MatchStage.group && m.groupId == g.id).toList(),
        effectiveRules(t),
        nameOf: t.participantName,
      );

  /// The rules that really rank the table. Clash Squad has no goals and no
  /// draws: only points, then the direct match, then name.
  static ArenaRules effectiveRules(Tournament t) {
    if (t.gameMode?.winnerOnly ?? false) {
      return ArenaRules(
        pointsWin: t.rules.pointsWin,
        pointsDraw: 0,
        pointsLoss: t.rules.pointsLoss,
        tiebreakers: const [Tiebreaker.headToHead],
        knockoutDraw: t.rules.knockoutDraw,
      );
    }
    return t.rules;
  }

  /// Derived ONLY from confirmed results. [nameOf] is used for the final
  /// alphabetical fallback so the order is deterministic.
  static List<StandingRow> standings(
    List<String> ids,
    List<ArenaMatch> matches,
    ArenaRules rules, {
    String Function(String id)? nameOf,
  }) {
    final idSet = ids.toSet();
    final rows = {for (final id in ids) id: StandingRow(id)};
    final counted = <ArenaMatch>[];
    for (final m in matches) {
      if (!m.isConfirmed || m.bye || m.homeId == null || m.awayId == null) continue;
      if (!idSet.contains(m.homeId) || !idSet.contains(m.awayId)) continue;
      final h = m.homeScore, a = m.awayScore;
      if (h == null || a == null) continue;
      counted.add(m);
      final home = rows[m.homeId]!, away = rows[m.awayId]!;
      home.played++;
      away.played++;
      home.gf += h;
      home.ga += a;
      away.gf += a;
      away.ga += h;
      if (h > a) {
        home.won++;
        away.lost++;
        home.points += rules.pointsWin;
        away.points += rules.pointsLoss;
      } else if (a > h) {
        away.won++;
        home.lost++;
        away.points += rules.pointsWin;
        home.points += rules.pointsLoss;
      } else {
        home.drawn++;
        away.drawn++;
        home.points += rules.pointsDraw;
        away.points += rules.pointsDraw;
      }
    }

    final reason = <String, String>{};
    var buckets = _split(rows.values.toList(), (r) => r.points, 'Points', reason);
    for (final c in rules.tiebreakers) {
      final next = <List<StandingRow>>[];
      for (final b in buckets) {
        if (b.length < 2) {
          next.add(b);
          continue;
        }
        switch (c) {
          case Tiebreaker.goalDifference:
            next.addAll(_split(b, (r) => r.gd, c.label, reason));
          case Tiebreaker.goalsScored:
            next.addAll(_split(b, (r) => r.gf, c.label, reason));
          case Tiebreaker.goalsAgainst:
            next.addAll(_split(b, (r) => -r.ga, c.label, reason));
          case Tiebreaker.headToHead:
            final h = _headToHead(b.map((r) => r.id).toSet(), counted, rules);
            for (final part in _split(b, (r) => h[r.id]!.pts, c.label, reason)) {
              if (part.length < 2) {
                next.add(part);
              } else {
                next.addAll(_split(part, (r) => h[r.id]!.gd, c.label, reason));
              }
            }
        }
      }
      buckets = next;
    }

    final out = <StandingRow>[];
    for (final b in buckets) {
      if (b.length > 1) {
        b.sort((x, y) {
          final nx = nameOf?.call(x.id) ?? x.id;
          final ny = nameOf?.call(y.id) ?? y.id;
          return nx.toLowerCase().compareTo(ny.toLowerCase());
        });
        for (var i = 1; i < b.length; i++) {
          reason[b[i].id] = 'Level on all criteria (name order)';
        }
      }
      out.addAll(b);
    }
    for (var i = 0; i < out.length; i++) {
      out[i].position = i + 1;
      out[i].rankedBy = i == 0 ? '' : (reason[out[i].id] ?? '');
      out[i].note = i == 0
          ? ''
          : _tiebreakNote(out[i - 1], out[i], out[i].rankedBy, counted, rules, nameOf ?? ((String id) => id));
    }
    return out;
  }

  static String _signed(int v) => v > 0 ? '+$v' : '$v';

  /// Explains in one sentence why [row] sits below [above].
  static String _tiebreakNote(
    StandingRow above,
    StandingRow row,
    String criterion,
    List<ArenaMatch> counted,
    ArenaRules rules,
    String Function(String id) nameOf,
  ) {
    final a = nameOf(above.id), b = nameOf(row.id);
    if (criterion == 'Points') return '$a has more points (${above.points} vs ${row.points}).';
    if (criterion == Tiebreaker.headToHead.label) {
      final direct = counted.where((m) =>
          (m.homeId == above.id && m.awayId == row.id) || (m.homeId == row.id && m.awayId == above.id));
      final lead = 'Level on ${above.points} pts. Head-to-head: ';
      if (direct.length == 1) {
        final m = direct.first;
        final aHome = m.homeId == above.id;
        final ag = aHome ? m.homeScore! : m.awayScore!;
        final bg = aHome ? m.awayScore! : m.homeScore!;
        if (ag > bg) return '$lead$a beat $b $ag-$bg in their direct match.';
      }
      return '$lead$a has the better record in the matches between the tied teams.';
    }
    if (criterion == Tiebreaker.goalDifference.label) {
      return 'Level on ${above.points} pts. Goal difference: $a ${_signed(above.gd)} vs $b ${_signed(row.gd)}.';
    }
    if (criterion == Tiebreaker.goalsScored.label) {
      return 'Level on ${above.points} pts. Goals scored: $a ${above.gf} vs $b ${row.gf}.';
    }
    if (criterion == Tiebreaker.goalsAgainst.label) {
      return 'Level on ${above.points} pts. Goals against: $a ${above.ga} vs $b ${row.ga} (fewer is better).';
    }
    if (criterion.isNotEmpty) return 'Level on every criterion: ranked by name.';
    return '';
  }

  /// Splits [bucket] into descending groups of equal [key]; the first row of
  /// every group after the first records [label] as the separating criterion.
  static List<List<StandingRow>> _split(List<StandingRow> bucket, num Function(StandingRow) key,
      String label, Map<String, String> reason) {
    final sorted = [...bucket]..sort((a, b) => key(b).compareTo(key(a)));
    final out = <List<StandingRow>>[];
    for (final r in sorted) {
      if (out.isNotEmpty && key(out.last.first) == key(r)) {
        out.last.add(r);
      } else {
        if (out.isNotEmpty) reason[r.id] = label;
        out.add([r]);
      }
    }
    return out;
  }

  static Map<String, _H2H> _headToHead(Set<String> ids, List<ArenaMatch> counted, ArenaRules rules) {
    final res = {for (final id in ids) id: _H2H()};
    for (final m in counted) {
      if (!ids.contains(m.homeId) || !ids.contains(m.awayId)) continue;
      final h = m.homeScore!, a = m.awayScore!;
      final home = res[m.homeId]!, away = res[m.awayId]!;
      home.gf += h;
      home.ga += a;
      away.gf += a;
      away.ga += h;
      if (h > a) {
        home.pts += rules.pointsWin;
        away.pts += rules.pointsLoss;
      } else if (a > h) {
        away.pts += rules.pointsWin;
        home.pts += rules.pointsLoss;
      } else {
        home.pts += rules.pointsDraw;
        away.pts += rules.pointsDraw;
      }
    }
    return res;
  }

  // ---------------------------------------------------------- group -> knockout

  static bool groupStageComplete(Tournament t) {
    final gm = t.groupMatches.where((m) => m.status != MatchStatus.cancelled);
    return gm.isNotEmpty && gm.every((m) => m.isConfirmed);
  }

  /// Builds the knockout from the group tables (top [Tournament.qualifiersPerGroup]
  /// of every group). Only allowed once every group match is confirmed.
  static Tournament generateKnockout(Tournament t) {
    if (!t.structure.hasKnockout || t.structure == ArenaStructure.knockoutOnly) {
      throw ArenaError('This tournament has no group stage to qualify from.');
    }
    if (t.knockoutGenerated) throw ArenaError('The knockout stage was already generated.');
    if (!groupStageComplete(t)) {
      throw ArenaError('Confirm every group match before generating the knockout.');
    }
    final byGroup = <List<String>>[];
    final ranked = <StandingRow>[];
    for (final league in t.leagues) {
      for (final group in league.groups) {
        final table = groupStandings(t, group).take(t.qualifiersPerGroup).toList();
        byGroup.add(table.map((r) => r.id).toList());
        ranked.addAll(table);
      }
    }
    if (ranked.length < 2) throw ArenaError('At least 2 participants must qualify.');
    ranked.sort((a, b) {
      final p = a.position.compareTo(b.position);
      if (p != 0) return p;
      final pts = b.points.compareTo(a.points);
      if (pts != 0) return pts;
      final gd = b.gd.compareTo(a.gd);
      if (gd != 0) return gd;
      return b.gf.compareTo(a.gf);
    });
    final slots = crossGroupSlots(byGroup) ?? seededSlots(ranked.map((r) => r.id).toList());
    final ko = buildKnockout(slots);
    return t.copyWith(
      matches: [...t.matches, ...ko],
      knockoutGenerated: true,
      audit: [...t.audit, _event('Knockout generated from group standings (${ranked.length} qualifiers)')],
    );
  }

  // ------------------------------------------------------------------ results

  /// Winner-only modes (Clash Squad): confirms a match by picking the winner.
  /// Nothing about goals or draws is involved.
  static Tournament submitWinner(Tournament t, String matchId, String winnerId) {
    if (!(t.gameMode?.winnerOnly ?? false)) {
      throw ArenaError('This mode is scored with a result, not by picking a winner.');
    }
    final idx = t.matches.indexWhere((m) => m.id == matchId);
    if (idx < 0) throw ArenaError('Match not found.');
    final m = t.matches[idx];
    if (winnerId != m.homeId && winnerId != m.awayId) {
      throw ArenaError('The winner must be one of the two sides.');
    }
    final homeWon = winnerId == m.homeId;
    return submitResult(t, matchId, homeWon ? 1 : 0, homeWon ? 0 : 1);
  }

  /// True when this score would leave a knockout match level, so the caller
  /// must collect penalties (or, with the replay rule, the match is replayed).
  static bool isKnockoutDraw(ArenaMatch m, int home, int away) =>
      m.stage == MatchStage.knockout && home == away;

  /// Confirms (or amends) a result. Throws [ArenaError] for invalid input or
  /// for amendments that would invalidate later results.
  ///
  /// Knockout matches that end level follow [ArenaRules.knockoutDraw]:
  /// - penalties / extraTime: [homePens] and [awayPens] are required (for
  ///   extraTime, [home]/[away] are the score after extra time).
  /// - replay: the draw is recorded in the match history and the match goes
  ///   back to "scheduled" so it can be played again.
  /// For a non-level knockout score, pass [decidedBy] = extraTime when it was
  /// settled in extra time (only meaningful with the extra-time rule).
  static Tournament submitResult(
    Tournament t,
    String matchId,
    int home,
    int away, {
    int? homePens,
    int? awayPens,
    MatchDecider decidedBy = MatchDecider.regular,
  }) {
    final idx = t.matches.indexWhere((m) => m.id == matchId);
    if (idx < 0) throw ArenaError('Match not found.');
    final m = t.matches[idx];
    if (m.bye) throw ArenaError('A bye has no result.');
    if (m.status == MatchStatus.cancelled) throw ArenaError('This match was cancelled.');
    if (m.homeId == null || m.awayId == null) throw ArenaError('Both participants must be known first.');
    if (home < 0 || away < 0) throw ArenaError('Scores cannot be negative.');
    final amend = m.isConfirmed;
    if (amend) {
      if (m.stage == MatchStage.group && t.knockoutGenerated) {
        throw ArenaError('The knockout stage is already generated. Reset results to change group scores.');
      }
      if (m.stage == MatchStage.knockout) {
        final next = t.matches.where(
            (x) => x.stage == MatchStage.knockout && x.round == m.round + 1 && x.slot == m.slot ~/ 2);
        if (next.any((x) => x.isConfirmed)) {
          throw ArenaError('The next round was already played. Reset results to change this score.');
        }
      }
    }

    var by = MatchDecider.regular;
    int? hp, ap;
    if (m.stage == MatchStage.knockout) {
      final rule = t.rules.knockoutDraw;
      if (home == away) {
        if (rule == KnockoutDraw.replay) {
          final replayed = m.copyWith(
            homeScore: null,
            awayScore: null,
            homePens: null,
            awayPens: null,
            decidedBy: MatchDecider.regular,
            status: MatchStatus.scheduled,
            replays: [...m.replays, ScoreLine(home, away)],
          );
          var matches = [...t.matches]..[idx] = replayed;
          matches = propagate(matches);
          return t.copyWith(
            matches: matches,
            audit: [
              ...t.audit,
              _event('Draw $home-$away: ${t.participantName(m.homeId)} vs ${t.participantName(m.awayId)} '
                  'will be replayed (replay #${replayed.replays.length})'),
            ],
          );
        }
        final when = rule == KnockoutDraw.extraTime ? 'extra time' : 'normal time';
        if (homePens == null || awayPens == null) {
          throw ArenaError('Level after $when: enter the penalty shoot-out score.');
        }
        if (homePens < 0 || awayPens < 0) throw ArenaError('Penalty scores cannot be negative.');
        if (homePens == awayPens) throw ArenaError('A penalty shoot-out needs a winner.');
        by = MatchDecider.penalties;
        hp = homePens;
        ap = awayPens;
      } else if (rule == KnockoutDraw.extraTime && decidedBy == MatchDecider.extraTime) {
        by = MatchDecider.extraTime;
      }
    }

    final updated = m.copyWith(
      homeScore: home,
      awayScore: away,
      status: MatchStatus.confirmed,
      decidedBy: by,
      homePens: hp,
      awayPens: ap,
    );
    var matches = [...t.matches]..[idx] = updated;
    if (m.stage == MatchStage.knockout) matches = propagate(matches);
    final names = '${t.participantName(m.homeId)} ${amend ? '${m.scoreText} -> ' : ''}'
        '${updated.scoreText} ${t.participantName(m.awayId)}';
    return t.copyWith(
      matches: matches,
      audit: [...t.audit, _event(amend ? 'Result amended: $names' : 'Result confirmed: $names')],
    );
  }

  // ------------------------------------------------------- teams and players

  /// Why teams/players cannot be changed right now (null = allowed).
  /// [positions] = true for moving whole teams, false for changing rosters.
  static String? lockReason(Tournament t, Set<String> ids, {required bool positions}) {
    if (t.isBattleRoyale) {
      if (!positions && t.brRounds.any((r) => r.confirmed)) {
        return 'A Battle Royale round is already confirmed. Reset results to change rosters.';
      }
      return null;
    }
    final played = t.matches.any(
        (m) => m.isConfirmed && !m.bye && (ids.contains(m.homeId) || ids.contains(m.awayId)));
    return played ? 'A match of these teams was already played. Reset results to make this change.' : null;
  }

  static int _indexOf(Tournament t, String id) {
    final i = t.participants.indexWhere((p) => p.id == id);
    if (i < 0) throw ArenaError('Participant not found.');
    return i;
  }

  /// Renames a team (or a solo player).
  static Tournament renameParticipant(Tournament t, String id, String name) {
    final n = name.trim();
    if (n.isEmpty) throw ArenaError('The name cannot be empty.');
    final i = _indexOf(t, id);
    if (t.participants.any((x) => x.id != id && x.name.toLowerCase() == n.toLowerCase())) {
      throw ArenaError('"$n" is already registered.');
    }
    final old = t.participants[i].name;
    final list = [...t.participants]..[i] = t.participants[i].copyWith(name: n);
    return t.copyWith(participants: list, audit: [...t.audit, _event('Renamed: $old -> $n')]);
  }

  /// Replaces the roster of a team. Enforces the size rules of the mode and
  /// refuses duplicate players.
  static Tournament setRoster(Tournament t, String participantId, List<ArenaPlayer> roster) {
    final mode = t.gameMode;
    if (mode == null || !mode.isTeamMode) throw ArenaError('This mode has no team rosters.');
    final i = _indexOf(t, participantId);
    if (roster.isEmpty) throw ArenaError('A team needs at least 1 player.');
    if (roster.length > mode.teamSize) {
      throw ArenaError('${mode.label} allows at most ${mode.teamSize} players per team.');
    }
    if (mode.fixedTeamSize && roster.length != mode.teamSize) {
      throw ArenaError('Every team must have exactly ${mode.teamSize} players.');
    }
    if (roster.any((p) => p.name.trim().isEmpty)) throw ArenaError('Player names cannot be empty.');
    final ids = <String>{};
    final names = <String>{};
    final all = [
      for (final p in t.participants)
        if (p.id != participantId) ...p.roster,
      ...roster,
    ];
    for (final p in all) {
      if (!ids.add(p.id)) throw ArenaError('"${p.name}" is already assigned to a team.');
      if (!names.add(p.name.trim().toLowerCase())) throw ArenaError('"${p.name}" is already registered.');
    }
    final reason = lockReason(t, {participantId}, positions: false);
    if (reason != null) throw ArenaError(reason);
    final clean = [for (final p in roster) p.copyWith(name: p.name.trim())];
    final list = [...t.participants]..[i] = t.participants[i].copyWith(roster: clean);
    return t.copyWith(
      participants: list,
      audit: [...t.audit, _event('Roster updated: ${t.participants[i].name} (${clean.length} players)')],
    );
  }

  /// Team A takes Team B's position and the other way round. Each team keeps
  /// its own roster. Only before either team has played.
  static Tournament swapParticipants(Tournament t, String aId, String bId) {
    if (aId == bId) throw ArenaError('Choose two different ones.');
    final ia = _indexOf(t, aId);
    final ib = _indexOf(t, bId);
    final reason = lockReason(t, {aId, bId}, positions: true);
    if (reason != null) throw ArenaError(reason);
    String? sw(String? id) => id == aId ? bId : (id == bId ? aId : id);
    final ps = [...t.participants];
    final tmp = ps[ia];
    ps[ia] = ps[ib];
    ps[ib] = tmp;
    final leagues = [
      for (final l in t.leagues)
        ArenaLeague(id: l.id, name: l.name, groups: [
          for (final g in l.groups)
            ArenaGroup(id: g.id, name: g.name, participantIds: [for (final x in g.participantIds) sw(x)!]),
        ]),
    ];
    final matches = [
      for (final m in t.matches) m.copyWith(homeId: sw(m.homeId), awayId: sw(m.awayId)),
    ];
    return t.copyWith(
      participants: ps,
      leagues: leagues,
      matches: matches,
      audit: [...t.audit, _event('Swapped: ${t.participants[ia].name} <-> ${t.participants[ib].name}')],
    );
  }

  /// Exchanges two players, also between different teams. Player ids stay
  /// the same, team sizes stay the same.
  static Tournament swapPlayers(
    Tournament t,
    String teamA,
    String playerA,
    String teamB,
    String playerB,
  ) {
    final mode = t.gameMode;
    if (mode == null || !mode.isTeamMode) throw ArenaError('This mode has no team rosters.');
    if (teamA == teamB && playerA == playerB) throw ArenaError('Choose two different players.');
    final ia = _indexOf(t, teamA);
    final ib = _indexOf(t, teamB);
    final ra = [...t.participants[ia].roster];
    final rb = teamA == teamB ? ra : [...t.participants[ib].roster];
    final pa = ra.indexWhere((p) => p.id == playerA);
    final pb = rb.indexWhere((p) => p.id == playerB);
    if (pa < 0 || pb < 0) throw ArenaError('Player not found in that team.');
    final reason = lockReason(t, {teamA, teamB}, positions: false);
    if (reason != null) throw ArenaError(reason);
    final first = ra[pa];
    final second = rb[pb];
    ra[pa] = second;
    rb[pb] = first;
    final ps = [...t.participants];
    ps[ia] = ps[ia].copyWith(roster: ra);
    if (teamA != teamB) ps[ib] = ps[ib].copyWith(roster: rb);
    return t.copyWith(
      participants: ps,
      audit: [
        ...t.audit,
        _event('Players swapped: ${first.name} (${t.participants[ia].name}) <-> '
            '${second.name} (${t.participants[ib].name})'),
      ],
    );
  }

  // ------------------------------------------------------------ battle royale

  /// Adds one more round after the planned ones.
  static Tournament brAddRound(Tournament t) {
    if (!t.isBattleRoyale) throw ArenaError('Only Battle Royale tournaments have rounds.');
    final next = t.brRounds.isEmpty ? 1 : t.brRounds.map((r) => r.number).reduce(max) + 1;
    return t.copyWith(
      brRounds: [...t.brRounds, BrRound(id: _uuid.v4(), number: next)],
      audit: [...t.audit, _event('Round $next added')],
    );
  }

  /// Confirms (or amends) one round. Every participant needs a placement
  /// (1..n, no duplicates) and a kill count (0 or more).
  static Tournament brSubmitRound(Tournament t, String roundId, Map<String, BrResult> results) {
    if (!t.isBattleRoyale) throw ArenaError('Only Battle Royale tournaments have rounds.');
    final idx = t.brRounds.indexWhere((r) => r.id == roundId);
    if (idx < 0) throw ArenaError('Round not found.');
    final ids = t.participants.map((p) => p.id).toSet();
    if (results.keys.toSet().difference(ids).isNotEmpty) throw ArenaError('Unknown participant in results.');
    if (ids.difference(results.keys.toSet()).isNotEmpty) {
      throw ArenaError('Enter a placement for every participant.');
    }
    final n = ids.length;
    final seen = <int>{};
    for (final e in results.entries) {
      final r = e.value;
      if (r.placement < 1 || r.placement > n) {
        throw ArenaError('Placements must be between 1 and $n.');
      }
      if (!seen.add(r.placement)) throw ArenaError('Two participants have placement ${r.placement}.');
      if (r.kills < 0) throw ArenaError('Kills cannot be negative.');
    }
    final old = t.brRounds[idx];
    final rounds = [...t.brRounds]..[idx] = old.copyWith(results: Map.of(results), confirmed: true);
    return t.copyWith(
      brRounds: rounds,
      audit: [
        ...t.audit,
        _event(old.confirmed ? 'Round ${old.number} amended' : 'Round ${old.number} confirmed'),
      ],
    );
  }

  /// Table from confirmed rounds only. Order: points, then wins (1st places),
  /// then kills, then placement in the latest round, then name. Each row says
  /// which of those separated it from the row above.
  static List<BrStandingRow> brStandings(Tournament t) {
    final rows = {for (final p in t.participants) p.id: BrStandingRow(p.id)};
    final done = t.brRounds.where((r) => r.confirmed).toList()..sort((a, b) => a.number.compareTo(b.number));
    for (final round in done) {
      for (final e in round.results.entries) {
        final row = rows[e.key];
        if (row == null) continue;
        row.rounds++;
        row.points += t.brScoring.pointsFor(e.value);
        row.placementPts += t.brScoring.placementPointsFor(e.value.placement);
        row.killPts += t.brScoring.killPointsFor(e.value);
        row.kills += e.value.kills;
        if (e.value.placement == 1) row.wins++;
        row.lastPlacement = e.value.placement;
      }
    }
    final list = rows.values.toList()
      ..sort((x, y) {
        var c = y.points.compareTo(x.points);
        if (c != 0) return c;
        c = y.wins.compareTo(x.wins);
        if (c != 0) return c;
        c = y.kills.compareTo(x.kills);
        if (c != 0) return c;
        c = x.lastPlacement.compareTo(y.lastPlacement);
        if (c != 0) return c;
        return t.participantName(x.id).toLowerCase().compareTo(t.participantName(y.id).toLowerCase());
      });
    for (var i = 0; i < list.length; i++) {
      final r = list[i];
      r.position = i + 1;
      if (i == 0) continue;
      final up = list[i - 1];
      final a = t.participantName(up.id), b = t.participantName(r.id);
      if (up.points != r.points) {
        r.rankedBy = 'Points';
        r.note = '$a has more points (${up.points} vs ${r.points}).';
      } else if (up.wins != r.wins) {
        r.rankedBy = 'Wins';
        r.note = 'Level on ${up.points} pts. Wins (1st places): $a ${up.wins} vs $b ${r.wins}.';
      } else if (up.kills != r.kills) {
        r.rankedBy = 'Kills';
        r.note = 'Level on ${up.points} pts and wins. Kills: $a ${up.kills} vs $b ${r.kills}.';
      } else if (up.lastPlacement != r.lastPlacement) {
        r.rankedBy = 'Last round placement';
        r.note = 'Level on points, wins and kills. Better placement in the latest round: $a.';
      } else {
        r.rankedBy = 'Name order';
        r.note = 'Level on every criterion: ranked by name.';
      }
    }
    return list;
  }

  static bool brComplete(Tournament t) =>
      t.isBattleRoyale && t.brRounds.isNotEmpty && t.brRounds.every((r) => r.confirmed);

  /// Clears every result (and the generated knockout for group tournaments).
  static Tournament resetResults(Tournament t) {
    var matches = <ArenaMatch>[];
    for (final m in t.matches) {
      if (m.stage == MatchStage.knockout && t.structure != ArenaStructure.knockoutOnly) continue;
      if (m.bye) {
        matches.add(m);
      } else {
        matches.add(ArenaMatch(
          id: m.id,
          stage: m.stage,
          round: m.round,
          slot: m.slot,
          leagueId: m.leagueId,
          groupId: m.groupId,
          homeId: m.stage == MatchStage.knockout && m.round > 0 ? null : m.homeId,
          awayId: m.stage == MatchStage.knockout && m.round > 0 ? null : m.awayId,
          bye: false,
          label: m.label,
        ));
      }
    }
    matches = propagate(matches);
    return t.copyWith(
      matches: matches,
      brRounds: [for (final r in t.brRounds) r.copyWith(results: const {}, confirmed: false)],
      knockoutGenerated: t.structure == ArenaStructure.knockoutOnly && !t.isBattleRoyale,
      audit: [...t.audit, _event('All results were reset by the organizer')],
    );
  }

  /// Winner of the whole tournament, when it can be determined.
  static String? champion(Tournament t) {
    if (t.isBattleRoyale) return brComplete(t) ? brStandings(t).first.id : null;
    final ko = t.knockoutMatches;
    if (ko.isNotEmpty) {
      final last = ko.map((m) => m.round).reduce(max);
      final finals = ko.where((m) => m.round == last).toList();
      return finals.isEmpty ? null : winnerOf(finals.first);
    }
    if (t.structure == ArenaStructure.singleLeague &&
        t.leagues.length == 1 &&
        t.leagues.first.groups.length == 1 &&
        groupStageComplete(t)) {
      return groupStandings(t, t.leagues.first.groups.first).first.id;
    }
    return null;
  }

  static AuditEvent _event(String text) => AuditEvent(at: DateTime.now(), text: text);
}
