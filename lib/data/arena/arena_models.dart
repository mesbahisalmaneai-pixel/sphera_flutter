// SPHERA TOURNAMENT ARENA - data models.
//
// Hierarchy: Tournament -> Leagues -> Groups -> Participants -> Matches.
// Standings are NEVER stored: they are derived from confirmed match results
// (see arena_engine.dart), so they cannot drift out of sync with the results.

enum ArenaStructure {
  singleLeague,
  multipleLeagues,
  groupsOnly,
  groupsKnockout,
  multiLeaguesGroupsKnockout,
  knockoutOnly,
}

extension ArenaStructureX on ArenaStructure {
  String get label => switch (this) {
        ArenaStructure.singleLeague => 'Single League',
        ArenaStructure.multipleLeagues => 'Multiple Leagues',
        ArenaStructure.groupsOnly => 'Groups Only',
        ArenaStructure.groupsKnockout => 'Groups + Knockout',
        ArenaStructure.multiLeaguesGroupsKnockout => 'Leagues + Groups + Knockout',
        ArenaStructure.knockoutOnly => 'Knockout Only',
      };

  String get hint => switch (this) {
        ArenaStructure.singleLeague => 'Everyone plays everyone in one table.',
        ArenaStructure.multipleLeagues => 'Participants are split into several independent leagues.',
        ArenaStructure.groupsOnly => 'One league divided into groups, each with its own table.',
        ArenaStructure.groupsKnockout => 'Group stage, then the best qualify for a knockout bracket.',
        ArenaStructure.multiLeaguesGroupsKnockout =>
          'Several leagues, each with groups; qualifiers meet in one knockout.',
        ArenaStructure.knockoutOnly => 'Single-elimination bracket with byes when needed.',
      };

  bool get hasKnockout =>
      this == ArenaStructure.groupsKnockout ||
      this == ArenaStructure.multiLeaguesGroupsKnockout ||
      this == ArenaStructure.knockoutOnly;

  bool get usesLeagues =>
      this == ArenaStructure.multipleLeagues || this == ArenaStructure.multiLeaguesGroupsKnockout;

  bool get usesGroups =>
      this == ArenaStructure.groupsOnly ||
      this == ArenaStructure.groupsKnockout ||
      this == ArenaStructure.multiLeaguesGroupsKnockout;
}

enum MatchStage { group, knockout }

enum MatchStatus { scheduled, confirmed, cancelled }

/// How a tournament is played. Decides which result model applies.
enum ArenaFormat {
  /// Two sides meet in a match (league, groups, knockout).
  headToHead,

  /// Everyone plays the same lobby; each round gives a placement + kills.
  battleRoyale,
}

/// A playable mode of a game. [Tournament.mode] stores [label] (a String) so
/// saved tournaments keep working.
class ArenaGameMode {
  const ArenaGameMode({
    required this.game,
    required this.type,
    required this.label,
    required this.short,
    required this.detail,
    required this.format,
    this.teamSize = 1,
    this.fixedTeamSize = false,
    this.maxParticipants,
    this.minParticipants = 2,
    this.minTotalPlayers = 0,
    this.winnerOnly = false,
  });

  final String game;

  /// Main tournament type the organizer picks first (e.g. "Battle Royale").
  final String type;

  /// Unique within [game]; this is what [Tournament.mode] stores.
  final String label;

  /// Short tile title (e.g. "Duo", "4v4").
  final String short;

  /// One-line limits shown on the tile.
  final String detail;
  final ArenaFormat format;

  /// Maximum players per participant (a participant is a player or a team).
  final int teamSize;

  /// True when every team must have exactly [teamSize] players.
  final bool fixedTeamSize;

  /// Cap on registered participants (players for solo modes, teams otherwise).
  final int? maxParticipants;
  final int minParticipants;

  /// Minimum number of registered players in total (0 = no extra rule).
  final int minTotalPlayers;

  /// Clash Squad: a match is decided by WHO WON. No goals, no draws, so the
  /// standings only know played, wins, losses and points.
  final bool winnerOnly;

  bool get isBattleRoyale => format == ArenaFormat.battleRoyale;
  bool get isTeamMode => teamSize > 1;

  /// Statistics the standings table may show for this mode.
  List<StatColumn> get standingColumns => winnerOnly
      ? const [StatColumn.played, StatColumn.won, StatColumn.lost, StatColumn.points]
      : StatColumn.values;

  List<StatColumn> get defaultColumns => winnerOnly ? standingColumns : kDefaultStandingColumns;

  // ---- Free Fire: Battle Royale
  static const brSolo = ArenaGameMode(
    game: 'Free Fire',
    type: 'Battle Royale',
    label: 'Battle Royale Solo',
    short: 'Solo',
    detail: 'up to 48 players',
    format: ArenaFormat.battleRoyale,
    maxParticipants: 48,
    minParticipants: 4,
  );
  static const brDuo = ArenaGameMode(
    game: 'Free Fire',
    type: 'Battle Royale',
    label: 'Battle Royale Duo',
    short: 'Duo',
    detail: 'up to 24 teams · 2 players each',
    format: ArenaFormat.battleRoyale,
    teamSize: 2,
    fixedTeamSize: true,
    maxParticipants: 24,
    minParticipants: 4,
  );
  static const brSquad = ArenaGameMode(
    game: 'Free Fire',
    type: 'Battle Royale',
    label: 'Battle Royale Squad',
    short: 'Squad',
    detail: 'up to 12 teams · 4 players each',
    format: ArenaFormat.battleRoyale,
    teamSize: 4,
    fixedTeamSize: true,
    maxParticipants: 12,
    minParticipants: 4,
  );

  // ---- Free Fire: Clash Squad (at least 2 teams; teams may have different sizes)
  static const cs1v1 = ArenaGameMode(
    game: 'Free Fire',
    type: 'Clash Squad',
    label: 'Clash Squad 1v1',
    short: '1v1',
    detail: '1 player per team',
    format: ArenaFormat.headToHead,
    winnerOnly: true,
  );
  static const cs2v2 = ArenaGameMode(
    game: 'Free Fire',
    type: 'Clash Squad',
    label: 'Clash Squad 2v2',
    short: '2v2',
    detail: 'up to 2 players per team',
    format: ArenaFormat.headToHead,
    winnerOnly: true,
    teamSize: 2,
  );
  static const cs4v4 = ArenaGameMode(
    game: 'Free Fire',
    type: 'Clash Squad',
    label: 'Clash Squad 4v4',
    short: '4v4',
    detail: 'up to 4 players per team',
    format: ArenaFormat.headToHead,
    winnerOnly: true,
    teamSize: 4,
  );
  static const cs8v8 = ArenaGameMode(
    game: 'Free Fire',
    type: 'Clash Squad',
    label: 'Clash Squad 8v8',
    short: '8v8',
    detail: 'up to 8 players per team',
    format: ArenaFormat.headToHead,
    winnerOnly: true,
    teamSize: 8,
  );

  // ---- eFootball
  static const efootballPvp = ArenaGameMode(
    game: 'eFootball',
    type: 'PvP',
    label: 'PvP',
    short: 'PvP',
    detail: '1 vs 1',
    format: ArenaFormat.headToHead,
  );
  static const efootballCoop = ArenaGameMode(
    game: 'eFootball',
    type: 'CO-OP Team',
    label: 'CO-OP Team',
    short: 'CO-OP Team',
    detail: 'team vs team · up to 3 players per team',
    format: ArenaFormat.headToHead,
    teamSize: 3,
    minTotalPlayers: 6,
  );

  /// Modes offered when creating a tournament.
  static const all = <ArenaGameMode>[
    brSolo,
    brDuo,
    brSquad,
    cs1v1,
    cs2v2,
    cs4v4,
    cs8v8,
    efootballPvp,
    efootballCoop,
  ];

  /// Labels saved by older versions of the app. Never offered for new
  /// tournaments, but old tournaments keep loading and playing.
  static const _legacy = <ArenaGameMode>[
    ArenaGameMode(
      game: 'eFootball',
      type: 'PvP',
      label: '1v1 Match',
      short: '1v1',
      detail: '1 vs 1',
      format: ArenaFormat.headToHead,
    ),
    ArenaGameMode(
      game: 'Free Fire',
      type: 'Clash Squad',
      label: 'Clash Squad (custom team size)',
      short: 'Custom',
      detail: 'custom team size',
      format: ArenaFormat.headToHead,
      teamSize: 8,
    ),
  ];

  /// Games in display order.
  static List<String> get games => [
        for (final g in {for (final m in all) m.game}) g
      ];

  /// Main types of a game, in display order.
  static List<String> typesFor(String game) => [
        for (final t in {for (final m in all.where((m) => m.game == game)) m.type}) t
      ];

  static List<ArenaGameMode> ofType(String game, String type) =>
      all.where((m) => m.game == game && m.type == type).toList();

  static List<ArenaGameMode> forGame(String game) =>
      all.where((m) => m.game == game).toList();

  static ArenaGameMode? find(String game, String label) {
    for (final m in [...all, ..._legacy]) {
      if (m.game == game && m.label == label) return m;
    }
    return null;
  }
}

/// Order matters: [ArenaRules.tiebreakers] is applied in this order and the
/// create screen lists the chips in this order. Head-to-head comes first, so
/// the direct match between tied teams is decided BEFORE goal difference.
enum Tiebreaker { headToHead, goalDifference, goalsScored, goalsAgainst }

/// Ready-made orders (applied after points).
const kTiebreakDirectFirst = [
  Tiebreaker.headToHead,
  Tiebreaker.goalDifference,
  Tiebreaker.goalsScored,
  Tiebreaker.goalsAgainst,
];
const kTiebreakClassic = [
  Tiebreaker.goalDifference,
  Tiebreaker.headToHead,
  Tiebreaker.goalsScored,
  Tiebreaker.goalsAgainst,
];

extension TiebreakerX on Tiebreaker {
  String get label => switch (this) {
        Tiebreaker.headToHead => 'Head-to-head',
        Tiebreaker.goalDifference => 'Goal difference',
        Tiebreaker.goalsScored => 'Goals scored',
        Tiebreaker.goalsAgainst => 'Goals against',
      };

  String get short => switch (this) {
        Tiebreaker.headToHead => 'H2H',
        Tiebreaker.goalDifference => 'GD',
        Tiebreaker.goalsScored => 'GF',
        Tiebreaker.goalsAgainst => 'GA',
      };

  /// Plain-language rule, shown on the rules screen and in the standings.
  String get explanation => switch (this) {
        Tiebreaker.headToHead =>
          'Teams level on points are ranked by the matches they played against each other: '
              'points first, then goal difference in those matches.',
        Tiebreaker.goalDifference =>
          'Goals scored minus goals conceded over all matches.',
        Tiebreaker.goalsScored => 'The team that scored more goals ranks higher.',
        Tiebreaker.goalsAgainst => 'The team that conceded fewer goals ranks higher.',
      };
}

/// What happens when a KNOCKOUT match ends level. Chosen by the organizer when
/// the tournament is created and applied to every knockout match.
enum KnockoutDraw { penalties, extraTime, replay }

extension KnockoutDrawX on KnockoutDraw {
  String get label => switch (this) {
        KnockoutDraw.penalties => 'Penalties',
        KnockoutDraw.extraTime => 'Extra time',
        KnockoutDraw.replay => 'Replay',
      };

  String get hint => switch (this) {
        KnockoutDraw.penalties => 'Level after normal time: decided by a penalty shoot-out.',
        KnockoutDraw.extraTime =>
          'Level after normal time: extra time is played. If still level, penalties decide.',
        KnockoutDraw.replay => 'Level after normal time: the match is played again until there is a winner.',
      };
}

/// How a confirmed knockout match was decided.
enum MatchDecider { regular, extraTime, penalties }

extension MatchDeciderX on MatchDecider {
  String get label => switch (this) {
        MatchDecider.regular => '',
        MatchDecider.extraTime => 'a.e.t.',
        MatchDecider.penalties => 'pens',
      };
}

/// One played score line (used to keep the history of replayed draws).
class ScoreLine {
  const ScoreLine(this.home, this.away);
  final int home;
  final int away;

  Map<String, dynamic> toJson() => {'h': home, 'a': away};

  factory ScoreLine.fromJson(Map<String, dynamic> j) =>
      ScoreLine((j['h'] as num).toInt(), (j['a'] as num).toInt());
}

/// A statistic the organizer can show in the standings table.
enum StatColumn { played, won, drawn, lost, goalsFor, goalsAgainst, goalDifference, points }

const int kMaxStandingColumns = 8;

/// What the table shows unless the organizer changes it.
const kDefaultStandingColumns = [
  StatColumn.played,
  StatColumn.won,
  StatColumn.drawn,
  StatColumn.lost,
  StatColumn.goalDifference,
  StatColumn.points,
];

extension StatColumnX on StatColumn {
  String get short => switch (this) {
        StatColumn.played => 'Pld',
        StatColumn.won => 'W',
        StatColumn.drawn => 'D',
        StatColumn.lost => 'L',
        StatColumn.goalsFor => 'GF',
        StatColumn.goalsAgainst => 'GA',
        StatColumn.goalDifference => 'GD',
        StatColumn.points => 'Pts',
      };

  String get label => switch (this) {
        StatColumn.played => 'Played',
        StatColumn.won => 'Wins',
        StatColumn.drawn => 'Draws',
        StatColumn.lost => 'Losses',
        StatColumn.goalsFor => 'Goals for',
        StatColumn.goalsAgainst => 'Goals against',
        StatColumn.goalDifference => 'Goal difference',
        StatColumn.points => 'Points',
      };
}

class ArenaRules {
  const ArenaRules({
    this.pointsWin = 3,
    this.pointsDraw = 1,
    this.pointsLoss = 0,
    this.tiebreakers = kTiebreakDirectFirst,
    this.knockoutDraw = KnockoutDraw.penalties,
  });

  final int pointsWin;
  final int pointsDraw;
  final int pointsLoss;

  /// Applied in order after total points.
  final List<Tiebreaker> tiebreakers;

  /// How a level knockout match is settled (chosen at creation).
  final KnockoutDraw knockoutDraw;

  Map<String, dynamic> toJson() => {
        'w': pointsWin,
        'd': pointsDraw,
        'l': pointsLoss,
        'tb': tiebreakers.map((e) => e.name).toList(),
        'ko': knockoutDraw.name,
      };

  factory ArenaRules.fromJson(Map<String, dynamic> j) => ArenaRules(
        pointsWin: (j['w'] as num?)?.toInt() ?? 3,
        pointsDraw: (j['d'] as num?)?.toInt() ?? 1,
        pointsLoss: (j['l'] as num?)?.toInt() ?? 0,
        tiebreakers: ((j['tb'] as List?) ?? const [])
            .map((e) => Tiebreaker.values.byName(e as String))
            .toList(),
        knockoutDraw: KnockoutDraw.values.asNameMap()[j['ko']] ?? KnockoutDraw.penalties,
      );
}

/// One real person inside a team. Ids stay the same when a player is moved
/// to another team.
class ArenaPlayer {
  const ArenaPlayer({required this.id, required this.name});
  final String id;
  final String name;

  ArenaPlayer copyWith({String? name}) => ArenaPlayer(id: id, name: name ?? this.name);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory ArenaPlayer.fromJson(Map<String, dynamic> j) =>
      ArenaPlayer(id: j['id'] as String, name: j['name'] as String);
}

class ArenaParticipant {
  const ArenaParticipant({
    required this.id,
    required this.name,
    this.team = '',
    int players = 1,
    this.roster = const [],
  }) : _players = players;

  final String id;
  final String name;
  final String team;
  final int _players;

  /// Named players of a team (empty for solo participants and for older
  /// tournaments that only stored a head count).
  final List<ArenaPlayer> roster;

  String get display => team.trim().isEmpty ? name : '$name ($team)';

  /// How many real players this participant stands for.
  int get players => roster.isNotEmpty ? roster.length : _players;

  ArenaParticipant copyWith({String? name, String? team, int? players, List<ArenaPlayer>? roster}) =>
      ArenaParticipant(
        id: id,
        name: name ?? this.name,
        team: team ?? this.team,
        players: players ?? _players,
        roster: roster ?? this.roster,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'team': team,
        'n': players,
        'roster': roster.map((e) => e.toJson()).toList(),
      };

  factory ArenaParticipant.fromJson(Map<String, dynamic> j) => ArenaParticipant(
        id: j['id'] as String,
        name: j['name'] as String,
        team: (j['team'] as String?) ?? '',
        players: (j['n'] as num?)?.toInt() ?? 1,
        roster: ((j['roster'] as List?) ?? const [])
            .map((e) => ArenaPlayer.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
      );
}

class ArenaGroup {
  const ArenaGroup({required this.id, required this.name, required this.participantIds});
  final String id;
  final String name;
  final List<String> participantIds;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'p': participantIds};

  factory ArenaGroup.fromJson(Map<String, dynamic> j) => ArenaGroup(
      id: j['id'] as String,
      name: j['name'] as String,
      participantIds: ((j['p'] as List?) ?? const []).cast<String>());
}

class ArenaLeague {
  const ArenaLeague({required this.id, required this.name, required this.groups});
  final String id;
  final String name;
  final List<ArenaGroup> groups;

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'g': groups.map((e) => e.toJson()).toList()};

  factory ArenaLeague.fromJson(Map<String, dynamic> j) => ArenaLeague(
      id: j['id'] as String,
      name: j['name'] as String,
      groups: ((j['g'] as List?) ?? const [])
          .map((e) => ArenaGroup.fromJson((e as Map).cast<String, dynamic>()))
          .toList());
}

class ArenaMatch {
  const ArenaMatch({
    required this.id,
    required this.stage,
    required this.round,
    required this.slot,
    this.leagueId,
    this.groupId,
    this.homeId,
    this.awayId,
    this.homeScore,
    this.awayScore,
    this.status = MatchStatus.scheduled,
    this.bye = false,
    this.label = '',
    this.decidedBy = MatchDecider.regular,
    this.homePens,
    this.awayPens,
    this.replays = const [],
  });

  final String id;
  final MatchStage stage;

  /// Group stage: matchday (1..n). Knockout: 0-based round index.
  final int round;

  /// Position inside the round (knockout slot / fixture index).
  final int slot;
  final String? leagueId;
  final String? groupId;
  final String? homeId;
  final String? awayId;
  final int? homeScore;
  final int? awayScore;
  final MatchStatus status;
  final bool bye;
  final String label;

  /// Knockout only. [homeScore]/[awayScore] are the score at the end of play
  /// (including extra time). Penalties are stored apart so they never count
  /// as goals.
  final MatchDecider decidedBy;
  final int? homePens;
  final int? awayPens;

  /// Knockout "replay" rule: the level scores of earlier attempts, oldest first.
  final List<ScoreLine> replays;

  bool get wentToPenalties => decidedBy == MatchDecider.penalties;

  /// Winner of a confirmed match (null while unconfirmed or level).
  String? get winnerId {
    if (status != MatchStatus.confirmed) return null;
    if (bye) return homeId;
    final h = homeScore, a = awayScore;
    if (h == null || a == null) return null;
    if (h != a) return h > a ? homeId : awayId;
    final hp = homePens, ap = awayPens;
    if (hp != null && ap != null && hp != ap) return hp > ap ? homeId : awayId;
    return null;
  }

  /// e.g. "2-2 (4-3 pens)", "3-2 a.e.t.", "1-0". Empty when no score yet.
  String get scoreText {
    final h = homeScore, a = awayScore;
    if (h == null || a == null) return '';
    return switch (decidedBy) {
      MatchDecider.penalties when homePens != null && awayPens != null =>
        '$h-$a ($homePens-$awayPens pens)',
      MatchDecider.extraTime => '$h-$a a.e.t.',
      _ => '$h-$a',
    };
  }

  bool get isConfirmed => status == MatchStatus.confirmed;
  bool get playable => !bye && homeId != null && awayId != null && status != MatchStatus.cancelled;

  ArenaMatch copyWith({
    Object? homeId = _keep,
    Object? awayId = _keep,
    Object? homeScore = _keep,
    Object? awayScore = _keep,
    MatchStatus? status,
    MatchDecider? decidedBy,
    Object? homePens = _keep,
    Object? awayPens = _keep,
    List<ScoreLine>? replays,
  }) =>
      ArenaMatch(
        id: id,
        stage: stage,
        round: round,
        slot: slot,
        leagueId: leagueId,
        groupId: groupId,
        homeId: identical(homeId, _keep) ? this.homeId : homeId as String?,
        awayId: identical(awayId, _keep) ? this.awayId : awayId as String?,
        homeScore: identical(homeScore, _keep) ? this.homeScore : homeScore as int?,
        awayScore: identical(awayScore, _keep) ? this.awayScore : awayScore as int?,
        status: status ?? this.status,
        bye: bye,
        label: label,
        decidedBy: decidedBy ?? this.decidedBy,
        homePens: identical(homePens, _keep) ? this.homePens : homePens as int?,
        awayPens: identical(awayPens, _keep) ? this.awayPens : awayPens as int?,
        replays: replays ?? this.replays,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'stage': stage.name,
        'round': round,
        'slot': slot,
        'league': leagueId,
        'group': groupId,
        'home': homeId,
        'away': awayId,
        'hs': homeScore,
        'as': awayScore,
        'status': status.name,
        'bye': bye,
        'label': label,
        'by': decidedBy.name,
        'hp': homePens,
        'ap': awayPens,
        'replays': replays.map((e) => e.toJson()).toList(),
      };

  factory ArenaMatch.fromJson(Map<String, dynamic> j) => ArenaMatch(
        id: j['id'] as String,
        stage: MatchStage.values.byName(j['stage'] as String),
        round: (j['round'] as num).toInt(),
        slot: (j['slot'] as num).toInt(),
        leagueId: j['league'] as String?,
        groupId: j['group'] as String?,
        homeId: j['home'] as String?,
        awayId: j['away'] as String?,
        homeScore: (j['hs'] as num?)?.toInt(),
        awayScore: (j['as'] as num?)?.toInt(),
        status: MatchStatus.values.byName(j['status'] as String),
        bye: (j['bye'] as bool?) ?? false,
        label: (j['label'] as String?) ?? '',
        decidedBy: MatchDecider.values.asNameMap()[j['by']] ?? MatchDecider.regular,
        homePens: (j['hp'] as num?)?.toInt(),
        awayPens: (j['ap'] as num?)?.toInt(),
        replays: ((j['replays'] as List?) ?? const [])
            .map((e) => ScoreLine.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
      );
}

// ---------------------------------------------------------------- battle royale

/// One participant's outcome in one Battle Royale round.
class BrResult {
  const BrResult({required this.placement, this.kills = 0});
  final int placement; // 1 = winner
  final int kills;

  Map<String, dynamic> toJson() => {'p': placement, 'k': kills};

  factory BrResult.fromJson(Map<String, dynamic> j) =>
      BrResult(placement: (j['p'] as num).toInt(), kills: (j['k'] as num?)?.toInt() ?? 0);
}

/// Points per placement + per kill.
///
/// Total = placement points + kills x [killPoints] (2 by default). The last
/// three placements always score 0 placement points.
class BrScoring {
  const BrScoring({
    this.killPoints = 2,
    this.placementPoints = const [],
  });

  static const int zeroTail = 3;

  /// Scale for the top places; later places step down to a floor of 1.
  static const _topScale = [12, 9, 8, 7, 6, 5, 4, 3, 2, 1];

  final int killPoints;

  /// Index 0 = 1st place. Has one entry per participant/team.
  final List<int> placementPoints;

  /// A table for [slots] participants: a descending scale, then zeros for the
  /// last [zeroTail] placements.
  static List<int> defaultTable(int slots) => [
        for (var i = 0; i < slots; i++)
          i >= slots - zeroTail ? 0 : (i < _topScale.length ? _topScale[i] : 1),
      ];

  factory BrScoring.forSlots(int slots, {int killPoints = 2}) =>
      BrScoring(killPoints: killPoints, placementPoints: defaultTable(slots));

  int placementPointsFor(int placement) {
    final i = placement - 1;
    return i >= 0 && i < placementPoints.length ? placementPoints[i] : 0;
  }

  int killPointsFor(BrResult r) => r.kills * killPoints;

  int pointsFor(BrResult r) => placementPointsFor(r.placement) + killPointsFor(r);

  /// Problems that must be fixed before the tournament can start.
  List<String> validate(int slots) {
    final errors = <String>[];
    if (killPoints < 0) errors.add('Kill points cannot be negative.');
    if (placementPoints.length != slots) {
      errors.add('The placement table needs exactly $slots rows (one per participant or team); '
          'it has ${placementPoints.length}.');
      return errors;
    }
    if (placementPoints.any((p) => p < 0)) errors.add('Placement points cannot be negative.');
    for (var i = 1; i < placementPoints.length; i++) {
      if (placementPoints[i] > placementPoints[i - 1]) {
        errors.add('A lower placement cannot score more than a higher one (#${i + 1} scores more than #$i).');
        break;
      }
    }
    if (slots > zeroTail && placementPoints.first <= 0) {
      errors.add('1st place must score more than 0.');
    }
    final tail = placementPoints.skip(slots - zeroTail < 0 ? 0 : slots - zeroTail);
    if (tail.any((p) => p != 0)) {
      errors.add('The last $zeroTail placements must score 0 placement points.');
    }
    return errors;
  }

  Map<String, dynamic> toJson() => {'k': killPoints, 'p': placementPoints};

  factory BrScoring.fromJson(Map<String, dynamic> j) => BrScoring(
        killPoints: (j['k'] as num?)?.toInt() ?? 2,
        placementPoints:
            ((j['p'] as List?) ?? const []).map((e) => (e as num).toInt()).toList(),
      );
}

/// One game of a Battle Royale tournament (everyone plays it together).
class BrRound {
  const BrRound({
    required this.id,
    required this.number,
    this.results = const {},
    this.confirmed = false,
  });

  final String id;

  /// 1-based.
  final int number;

  /// participantId -> result.
  final Map<String, BrResult> results;
  final bool confirmed;

  BrRound copyWith({Map<String, BrResult>? results, bool? confirmed}) => BrRound(
        id: id,
        number: number,
        results: results ?? this.results,
        confirmed: confirmed ?? this.confirmed,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'n': number,
        'r': {for (final e in results.entries) e.key: e.value.toJson()},
        'ok': confirmed,
      };

  factory BrRound.fromJson(Map<String, dynamic> j) => BrRound(
        id: j['id'] as String,
        number: (j['n'] as num).toInt(),
        results: {
          for (final e in ((j['r'] as Map?) ?? const {}).entries)
            e.key as String: BrResult.fromJson((e.value as Map).cast<String, dynamic>()),
        },
        confirmed: (j['ok'] as bool?) ?? false,
      );
}

const Object _keep = Object();

class AuditEvent {
  const AuditEvent({required this.at, required this.text});
  final DateTime at;
  final String text;

  Map<String, dynamic> toJson() => {'at': at.toIso8601String(), 'text': text};

  factory AuditEvent.fromJson(Map<String, dynamic> j) =>
      AuditEvent(at: DateTime.parse(j['at'] as String), text: j['text'] as String);
}

class Tournament {
  const Tournament({
    required this.id,
    required this.name,
    required this.game,
    required this.mode,
    required this.structure,
    required this.createdAt,
    this.description = '',
    this.organizer = '',
    this.teamSize = 1,
    this.maxParticipants = 16,
    this.startDate,
    this.registrationDeadline,
    this.leaguesCount = 1,
    this.groupsPerLeague = 1,
    this.qualifiersPerGroup = 2,
    this.doubleRound = false,
    this.randomDraw = true,
    this.rules = const ArenaRules(),
    this.rulesText = '',
    this.roomId = '',
    this.roomPassword = '',
    this.participants = const [],
    this.leagues = const [],
    this.matches = const [],
    this.knockoutGenerated = false,
    this.audit = const [],
    this.brScoring = const BrScoring(),
    this.brRoundsPlanned = 3,
    this.brRounds = const [],
    this.standingsColumns = kDefaultStandingColumns,
  });

  final String id;
  final String name;
  final String description;
  final String game;
  final String mode;
  final String organizer;
  final int teamSize;
  final int maxParticipants;
  final DateTime? startDate;
  final DateTime? registrationDeadline;
  final ArenaStructure structure;
  final int leaguesCount;
  final int groupsPerLeague;
  final int qualifiersPerGroup;
  final bool doubleRound;
  final bool randomDraw;
  final ArenaRules rules;
  final String rulesText;
  final String roomId;
  final String roomPassword;
  final List<ArenaParticipant> participants;
  final List<ArenaLeague> leagues;
  final List<ArenaMatch> matches;
  final bool knockoutGenerated;
  final List<AuditEvent> audit;
  final DateTime createdAt;

  /// Battle Royale only: scoring table, planned number of rounds, and rounds.
  final BrScoring brScoring;
  final int brRoundsPlanned;
  final List<BrRound> brRounds;

  /// Statistics shown in the standings table (at most [kMaxStandingColumns]).
  final List<StatColumn> standingsColumns;

  /// The typed mode behind [mode] (null for unknown/legacy labels).
  ArenaGameMode? get gameMode => ArenaGameMode.find(game, mode);

  ArenaFormat get format => gameMode?.format ?? ArenaFormat.headToHead;

  bool get isBattleRoyale => format == ArenaFormat.battleRoyale;

  List<ArenaMatch> get groupMatches =>
      matches.where((m) => m.stage == MatchStage.group).toList();

  List<ArenaMatch> get knockoutMatches =>
      matches.where((m) => m.stage == MatchStage.knockout).toList();

  bool get hasConfirmedResults =>
      matches.any((m) => m.isConfirmed && !m.bye) || brRounds.any((r) => r.confirmed);

  String participantName(String? id) {
    if (id == null) return 'TBD';
    for (final p in participants) {
      if (p.id == id) return p.display;
    }
    return 'Unknown';
  }

  Tournament copyWith({
    String? name,
    String? description,
    String? organizer,
    String? rulesText,
    String? roomId,
    String? roomPassword,
    List<ArenaParticipant>? participants,
    List<ArenaLeague>? leagues,
    List<ArenaMatch>? matches,
    bool? knockoutGenerated,
    List<AuditEvent>? audit,
    List<BrRound>? brRounds,
  }) =>
      Tournament(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        game: game,
        mode: mode,
        organizer: organizer ?? this.organizer,
        teamSize: teamSize,
        maxParticipants: maxParticipants,
        startDate: startDate,
        registrationDeadline: registrationDeadline,
        structure: structure,
        leaguesCount: leaguesCount,
        groupsPerLeague: groupsPerLeague,
        qualifiersPerGroup: qualifiersPerGroup,
        doubleRound: doubleRound,
        randomDraw: randomDraw,
        rules: rules,
        rulesText: rulesText ?? this.rulesText,
        roomId: roomId ?? this.roomId,
        roomPassword: roomPassword ?? this.roomPassword,
        participants: participants ?? this.participants,
        leagues: leagues ?? this.leagues,
        matches: matches ?? this.matches,
        knockoutGenerated: knockoutGenerated ?? this.knockoutGenerated,
        audit: audit ?? this.audit,
        createdAt: createdAt,
        brScoring: brScoring,
        brRoundsPlanned: brRoundsPlanned,
        brRounds: brRounds ?? this.brRounds,
        standingsColumns: standingsColumns,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'game': game,
        'mode': mode,
        'organizer': organizer,
        'teamSize': teamSize,
        'max': maxParticipants,
        'start': startDate?.toIso8601String(),
        'regDeadline': registrationDeadline?.toIso8601String(),
        'structure': structure.name,
        'leaguesCount': leaguesCount,
        'groupsPerLeague': groupsPerLeague,
        'qualifiers': qualifiersPerGroup,
        'double': doubleRound,
        'random': randomDraw,
        'rules': rules.toJson(),
        'rulesText': rulesText,
        'roomId': roomId,
        'roomPassword': roomPassword,
        'participants': participants.map((e) => e.toJson()).toList(),
        'leagues': leagues.map((e) => e.toJson()).toList(),
        'matches': matches.map((e) => e.toJson()).toList(),
        'koGenerated': knockoutGenerated,
        'audit': audit.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'brScoring': brScoring.toJson(),
        'brPlanned': brRoundsPlanned,
        'brRounds': brRounds.map((e) => e.toJson()).toList(),
        'cols': standingsColumns.map((e) => e.name).toList(),
      };

  factory Tournament.fromJson(Map<String, dynamic> j) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) f) =>
        ((j[key] as List?) ?? const []).map((e) => f((e as Map).cast<String, dynamic>())).toList();

    return Tournament(
      id: j['id'] as String,
      name: j['name'] as String,
      description: (j['description'] as String?) ?? '',
      game: j['game'] as String,
      mode: j['mode'] as String,
      organizer: (j['organizer'] as String?) ?? '',
      teamSize: (j['teamSize'] as num?)?.toInt() ?? 1,
      maxParticipants: (j['max'] as num?)?.toInt() ?? 16,
      startDate: j['start'] == null ? null : DateTime.tryParse(j['start'] as String),
      registrationDeadline:
          j['regDeadline'] == null ? null : DateTime.tryParse(j['regDeadline'] as String),
      structure: ArenaStructure.values.byName(j['structure'] as String),
      leaguesCount: (j['leaguesCount'] as num?)?.toInt() ?? 1,
      groupsPerLeague: (j['groupsPerLeague'] as num?)?.toInt() ?? 1,
      qualifiersPerGroup: (j['qualifiers'] as num?)?.toInt() ?? 2,
      doubleRound: (j['double'] as bool?) ?? false,
      randomDraw: (j['random'] as bool?) ?? true,
      rules: j['rules'] == null
          ? const ArenaRules()
          : ArenaRules.fromJson((j['rules'] as Map).cast<String, dynamic>()),
      rulesText: (j['rulesText'] as String?) ?? '',
      roomId: (j['roomId'] as String?) ?? '',
      roomPassword: (j['roomPassword'] as String?) ?? '',
      participants: list('participants', ArenaParticipant.fromJson),
      leagues: list('leagues', ArenaLeague.fromJson),
      matches: list('matches', ArenaMatch.fromJson),
      knockoutGenerated: (j['koGenerated'] as bool?) ?? false,
      audit: list('audit', AuditEvent.fromJson),
      createdAt: DateTime.tryParse((j['createdAt'] as String?) ?? '') ?? DateTime.now(),
      brScoring: j['brScoring'] == null
          ? const BrScoring()
          : BrScoring.fromJson((j['brScoring'] as Map).cast<String, dynamic>()),
      brRoundsPlanned: (j['brPlanned'] as num?)?.toInt() ?? 3,
      brRounds: list('brRounds', BrRound.fromJson),
      standingsColumns: j['cols'] == null
          ? kDefaultStandingColumns
          : [
              for (final n in (j['cols'] as List))
                if (StatColumn.values.asNameMap()[n] != null) StatColumn.values.byName(n as String)
            ],
    );
  }
}
