import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/arena/arena_engine.dart';
import '../../data/arena/arena_models.dart';
import '../../data/arena/arena_repository.dart';
import 'tournament_details_screen.dart';

/// Local artwork for the games (see assets/images/games/README.txt).
const _gameAssets = <String, String>{
  'Free Fire': 'assets/images/games/free_fire.jpg',
  'eFootball': 'assets/images/games/efootball.jpg',
};

const _stepTitles = ['Select game', 'Type and mode', 'Setup', 'Details and confirm'];

class CreateTournamentScreen extends ConsumerStatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  ConsumerState<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends ConsumerState<CreateTournamentScreen> {
  final _id = const Uuid().v4();
  int _step = 0;
  bool _publishing = false;

  // Step 1-2
  String? _game;
  String? _type;
  ArenaGameMode? _mode;

  // Step 3: registration
  final _pName = TextEditingController();
  final _pRoster = TextEditingController();
  final List<ArenaParticipant> _participants = [];
  int _max = 16;

  // Step 3: format and ranking (head-to-head modes)
  ArenaStructure _structure = ArenaStructure.singleLeague;
  int _leagues = 2;
  int _groups = 2;
  int _qualifiers = 2;
  bool _double = false;
  bool _random = true;
  KnockoutDraw _koDraw = KnockoutDraw.penalties;
  int _win = 3, _draw = 1, _loss = 0;
  List<Tiebreaker> _tiebreakers = kTiebreakDirectFirst;
  final Set<StatColumn> _columns = {...kDefaultStandingColumns};

  // Step 3: battle royale
  int _brRounds = 3;

  /// Edited placement table; null means "default for the current number of
  /// participants".
  List<int>? _brCustom;

  // Step 4
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _organizer = TextEditingController();
  final _rulesText = TextEditingController();
  final _roomId = TextEditingController();
  final _roomPassword = TextEditingController();
  DateTime? _start;
  DateTime? _deadline;

  @override
  void dispose() {
    for (final c in [_pName, _pRoster, _name, _desc, _organizer, _rulesText, _roomId, _roomPassword]) {
      c.dispose();
    }
    super.dispose();
  }

  // ------------------------------------------------------------------ state

  bool get _isBr => _mode?.isBattleRoyale ?? false;

  List<int> _brTable() {
    final custom = _brCustom;
    if (custom != null && custom.length == _participants.length) return custom;
    return BrScoring.defaultTable(_participants.length);
  }

  int get _totalPlayers => _participants.fold<int>(0, (sum, p) => sum + p.players);

  Tournament _draft({bool placeholderName = false}) {
    final mode = _mode;
    final typed = _name.text.trim();
    return Tournament(
      id: _id,
      name: typed.isEmpty && placeholderName ? 'Tournament' : typed,
      description: _desc.text.trim(),
      game: _game ?? '',
      mode: mode?.label ?? '',
      organizer: _organizer.text.trim(),
      teamSize: mode?.teamSize ?? 1,
      maxParticipants: mode?.maxParticipants ?? _max,
      startDate: _start,
      registrationDeadline: _deadline,
      structure: _isBr ? ArenaStructure.singleLeague : _structure,
      leaguesCount: _leagues,
      groupsPerLeague: _groups,
      qualifiersPerGroup: _qualifiers,
      doubleRound: _double,
      randomDraw: _random,
      rules: ArenaRules(
        pointsWin: _win,
        pointsDraw: _draw,
        pointsLoss: _loss,
        tiebreakers: _tiebreakers,
        knockoutDraw: _koDraw,
      ),
      rulesText: _rulesText.text.trim(),
      roomId: _roomId.text.trim(),
      roomPassword: _roomPassword.text,
      participants: List.of(_participants),
      createdAt: DateTime.now(),
      brScoring: BrScoring(killPoints: 2, placementPoints: _brTable()),
      brRoundsPlanned: _brRounds,
      standingsColumns: [
        for (final c in StatColumn.values)
          if (_columns.contains(c)) c
      ],
    );
  }

  /// Everything the engine objects to, ignoring the (not yet typed) name.
  List<String> _setupErrors() => ArenaEngine.validate(_draft(placeholderName: true));

  bool _canGoNext() => switch (_step) {
        0 => _game != null,
        1 => _mode != null,
        2 => _setupErrors().isEmpty,
        _ => ArenaEngine.validate(_draft()).isEmpty,
      };

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  void _selectGame(String g) {
    if (_game == g) return;
    setState(() {
      _game = g;
      _type = null;
      _mode = null;
      _participants.clear();
      _brCustom = null;
    });
  }

  void _selectType(String type) {
    final modes = ArenaGameMode.ofType(_game!, type);
    setState(() {
      _type = type;
      if (modes.length == 1) {
        _selectMode(modes.first);
      } else {
        _mode = null;
        _participants.clear();
        _brCustom = null;
      }
    });
  }

  void _selectMode(ArenaGameMode m) {
    if (_mode == m) return;
    _mode = m;
    _participants.clear();
    _brCustom = null;
    _max = 16;
    if (m.isBattleRoyale) _structure = ArenaStructure.singleLeague;
    // Each mode starts from its own columns and ranking (Clash Squad: no goals).
    _columns
      ..clear()
      ..addAll(m.defaultColumns);
    _tiebreakers = m.winnerOnly ? const [Tiebreaker.headToHead] : kTiebreakDirectFirst;
    _win = 3;
    _draw = m.winnerOnly ? 0 : 1;
    _loss = 0;
  }

  void _addParticipant() {
    final mode = _mode;
    if (mode == null) return;
    final name = _pName.text.trim();
    if (name.isEmpty) return;
    final cap = mode.maxParticipants ?? _max;
    if (_participants.length >= cap) {
      _snack('Maximum reached ($cap).');
      return;
    }
    if (_participants.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
      _snack('"$name" is already registered.');
      return;
    }
    var roster = <ArenaPlayer>[];
    if (mode.isTeamMode) {
      final names = _pRoster.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      if (names.isEmpty) {
        _snack('Enter the players of the team, separated by commas.');
        return;
      }
      if (names.length > mode.teamSize) {
        _snack('${mode.label} allows at most ${mode.teamSize} players per team.');
        return;
      }
      if (mode.fixedTeamSize && names.length != mode.teamSize) {
        _snack('Every team needs exactly ${mode.teamSize} players.');
        return;
      }
      final taken = {
        for (final p in _participants)
          for (final r in p.roster) r.name.toLowerCase()
      };
      final seen = <String>{};
      for (final n in names) {
        final k = n.toLowerCase();
        if (taken.contains(k) || !seen.add(k)) {
          _snack('"$n" is already registered.');
          return;
        }
      }
      roster = [for (final n in names) ArenaPlayer(id: const Uuid().v4(), name: n)];
    }
    setState(() {
      _participants.add(ArenaParticipant(id: const Uuid().v4(), name: name, roster: roster));
      _pName.clear();
      _pRoster.clear();
      _brCustom = null;
    });
  }

  Future<void> _pickDateTime(bool deadline) async {
    final now = DateTime.now();
    final current = (deadline ? _deadline : _start) ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(current));
    if (!mounted) return;
    final picked = DateTime(date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
    setState(() => deadline ? _deadline = picked : _start = picked);
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    try {
      final built = ArenaEngine.build(_draft());
      await ref.read(arenaProvider.notifier).add(built);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => TournamentDetailsScreen(tournamentId: built.id)));
    } on ArenaError catch (e) {
      if (mounted) _snack(e.message);
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final last = _step == _stepTitles.length - 1;
    final canNext = _canGoNext();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Tournament')),
      body: Column(children: [
        _StepHeader(step: _step, titles: _stepTitles),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: switch (_step) {
              0 => _stepGame(),
              1 => _stepType(),
              2 => _stepSetup(),
              _ => _stepDetails(),
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(children: [
              if (_step > 0) ...[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size(88, 50)),
                  onPressed: () => setState(() => _step--),
                  child: const Text('Back'),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  onPressed: !canNext || _publishing
                      ? null
                      : (last ? _publish : () => setState(() => _step++)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    if (last && _publishing)
                      const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    else if (last)
                      const Icon(Icons.emoji_events_outlined),
                    if (last) const SizedBox(width: 8),
                    Text(last ? 'Create Tournament' : 'Next'),
                    if (!last) ...[const SizedBox(width: 8), const Icon(Icons.arrow_forward, size: 18)],
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  // ------------------------------------------------------------ step 1: game

  List<Widget> _stepGame() => [
        const _Heading('Select Game', 'Choose the game for your tournament.'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.82,
          children: [
            for (final g in ArenaGameMode.games)
              _GameCard(
                title: g,
                asset: _gameAssets[g],
                selected: _game == g,
                onTap: () => _selectGame(g),
              ),
          ],
        ),
      ];

  // -------------------------------------------------------- step 2: type/mode

  List<Widget> _stepType() {
    final game = _game!;
    final types = ArenaGameMode.typesFor(game);
    final modes = _type == null ? const <ArenaGameMode>[] : ArenaGameMode.ofType(game, _type!);
    return [
      _Heading('Select Tournament Type', 'Choose the mode you want to organize in $game.'),
      for (final type in types)
        _ChoiceTile(
          title: type,
          subtitle: _typeSubtitle(game, type),
          selected: _type == type,
          onTap: () => _selectType(type),
        ),
      if (_type != null && modes.length > 1) ...[
        const SizedBox(height: 12),
        _Heading('Select Mode', 'Pick the format for your $_type.'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: modes.length == 3 ? 3 : 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: modes.length == 3 ? 0.9 : 1.5,
          children: [
            for (final m in modes)
              _ModeTile(mode: m, selected: _mode == m, onTap: () => setState(() => _selectMode(m))),
          ],
        ),
      ],
      if (_mode != null) ...[
        const SizedBox(height: 12),
        _InfoCard(icon: Icons.info_outline, title: _infoTitle(_mode!), text: _infoText(_mode!)),
      ],
    ];
  }

  String _typeSubtitle(String game, String type) {
    final modes = ArenaGameMode.ofType(game, type);
    return modes.length > 1 ? modes.map((m) => m.short).join(' / ') : modes.first.detail;
  }

  String _infoTitle(ArenaGameMode m) => m.isBattleRoyale
      ? 'Points system'
      : (m.type == 'Clash Squad'
          ? (m.teamSize == 1 ? 'Two players per match' : 'Minimum: 2 teams')
          : (m.minTotalPlayers > 0 ? 'Minimum players: ${m.minTotalPlayers}' : 'How it works'));

  String _infoText(ArenaGameMode m) {
    if (m.isBattleRoyale) {
      return 'Total = placement points + 2 points per kill. The last three placements score 0 '
          'placement points. ${m.detail}.';
    }
    if (m.type == 'Clash Squad') {
      return m.teamSize == 1
          ? 'Each match needs two players, both slots filled. Register at least 2 players. '
              'A match is won or lost: no goals, no draws.'
          : 'At least 2 teams are needed. Teams can have different numbers of players '
              '(for example 2 against 1), up to ${m.teamSize} per team. A match is won or lost: '
              'no goals, no draws.';
    }
    if (m.minTotalPlayers > 0) {
      return '${m.minTotalPlayers} registered players in total are needed to start. '
          'The team size (${m.teamSize}) is a maximum: you do not have to fill every slot.';
    }
    return 'Each match has two players. Results decide the standings.';
  }

  // ---------------------------------------------------------------- step 3

  List<Widget> _stepSetup() {
    final mode = _mode!;
    final br = mode.isBattleRoyale;
    final errors = _setupErrors();
    final standings = !br && _structure != ArenaStructure.knockoutOnly;
    return [
      _Heading(mode.label, 'Registration, format and rules.'),
      _registration(mode),
      if (br) ..._brSetup(mode) else ..._formatSetup(),
      if (standings) ..._rankingSetup(),
      const SizedBox(height: 4),
      if (errors.isEmpty)
        Row(children: [
          Icon(Icons.check_circle_outline, color: SpheraColors.gold),
          const SizedBox(width: 8),
          const Expanded(child: Text('Setup is valid. Continue to the last step.')),
        ])
      else ...[
        Text('To continue', style: TextStyle(color: SpheraColors.muted, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        for (final e in errors) _ErrorLine(e),
      ],
    ];
  }

  Widget _registration(ArenaGameMode mode) {
    final unit = mode.isTeamMode ? 'team' : 'player';
    final cap = mode.maxParticipants ?? _max;
    return _Panel(title: 'Registration', children: [
      if (mode.maxParticipants == null)
        _NumberStepper(
            label: 'Maximum ${unit}s', value: _max, min: 2, max: 128, onChanged: (v) => setState(() => _max = v))
      else
        Text('Limit: up to ${mode.maxParticipants} ${unit}s (${mode.detail}).',
            style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
      if (mode.minTotalPlayers > 0)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'At least ${mode.minTotalPlayers} players in total. Teams do not have to be full.',
            style: TextStyle(color: SpheraColors.muted, fontSize: 12),
          ),
        ),
      const SizedBox(height: 10),
      TextField(
        controller: _pName,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _addParticipant(),
        decoration: InputDecoration(labelText: mode.isTeamMode ? 'Team name' : 'Player name'),
      ),
      if (mode.isTeamMode) ...[
        const SizedBox(height: 8),
        TextField(
          controller: _pRoster,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _addParticipant(),
          decoration: InputDecoration(
            labelText: 'Players (names separated by commas)',
            hintText: 'e.g. Ali, Sara',
            helperText: mode.fixedTeamSize
                ? 'Exactly ${mode.teamSize} players per team.'
                : '1 to ${mode.teamSize} players per team. Teams do not have to be full.',
          ),
        ),
      ],
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerRight,
        child: FilledButton.icon(
            onPressed: _addParticipant, icon: const Icon(Icons.person_add_alt_1), label: const Text('Add')),
      ),
      const SizedBox(height: 8),
      Text(
        '${_participants.length} / $cap ${unit}s'
        '${mode.isTeamMode ? ' · $_totalPlayers players' : ''}',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      for (var i = 0; i < _participants.length; i++)
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 14,
            backgroundColor: SpheraColors.gold.withValues(alpha: 0.18),
            child: Text('${i + 1}', style: const TextStyle(fontSize: 12)),
          ),
          title: Text(_participants[i].name),
          subtitle: mode.isTeamMode
              ? Text(_participants[i].roster.map((r) => r.name).join(', '), maxLines: 2, overflow: TextOverflow.ellipsis)
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() {
              _participants.removeAt(i);
              _brCustom = null;
            }),
          ),
        ),
    ]);
  }

  // ---- format (head-to-head)

  List<Widget> _formatSetup() {
    final s = _structure;
    return [
      _Panel(title: 'Format', children: [
        DropdownButtonFormField<ArenaStructure>(
          initialValue: _structure,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Tournament format'),
          items: [
            for (final v in ArenaStructure.values) DropdownMenuItem(value: v, child: Text(v.label)),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _structure = v);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: Text(s.hint, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        ),
        if (s.usesLeagues)
          _NumberStepper(
              label: 'Number of leagues', value: _leagues, min: 2, max: 8, onChanged: (v) => setState(() => _leagues = v)),
        if (s.usesGroups)
          _NumberStepper(
              label: 'Groups per league', value: _groups, min: 2, max: 8, onChanged: (v) => setState(() => _groups = v)),
        if (s.hasKnockout && s != ArenaStructure.knockoutOnly)
          _NumberStepper(
              label: 'Qualifiers per group',
              value: _qualifiers,
              min: 1,
              max: 8,
              onChanged: (v) => setState(() => _qualifiers = v)),
        if (s != ArenaStructure.knockoutOnly)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Double round-robin'),
            subtitle: const Text('Home and away: everyone plays everyone twice'),
            value: _double,
            onChanged: (v) => setState(() => _double = v),
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Random draw'),
          subtitle: const Text('Off: participants are placed in the order they were added'),
          value: _random,
          onChanged: (v) => setState(() => _random = v),
        ),
        if (s.hasKnockout && !(_mode?.winnerOnly ?? false)) ...[
          const SizedBox(height: 8),
          const Text('If a knockout match ends level', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            for (final k in KnockoutDraw.values)
              ChoiceChip(
                label: Text(k.label),
                selected: _koDraw == k,
                onSelected: (_) => setState(() => _koDraw = k),
              ),
          ]),
          const SizedBox(height: 6),
          Text(_koDraw.hint, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        ],
      ]),
    ];
  }

  // ---- points, ranking, standings columns (head-to-head)

  bool _sameOrder(List<Tiebreaker> a, List<Tiebreaker> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  List<Widget> _rankingSetup() {
    final mode = _mode!;
    final wo = mode.winnerOnly;
    final ordered = [
      for (final c in StatColumn.values)
        if (_columns.contains(c)) c
    ];
    return [
      _Panel(title: 'Points and ranking', children: [
        _NumberStepper(label: 'Win', value: _win, min: 0, max: 10, onChanged: (v) => setState(() => _win = v)),
        if (!wo)
          _NumberStepper(label: 'Draw', value: _draw, min: 0, max: 10, onChanged: (v) => setState(() => _draw = v)),
        _NumberStepper(label: 'Loss', value: _loss, min: 0, max: 10, onChanged: (v) => setState(() => _loss = v)),
        if (!wo) ...[
          const SizedBox(height: 10),
          const Text('Tie-breaker order', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ChoiceChip(
              label: const Text('Direct match first'),
              selected: _sameOrder(_tiebreakers, kTiebreakDirectFirst),
              onSelected: (_) => setState(() => _tiebreakers = kTiebreakDirectFirst),
            ),
            ChoiceChip(
              label: const Text('Goal difference first'),
              selected: _sameOrder(_tiebreakers, kTiebreakClassic),
              onSelected: (_) => setState(() => _tiebreakers = kTiebreakClassic),
            ),
          ]),
        ],
        const SizedBox(height: 10),
        _RankingPreview(order: _tiebreakers),
        const SizedBox(height: 6),
        Text(
          wo
              ? 'The winner of a match takes the win points. Teams level on points are ranked by '
                  'their direct match, then by name. Locked once the tournament starts.'
              : 'These rules are locked once the tournament starts. Teams still level after every '
                  'criterion are ordered by name.',
          style: TextStyle(color: SpheraColors.muted, fontSize: 12),
        ),
      ]),
      _Panel(title: 'Standings columns', children: [
        Text('${_columns.length} column${_columns.length == 1 ? '' : 's'} selected. Rank and name are always shown.',
            style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 4, children: [
          for (final c in mode.standingColumns)
            FilterChip(
              label: Text(c.short),
              tooltip: c.label,
              selected: _columns.contains(c),
              onSelected: (on) => setState(() {
                if (on) {
                  if (_columns.length < kMaxStandingColumns) _columns.add(c);
                } else if (_columns.length > 1) {
                  _columns.remove(c);
                }
              }),
            ),
        ]),
        const SizedBox(height: 10),
        _TablePreview(columns: ordered),
      ]),
    ];
  }

  // ---- battle royale

  List<Widget> _brSetup(ArenaGameMode mode) {
    final n = _participants.length;
    final table = _brTable();
    return [
      _Panel(title: 'Rounds and scoring', children: [
        _NumberStepper(
            label: 'Planned rounds', value: _brRounds, min: 1, max: 20, onChanged: (v) => setState(() => _brRounds = v)),
        const SizedBox(height: 4),
        const _InfoCard(
          icon: Icons.bolt_outlined,
          title: 'Total = placement points + kills x 2',
          text: 'For duo and squad, the kills of all team members are added together.',
        ),
      ]),
      _Panel(title: 'Placement points', children: [
        if (n < mode.minParticipants)
          Text(
            'Register at least ${mode.minParticipants} ${mode.isTeamMode ? 'teams' : 'players'} to configure '
            'the table (it has one row per ${mode.isTeamMode ? 'team' : 'player'}).',
            style: TextStyle(color: SpheraColors.muted, fontSize: 12),
          )
        else ...[
          Text('The last ${BrScoring.zeroTail} placements always score 0 placement points.',
              style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          const SizedBox(height: 6),
          for (var i = 0; i < n; i++)
            _PlacementRow(
              place: i + 1,
              value: table[i],
              locked: i >= n - BrScoring.zeroTail,
              onChanged: (v) => setState(() {
                final next = [...table];
                next[i] = v;
                _brCustom = next;
              }),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _brCustom == null ? null : () => setState(() => _brCustom = null),
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset to default'),
            ),
          ),
        ],
      ]),
    ];
  }

  // ---------------------------------------------------------------- step 4

  String _fmt(DateTime? d) => d == null
      ? 'Not set'
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  List<Widget> _stepDetails() {
    final d = _draft();
    final errors = ArenaEngine.validate(d);
    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 112, child: Text(k, style: TextStyle(color: SpheraColors.muted))),
            Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600))),
          ]),
        );
    final mode = _mode!;
    final standings = !_isBr && d.structure != ArenaStructure.knockoutOnly;
    return [
      const _Heading('Tournament Settings', 'Set the final details of your tournament.'),
      TextField(
        controller: _name,
        maxLength: 40,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(labelText: 'Tournament name *', hintText: 'e.g. SPHERA Cup'),
      ),
      const SizedBox(height: 4),
      TextField(controller: _organizer, decoration: const InputDecoration(labelText: 'Organizer')),
      const SizedBox(height: 12),
      TextField(controller: _desc, maxLines: 2, decoration: const InputDecoration(labelText: 'Description')),
      const SizedBox(height: 12),
      _DateTile(
          label: 'Start date and time',
          text: _fmt(_start),
          hasValue: _start != null,
          onTap: () => _pickDateTime(false),
          onClear: () => setState(() => _start = null)),
      const SizedBox(height: 8),
      _DateTile(
          label: 'Registration deadline',
          text: _fmt(_deadline),
          hasValue: _deadline != null,
          onTap: () => _pickDateTime(true),
          onClear: () => setState(() => _deadline = null)),
      const SizedBox(height: 12),
      TextField(
        controller: _rulesText,
        maxLines: 4,
        decoration: const InputDecoration(labelText: 'Rules and penalties', alignLabelWithHint: true),
      ),
      const SizedBox(height: 12),
      TextField(controller: _roomId, decoration: const InputDecoration(labelText: 'Room ID (optional)')),
      const SizedBox(height: 12),
      TextField(
        controller: _roomPassword,
        obscureText: true,
        decoration: const InputDecoration(labelText: 'Room password (optional)'),
      ),
      const SizedBox(height: 16),
      _Panel(title: 'Review', children: [
        row('Game', '${d.game} · ${mode.label}'),
        row('Participants',
            '${d.participants.length}${mode.isTeamMode ? ' ($_totalPlayers players)' : ''} · max ${d.maxParticipants}'),
        if (_isBr) ...[
          row('Rounds', '$_brRounds'),
          row('Scoring', 'Placement points + kills x 2'),
        ] else ...[
          row('Format', d.structure.label),
          if (d.structure != ArenaStructure.knockoutOnly)
            row(
                'Points',
                mode.winnerOnly
                    ? 'Win ${d.rules.pointsWin} · Loss ${d.rules.pointsLoss}'
                    : 'W ${d.rules.pointsWin} · D ${d.rules.pointsDraw} · L ${d.rules.pointsLoss}'),
          if (d.structure.hasKnockout && !mode.winnerOnly) row('If level', d.rules.knockoutDraw.label),
        ],
        if (standings) ...[
          row('Columns', d.standingsColumns.map((c) => c.short).join(', ')),
          const SizedBox(height: 6),
          _RankingPreview(order: d.rules.tiebreakers),
          const SizedBox(height: 6),
          Text('Please read and confirm: the ranking rules lock when the tournament starts.',
              style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        ],
      ]),
      const SizedBox(height: 8),
      if (errors.isEmpty)
        Row(children: [
          Icon(Icons.check_circle_outline, color: SpheraColors.gold),
          const SizedBox(width: 8),
          Expanded(
              child: Text(_isBr
                  ? 'Everything looks valid. Creating generates the rounds.'
                  : 'Everything looks valid. Creating generates the fixtures.')),
        ])
      else
        for (final e in errors) _ErrorLine(e),
    ];
  }
}

// ======================================================================= widgets

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step, required this.titles});
  final int step;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Step ${step + 1} of ${titles.length} · ${titles[step]}',
            style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(children: [
          for (var i = 0; i < titles.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(height: 2, color: i <= step ? SpheraColors.gold : SpheraColors.border),
              ),
            _Dot(number: i + 1, done: i < step, current: i == step),
          ],
        ]),
      ]),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.number, required this.done, required this.current});
  final int number;
  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final active = done || current;
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: current ? SpheraColors.gold : SpheraColors.surface,
        border: Border.all(color: active ? SpheraColors.gold : SpheraColors.border, width: 1.5),
        boxShadow: current ? [BoxShadow(color: SpheraColors.gold.withValues(alpha: 0.4), blurRadius: 10)] : null,
      ),
      child: done
          ? Icon(Icons.check, size: 16, color: SpheraColors.gold)
          : Text('$number',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: current ? SpheraColors.black : SpheraColors.muted,
              )),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title, this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(color: SpheraColors.muted, fontSize: 13)),
      ]),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title.toUpperCase(),
              style: TextStyle(
                  color: SpheraColors.gold, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1)),
          const SizedBox(height: 10),
          ...children,
        ]),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.title, required this.asset, required this.selected, required this.onTap});
  final String title;
  final String? asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: SpheraColors.surfaceHigh,
      child: Icon(Icons.sports_esports, size: 48, color: SpheraColors.gold),
    );
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? SpheraColors.gold : SpheraColors.border, width: selected ? 2 : 1),
          boxShadow: selected ? [BoxShadow(color: SpheraColors.gold.withValues(alpha: 0.35), blurRadius: 14)] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(fit: StackFit.expand, children: [
            if (asset == null)
              fallback
            else
              Image.asset(asset!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xDD000000)],
                  stops: [0.45, 1],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            ),
            if (selected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: SpheraColors.gold),
                  child: Icon(Icons.check, size: 16, color: SpheraColors.black),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({required this.title, required this.subtitle, required this.selected, required this.onTap});
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: selected ? SpheraColors.gold : SpheraColors.border, width: selected ? 2 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? SpheraColors.gold : SpheraColors.muted),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({required this.mode, required this.selected, required this.onTap});
  final ArenaGameMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = mode.teamSize <= 1 ? Icons.person : (mode.teamSize == 2 ? Icons.people : Icons.groups);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? SpheraColors.gold.withValues(alpha: 0.12) : SpheraColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? SpheraColors.gold : SpheraColors.border, width: selected ? 2 : 1),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 28, color: selected ? SpheraColors.gold : SpheraColors.muted),
          const SizedBox(height: 6),
          Text(mode.short, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 2),
          Text(mode.detail,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: SpheraColors.surfaceHigh,
        border: Border.all(color: SpheraColors.gold.withValues(alpha: 0.4)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: SpheraColors.gold, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(text, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          ]),
        ),
      ]),
    );
  }
}

class _ErrorLine extends StatelessWidget {
  const _ErrorLine(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.error_outline, color: SpheraColors.danger, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ]),
    );
  }
}

/// "Pts → H2H → GD → GF → GA"
class _RankingPreview extends StatelessWidget {
  const _RankingPreview({required this.order});
  final List<Tiebreaker> order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SpheraColors.gold.withValues(alpha: 0.6)),
        color: SpheraColors.gold.withValues(alpha: 0.08),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Ranking order', style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w800, fontSize: 12)),
        const SizedBox(height: 4),
        Text('Pts → ${order.map((t) => t.short).join(' → ')}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 4),
        for (final t in order)
          Text('${t.short}: ${t.explanation}', style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
      ]),
    );
  }
}

/// Sample standings that follow the columns the organizer selected.
class _TablePreview extends StatelessWidget {
  const _TablePreview({required this.columns});
  final List<StatColumn> columns;

  // Index = StatColumn.index: played, won, drawn, lost, gf, ga, gd, pts.
  static const _teams = [
    ('Team Alpha', [3, 2, 1, 0, 6, 2, 4, 7]),
    ('Team Bravo', [3, 2, 0, 1, 5, 3, 2, 6]),
    ('Team Delta', [3, 0, 1, 2, 2, 6, -4, 1]),
  ];

  String _cell(StatColumn c, int v) => c == StatColumn.goalDifference && v > 0 ? '+$v' : '$v';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SpheraColors.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 14,
          horizontalMargin: 8,
          headingRowHeight: 30,
          dataRowMinHeight: 34,
          dataRowMaxHeight: 36,
          headingTextStyle: TextStyle(color: SpheraColors.muted, fontSize: 12, fontWeight: FontWeight.w700),
          columns: [
            const DataColumn(label: Text('#')),
            const DataColumn(label: Text('Team')),
            for (final c in columns) DataColumn(label: Text(c.short), numeric: true),
          ],
          rows: [
            for (var i = 0; i < _teams.length; i++)
              DataRow(cells: [
                DataCell(Text('${i + 1}')),
                DataCell(Text(_teams[i].$1)),
                for (final c in columns) DataCell(Text(_cell(c, _teams[i].$2[c.index]))),
              ]),
          ],
        ),
      ),
    );
  }
}

class _PlacementRow extends StatelessWidget {
  const _PlacementRow({required this.place, required this.value, required this.locked, required this.onChanged});
  final int place;
  final int value;
  final bool locked;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 48, child: Text('#$place', style: const TextStyle(fontWeight: FontWeight.w700))),
      const Spacer(),
      if (locked)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(children: [
            Icon(Icons.lock_outline, size: 16, color: SpheraColors.muted),
            const SizedBox(width: 6),
            Text('0', style: TextStyle(color: SpheraColors.muted, fontWeight: FontWeight.w700)),
          ]),
        )
      else ...[
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 32,
          child: Text('$value', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: value < 99 ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    ]);
  }
}

class _NumberStepper extends StatelessWidget {
  const _NumberStepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(child: Text(label)),
        IconButton(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 36,
          child: Text('$value', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ),
        IconButton(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ]),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.text,
    required this.hasValue,
    required this.onTap,
    required this.onClear,
  });
  final String label;
  final String text;
  final bool hasValue;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        dense: true,
        leading: Icon(Icons.event, color: SpheraColors.gold),
        title: Text(label),
        subtitle: Text(text),
        trailing: hasValue ? IconButton(icon: const Icon(Icons.close), onPressed: onClear) : null,
        onTap: onTap,
      ),
    );
  }
}
