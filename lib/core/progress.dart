/// Rank points (function name kept: championshipPoints), ranks and achievements, computed from the existing data.
/// (Local rules, easy to change here without touching any screen.)
library;

import 'l10n.dart';

/// Rank tiers; their names are the grade words.
enum RankName { bronze, silver, gold, platinum, diamond }

class Rank {
  const Rank(this._key, this.min);
  final RankName _key;
  final int min; // minimum points

  /// Rank names are the grade words, in the app language.
  String get name => switch (_key) {
        RankName.bronze => appL10n.gradeBronze,
        RankName.silver => appL10n.gradeSilver,
        RankName.gold => appL10n.gradeGold,
        RankName.platinum => appL10n.gradePlatinum,
        RankName.diamond => appL10n.gradeDiamond,
      };
}

const kRanks = [
  Rank(RankName.bronze, 0),
  Rank(RankName.silver, 100),
  Rank(RankName.gold, 500),
  Rank(RankName.platinum, 1500),
  Rank(RankName.diamond, 4000),
];

/// 10 pts per Google account, 10 pts per game account, 25 pts per game,
/// +1 pt per 100 DH of profit (only when positive).
int championshipPoints({
  required int googleAccounts,
  required int games,
  required int gameAccounts,
  required double profit,
}) =>
    googleAccounts * 10 + gameAccounts * 10 + games * 25 + (profit > 0 ? (profit / 100).floor() : 0);

int rankIndex(int points) {
  var i = 0;
  for (var k = 0; k < kRanks.length; k++) {
    if (points >= kRanks[k].min) i = k;
  }
  return i;
}
