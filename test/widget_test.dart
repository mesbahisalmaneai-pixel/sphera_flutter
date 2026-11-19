import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/database.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('seeds the four initial games once', () async {
    await db.seedInitialGames('u1');
    await db.seedInitialGames('u1');
    expect((await db.select(db.games).get()).length, 4);
  });

  test('profit = sale - purchase, trashed accounts excluded', () async {
    await db.seedInitialGames('u1');
    final now = DateTime.now();
    GameAccountsCompanion acc(String id, double p, double s, {DateTime? del}) =>
        GameAccountsCompanion.insert(
          id: id, ownerId: 'u1', gameId: 'efootball', idCompte: id, name: id,
          purchasePrice: p, salePrice: s, status: GameAccountStatus.sell,
          createdAt: now, updatedAt: now, deletedAt: Value(del),
        );
    await db.into(db.gameAccounts).insert(acc('a', 150, 200));
    await db.into(db.gameAccounts).insert(acc('b', 300, 250));
    await db.into(db.gameAccounts).insert(acc('c', 10, 999, del: now));
    expect(await db.watchTotalProfit().first, 0.0); // +50 and -50
    expect(await db.watchGameAccountCount().first, 2);
  });
}
