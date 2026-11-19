import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'database.dart';

class DuplicateGameException implements Exception {
  DuplicateGameException(this.name);
  final String name;
  @override
  String toString() => 'A game named "$name" already exists.';
}

class GameRepository {
  GameRepository(this.db, this.ownerId);
  final AppDatabase db;
  final String ownerId;
  static const _uuid = Uuid();

  Future<void> _assertNameFree(String name, {String? excludeId}) async {
    final dup = await (db.select(db.games)
          ..where((g) =>
              g.name.lower().equals(name.toLowerCase()) &
              g.archivedAt.isNull() &
              g.id.isNotValue(excludeId ?? '')))
        .getSingleOrNull();
    if (dup != null) throw DuplicateGameException(name);
  }

  /// Adds a game and creates an EMPTY box for every existing Google account
  /// (including trashed ones, so restoring them stays consistent).
  Future<String> addGame(String name, {String? logoAssetPath}) async {
    final n = name.trim();
    if (n.isEmpty) throw ArgumentError('Game name is required');
    final id = _uuid.v4();
    await db.transaction(() async {
      await _assertNameFree(n);
      final now = DateTime.now();
      await db.into(db.games).insert(GamesCompanion.insert(
          id: id, ownerId: ownerId, name: n, logoAssetPath: Value(logoAssetPath),
          createdAt: now, updatedAt: now));
      final accounts = await db.select(db.googleAccounts).get();
      for (final a in accounts) {
        await db.into(db.googleGameBoxes).insert(GoogleGameBoxesCompanion.insert(
            id: _uuid.v4(), googleAccountId: a.id, gameId: id, updatedAt: now));
      }
    });
    return id;
  }

  /// Rename keeps the game id, so accounts and box statuses stay linked.
  Future<void> renameGame(String id, String name) async {
    final n = name.trim();
    if (n.isEmpty) throw ArgumentError('Game name is required');
    await db.transaction(() async {
      await _assertNameFree(n, excludeId: id);
      await (db.update(db.games)..where((g) => g.id.equals(id)))
          .write(GamesCompanion(name: Value(n), updatedAt: Value(DateTime.now())));
    });
  }

  /// Number of non-deleted gaming accounts that belong to this game.
  Future<int> countGameAccounts(String gameId) async {
    final c = db.gameAccounts.id.count();
    final q = db.selectOnly(db.gameAccounts)
      ..addColumns([c])
      ..where(db.gameAccounts.gameId.equals(gameId) & db.gameAccounts.deletedAt.isNull());
    return (await q.map((r) => r.read(c) ?? 0).getSingle());
  }

  /// "Deleting" a game archives it: it disappears from lists and statistics,
  /// but its gaming accounts and Google box statuses are kept (never silently destroyed).
  Future<void> archiveGame(String id) async {
    final now = DateTime.now();
    await (db.update(db.games)..where((g) => g.id.equals(id)))
        .write(GamesCompanion(archivedAt: Value(now), updatedAt: Value(now)));
  }

  /// Sets (or clears with null) the user-picked image for the game card.
  Future<void> setCardImage(String id, String? path) =>
      (db.update(db.games)..where((g) => g.id.equals(id))).write(
          GamesCompanion(logoAssetPath: Value(path), updatedAt: Value(DateTime.now())));

  /// Sets (or clears with null) the user-picked photo for the account cards.
  Future<void> setAccountImage(String id, String? path) =>
      (db.update(db.games)..where((g) => g.id.equals(id))).write(
          GamesCompanion(accountImagePath: Value(path), updatedAt: Value(DateTime.now())));
}
