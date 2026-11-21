import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'activity_text.dart' show migrateLegacyActivityDetails;

part 'database.g.dart';

/// Status of a Google account's box for one game.
enum BoxStatus { empty, done, notYet, coming }

/// Status of a gaming account. Stored by index: only ever append new values.
/// forSale = listed for sale, no price yet.
enum GameAccountStatus { active, sell, forSale }

/// Google account grades.
enum Grade { bronze, silver, gold, platinum, diamond, interdit }

/// What an activity-log entry is about.
enum ActivityType { googleAccount, gameAccount, game, system }

/// What happened.
enum ActivityAction { created, updated, statusChanged, trashed, restored, deleted }

@DataClassName('Game')
class Games extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get name => text()();
  TextColumn get logoAssetPath => text().nullable()();
  // Optional user-picked photo shown on this game's account cards.
  TextColumn get accountImagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GoogleAccount')
class GoogleAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get email => text()();
  IntColumn get grade => intEnum<Grade>()();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GoogleGameBox')
class GoogleGameBoxes extends Table {
  TextColumn get id => text()();
  TextColumn get googleAccountId => text().references(GoogleAccounts, #id)();
  TextColumn get gameId => text().references(Games, #id)();
  IntColumn get status => intEnum<BoxStatus>().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
        {googleAccountId, gameId},
      ];
}

@DataClassName('GameAccount')
class GameAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get gameId => text().references(Games, #id)();
  TextColumn get idCompte => text()();
  TextColumn get name => text()();
  // Numeric values only; the UI adds the currency label.
  RealColumn get purchasePrice => real()();
  RealColumn get salePrice => real()();
  IntColumn get status => intEnum<GameAccountStatus>()();
  TextColumn get notes => text().nullable()();
  TextColumn get playerPhotoIds => text().withDefault(const Constant('[]'))();
  // Optional photo picked by the user for this one account (overrides the game's photo).
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlayerPhoto')
class PlayerPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get assetPath => text()();
  TextColumn get displayName => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// Activity log (Activity Center). `title` is a snapshot (email / account name)
/// so the entry stays readable after the record is deleted.
@DataClassName('ActivityEntry')
class ActivityLogs extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  IntColumn get type => intEnum<ActivityType>()();
  IntColumn get action => intEnum<ActivityAction>()();
  TextColumn get title => text()();
  TextColumn get detail => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Games, GoogleAccounts, GoogleGameBoxes, GameAccounts, PlayerPhotos, ActivityLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ??
            driftDatabase(
              name: 'sphera',
              // Browser (flutter run -d chrome): SQLite compiled to WebAssembly, stored in the
              // browser. web/sqlite3.wasm and web/drift_worker.js must match the sqlite3 and
              // drift versions in pubspec.lock (sqlite3 2.9.4, drift 2.31.0).
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.addColumn(games, games.accountImagePath);
          if (from < 3) await m.addColumn(gameAccounts, gameAccounts.photoPath);
          if (from < 4) await m.createTable(activityLogs);
          // v5: activity details are stored as codes (see activity_text.dart).
          if (from < 5) await migrateLegacyActivityDetails(this);
        },
        beforeOpen: (details) async => customStatement('PRAGMA foreign_keys = ON'),
      );

  // ---- Live counts (non-deleted records only) ----

  Stream<int> watchGoogleAccountCount() {
    final c = googleAccounts.id.count();
    final q = selectOnly(googleAccounts)
      ..addColumns([c])
      ..where(googleAccounts.deletedAt.isNull());
    return q.map((r) => r.read(c) ?? 0).watchSingle();
  }

  Stream<int> watchGameCount() {
    final c = games.id.count();
    final q = selectOnly(games)
      ..addColumns([c])
      ..where(games.archivedAt.isNull());
    return q.map((r) => r.read(c) ?? 0).watchSingle();
  }

  Stream<int> watchGameAccountCount() {
    final c = gameAccounts.id.count();
    final q = selectOnly(gameAccounts)
      ..addColumns([c])
      ..where(gameAccounts.deletedAt.isNull());
    return q.map((r) => r.read(c) ?? 0).watchSingle();
  }

  /// Sum of (sale - purchase) over non-deleted gaming accounts
  /// (FOR SALE accounts have no price yet, so they are excluded).
  Stream<double> watchTotalProfit() {
    final s = (gameAccounts.salePrice - gameAccounts.purchasePrice).sum();
    final q = selectOnly(gameAccounts)
      ..addColumns([s])
      ..where(gameAccounts.deletedAt.isNull() &
          gameAccounts.status.equalsValue(GameAccountStatus.forSale).not());
    return q.map((r) => r.read(s) ?? 0.0).watchSingle();
  }

  /// Seeds the four initial games once (editable records, not hardcoded UI).
  Future<void> seedInitialGames(String ownerId) async {
    if ((await select(games).get()).isNotEmpty) return;
    final now = DateTime.now();
    const names = ['eFootball', 'Free Fire', 'PUBG', 'Clash of Clans'];
    await batch((b) {
      b.insertAll(games, [
        for (final n in names)
          GamesCompanion.insert(
            id: n.toLowerCase().replaceAll(' ', '_'),
            ownerId: ownerId,
            name: n,
            createdAt: now,
            updatedAt: now,
          ),
      ]);
    });
  }
}
