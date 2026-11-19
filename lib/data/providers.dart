import 'package:drift/drift.dart' show BooleanExpressionOperators, OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';
import 'game_account_repository.dart';
import 'game_image_store.dart';
import 'game_repository.dart';
import 'google_repository.dart';
import 'stats.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final googleAccountCountProvider =
    StreamProvider<int>((ref) => ref.watch(databaseProvider).watchGoogleAccountCount());
final gameCountProvider =
    StreamProvider<int>((ref) => ref.watch(databaseProvider).watchGameCount());
final gameAccountCountProvider =
    StreamProvider<int>((ref) => ref.watch(databaseProvider).watchGameAccountCount());
final totalProfitProvider =
    StreamProvider<double>((ref) => ref.watch(databaseProvider).watchTotalProfit());

// ---- Google accounts & games ----
const _ownerId = 'local'; // replaced by the Firebase UID in Stage 5

final googleRepoProvider =
    Provider<GoogleRepository>((ref) => GoogleRepository(ref.watch(databaseProvider), _ownerId));
final gameRepoProvider =
    Provider<GameRepository>((ref) => GameRepository(ref.watch(databaseProvider), _ownerId));

final activeGamesProvider = StreamProvider<List<Game>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.games)
        ..where((g) => g.archivedAt.isNull())
        ..orderBy([(g) => OrderingTerm(expression: g.createdAt)]))
      .watch();
});

final googleAccountsProvider = StreamProvider<List<GoogleAccount>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.googleAccounts)
        ..where((a) => a.deletedAt.isNull())
        ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]))
      .watch();
});

final googleBoxesProvider = StreamProvider<List<GoogleGameBox>>(
    (ref) => ref.watch(databaseProvider).select(ref.watch(databaseProvider).googleGameBoxes).watch());

// ---- Gaming accounts ----
final gameAccountRepoProvider = Provider<GameAccountRepository>(
    (ref) => GameAccountRepository(ref.watch(databaseProvider), _ownerId));

/// Non-deleted accounts of one game, newest first.
final gameAccountsProvider = StreamProvider.family<List<GameAccount>, String>((ref, gameId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.gameAccounts)
        ..where((a) => a.gameId.equals(gameId) & a.deletedAt.isNull())
        ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]))
      .watch();
});

final gameAccountProvider = StreamProvider.family<GameAccount?, String>((ref, id) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.gameAccounts)..where((a) => a.id.equals(id))).watchSingleOrNull();
});

/// gameId -> number of non-deleted gaming accounts.
final gameAccountCountsProvider = StreamProvider<Map<String, int>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.gameAccounts)..where((a) => a.deletedAt.isNull())).watch().map((rows) {
    final m = <String, int>{};
    for (final r in rows) {
      m[r.gameId] = (m[r.gameId] ?? 0) + 1;
    }
    return m;
  });
});

final gameImageStoreProvider = Provider<GameImageStore>((ref) => GameImageStore());

// ---- Statistics & Trash ----
final allGameAccountsProvider = StreamProvider<List<GameAccount>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.gameAccounts)..where((a) => a.deletedAt.isNull())).watch();
});

final googleStatsProvider = Provider<GoogleStats>((ref) => computeGoogleStats(
    ref.watch(googleAccountsProvider).value ?? const [],
    ref.watch(googleBoxesProvider).value ?? const [],
    ref.watch(activeGamesProvider).value ?? const []));

final gameStatsProvider = Provider<List<GameStat>>((ref) => computeGameStats(
    ref.watch(activeGamesProvider).value ?? const [],
    ref.watch(allGameAccountsProvider).value ?? const []));

/// Every game, including archived ones (used to name accounts in the Trash).
final allGamesProvider = StreamProvider<List<Game>>(
    (ref) => ref.watch(databaseProvider).select(ref.watch(databaseProvider).games).watch());

final trashedGoogleAccountsProvider = StreamProvider<List<GoogleAccount>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.googleAccounts)
        ..where((a) => a.deletedAt.isNotNull())
        ..orderBy([(a) => OrderingTerm.desc(a.deletedAt)]))
      .watch();
});

final trashedGameAccountsProvider = StreamProvider<List<GameAccount>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.gameAccounts)
        ..where((a) => a.deletedAt.isNotNull())
        ..orderBy([(a) => OrderingTerm.desc(a.deletedAt)]))
      .watch();
});
