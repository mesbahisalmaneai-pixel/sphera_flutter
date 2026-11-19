/// Rank points (function name kept: championshipPoints), ranks and achievements, computed from the existing data.
/// (Local rules, easy to change here without touching any screen.)
library;

class Rank {
  const Rank(this.name, this.min);
  final String name;
  final int min; // minimum points
}

const kRanks = [
  Rank('Bronze', 0),
  Rank('Silver', 100),
  Rank('Gold', 500),
  Rank('Platinum', 1500),
  Rank('Diamond', 4000),
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
