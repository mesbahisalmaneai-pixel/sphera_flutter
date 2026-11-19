import 'database.dart';
import 'game_account_repository.dart' show profitOf;

class GoogleStats {
  const GoogleStats({required this.total, required this.byGrade, required this.byStatus});
  final int total;
  final Map<Grade, int> byGrade;
  final Map<BoxStatus, int> byStatus;
}

/// Counts non-deleted Google accounts per grade, and game boxes per status.
/// Boxes only count if their account is non-deleted and their game is not archived.
/// (A box is never a gaming account.)
GoogleStats computeGoogleStats(
    List<GoogleAccount> accounts, List<GoogleGameBox> boxes, List<Game> activeGames) {
  final live = accounts.where((a) => a.deletedAt == null).toList();
  final ids = {for (final a in live) a.id};
  final gameIds = {for (final g in activeGames.where((g) => g.archivedAt == null)) g.id};
  final byGrade = {for (final g in Grade.values) g: 0};
  for (final a in live) {
    byGrade[a.grade] = byGrade[a.grade]! + 1;
  }
  final byStatus = {for (final s in BoxStatus.values) s: 0};
  for (final b in boxes) {
    if (ids.contains(b.googleAccountId) && gameIds.contains(b.gameId)) {
      byStatus[b.status] = byStatus[b.status]! + 1;
    }
  }
  return GoogleStats(total: live.length, byGrade: byGrade, byStatus: byStatus);
}

class GameStat {
  const GameStat(
      {required this.game, required this.count, required this.profit, required this.active, required this.sell});
  final Game game;
  final int count;
  final double profit; // sum of (sale - purchase)
  final int active;
  final int sell;
}

/// Per-game statistics over non-deleted gaming accounts only.
List<GameStat> computeGameStats(List<Game> games, List<GameAccount> accounts) {
  final live = accounts.where((a) => a.deletedAt == null);
  return [
    for (final g in games.where((g) => g.archivedAt == null))
      () {
        final mine = live.where((a) => a.gameId == g.id).toList();
        return GameStat(
          game: g,
          count: mine.length,
          profit: mine.fold<double>(0, (sum, a) => sum + profitOf(a)),
          active: mine.where((a) => a.status == GameAccountStatus.active).length,
          sell: mine.where((a) => a.status == GameAccountStatus.sell).length,
        );
      }(),
  ];
}
