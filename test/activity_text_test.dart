import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/core/l10n.dart';
import 'package:sphera_flutter/data/activity_log.dart';
import 'package:sphera_flutter/data/activity_text.dart';
import 'package:sphera_flutter/data/database.dart';
import 'package:sphera_flutter/data/game_account_repository.dart';
import 'package:sphera_flutter/data/google_repository.dart';

/// Activity log details: stored as codes, shown in the app language, and old
/// English entries converted safely.
void main() {
  final en = l10nFor('en'), fr = l10nFor('fr'), ar = l10nFor('ar');

  group('legacy English details', () {
    test('every format older versions wrote is converted', () {
      expect(legacyDetailToCodes('Grade diamond'), '§grade=diamond');
      expect(legacyDetailToCodes('Grade gold · 3 boxes'), '§grade=gold · §boxes=3');
      expect(legacyDetailToCodes('1 box'), '§boxes=1');
      expect(legacyDetailToCodes('eFootball → coming'), 'eFootball · §boxTo=coming');
      expect(legacyDetailToCodes('Free Fire · For sale'), 'Free Fire · §status=forSale');
      expect(legacyDetailToCodes('Active → Sold'), '§statusChange=active>sell');
    });

    test('anything else is left untouched', () {
      expect(legacyDetailToCodes('eFootball'), isNull); // a game name
      expect(legacyDetailToCodes('Grade unknown'), isNull);
      expect(legacyDetailToCodes('Sold'), isNull); // a status alone could be a game name
      expect(legacyDetailToCodes('§grade=gold'), isNull); // already converted
    });
  });

  group('shown in the app language', () {
    test('codes become words', () {
      expect(describeActivityDetail('§grade=diamond', en), 'Grade Diamond');
      expect(describeActivityDetail('§grade=diamond', fr), 'Grade Diamant');
      expect(describeActivityDetail('§grade=diamond', ar), 'الدرجة ماسي');
      expect(describeActivityDetail('§statusChange=active>sell', fr), 'ACTIF → VENDU');
      expect(describeActivityDetail('eFootball · §boxTo=coming', en), 'eFootball → COMING');
      expect(describeActivityDetail('§grade=gold · §boxes=3', en), 'Grade Gold · 3 boxes');
    });

    test('unknown codes and old text are shown as stored', () {
      expect(describeActivityDetail('§what=ever', en), '§what=ever');
      expect(describeActivityDetail('Some old note', fr), 'Some old note');
      expect(describeActivityDetail(null, en), isNull);
    });
  });

  group('database', () {
    late AppDatabase db;
    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      await db.seedInitialGames('u1');
    });
    tearDown(() => db.close());

    Future<List<String?>> details() async =>
        [for (final r in await db.select(db.activityLogs).get()) r.detail];

    test('new entries are stored as codes', () async {
      await GoogleRepository(db, 'u1').createAccount(email: 'a@gmail.com', grade: Grade.gold);
      final repo = GameAccountRepository(db, 'u1');
      final id = await repo.create(
          gameId: 'efootball', idCompte: '1', name: 'A', purchasePrice: 1, salePrice: 2, status: GameAccountStatus.active);
      await repo.update(id, status: GameAccountStatus.sell);
      final all = await details();
      expect(all, contains('§grade=gold'));
      expect(all, contains('eFootball · §status=active'));
      expect(all, contains('§statusChange=active>sell'));
    });

    test('the upgrade converts old entries once and keeps the rest', () async {
      await logActivity(db, 'u1', ActivityType.googleAccount, ActivityAction.created, 'a@gmail.com',
          detail: 'Grade diamond');
      await logActivity(db, 'u1', ActivityType.gameAccount, ActivityAction.updated, 'A', detail: 'eFootball');
      await logActivity(db, 'u1', ActivityType.gameAccount, ActivityAction.statusChanged, 'A',
          detail: 'Active → Sold');
      await logActivity(db, 'u1', ActivityType.gameAccount, ActivityAction.trashed, 'A');

      expect(await migrateLegacyActivityDetails(db), 2);
      expect(await details(), containsAll(<String?>['§grade=diamond', 'eFootball', '§statusChange=active>sell', null]));
      expect((await db.select(db.activityLogs).get()).length, 4); // nothing deleted
      expect(await migrateLegacyActivityDetails(db), 0); // safe to run again
    });
  });

  test('opening a version 4 database upgrades its activity log', () async {
    final dir = await Directory.systemTemp.createTemp('sphera_upgrade');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/sphera.sqlite');

    // An app from before the change: database version 4, English details.
    final old = _V4Database(NativeDatabase(file));
    await logActivity(old, 'u1', ActivityType.googleAccount, ActivityAction.created, 'a@gmail.com',
        detail: 'Grade diamond');
    await old.close();

    // The new app opens the same file: the v5 upgrade runs once.
    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);
    final rows = await db.select(db.activityLogs).get();
    expect(rows.single.detail, '§grade=diamond');
    expect(rows.single.title, 'a@gmail.com');
  });
}

class _V4Database extends AppDatabase {
  _V4Database(super.e);
  @override
  int get schemaVersion => 4;
}
