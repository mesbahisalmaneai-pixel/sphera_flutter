import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/database.dart';
import 'package:sphera_flutter/data/game_account_repository.dart';
import 'package:sphera_flutter/data/game_repository.dart';

void main() {
  late AppDatabase db;
  late GameAccountRepository repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedInitialGames('u1');
    repo = GameAccountRepository(db, 'u1');
  });
  tearDown(() => db.close());

  Future<GameAccount> get(String id) =>
      (db.select(db.gameAccounts)..where((a) => a.id.equals(id))).getSingle();

  test('create stores numeric prices and profit = sale - purchase', () async {
    final id = await repo.create(
        gameId: 'efootball', idCompte: '123', name: 'Ronaldo 01',
        purchasePrice: 150, salePrice: 200, status: GameAccountStatus.sell);
    final a = await get(id);
    expect(a.purchasePrice, 150);
    expect(profitOf(a), 50);
    final loss = await repo.create(
        gameId: 'efootball', idCompte: '2', name: 'B',
        purchasePrice: 300, salePrice: 250, status: GameAccountStatus.active);
    expect(profitOf(await get(loss)), -50);
  });

  test('rejects invalid input', () async {
    expect(() => repo.create(gameId: 'pubg', idCompte: ' ', name: 'x', purchasePrice: 1,
        salePrice: 1, status: GameAccountStatus.active), throwsArgumentError);
    expect(() => repo.create(gameId: 'pubg', idCompte: '1', name: 'x', purchasePrice: -1,
        salePrice: 1, status: GameAccountStatus.active), throwsArgumentError);
  });

  test('update preserves unchanged fields', () async {
    final id = await repo.create(
        gameId: 'pubg', idCompte: '9', name: 'A', purchasePrice: 10, salePrice: 20,
        status: GameAccountStatus.active, notes: 'hello');
    await repo.update(id, salePrice: 35);
    final a = await get(id);
    expect(a.salePrice, 35);
    expect(a.purchasePrice, 10);
    expect(a.name, 'A');
    expect(a.notes, 'hello');
    expect(a.status, GameAccountStatus.active);
  });

  test('counts per game, ACTIVE/SELL, trash excluded, restore preserves data', () async {
    final a = await repo.create(gameId: 'pubg', idCompte: '1', name: 'A', purchasePrice: 10,
        salePrice: 30, status: GameAccountStatus.active);
    await repo.create(gameId: 'pubg', idCompte: '2', name: 'B', purchasePrice: 10,
        salePrice: 20, status: GameAccountStatus.sell);
    await repo.create(gameId: 'free_fire', idCompte: '3', name: 'C', purchasePrice: 5,
        salePrice: 5, status: GameAccountStatus.sell);
    final gr = GameRepository(db, 'u1');
    expect(await gr.countGameAccounts('pubg'), 2);
    expect(await db.watchTotalProfit().first, 20 + 10 + 0);
    await repo.moveToTrash(a);
    expect(await gr.countGameAccounts('pubg'), 1);
    expect(await db.watchTotalProfit().first, 10);
    await repo.restore(a);
    final r = await get(a);
    expect(r.deletedAt, isNull);
    expect(r.gameId, 'pubg');
    expect(r.salePrice, 30);
    expect(await gr.countGameAccounts('pubg'), 2);
  });

  test('permanent delete removes the record', () async {
    final id = await repo.create(gameId: 'pubg', idCompte: '1', name: 'A', purchasePrice: 1,
        salePrice: 2, status: GameAccountStatus.active);
    await repo.moveToTrash(id);
    await repo.deletePermanently(id);
    expect(await db.select(db.gameAccounts).get(), isEmpty);
  });

  test('photo is stored per account, not per game', () async {
    final a = await repo.create(gameId: 'pubg', idCompte: '1', name: 'A', purchasePrice: 1,
        salePrice: 2, status: GameAccountStatus.active);
    final b = await repo.create(gameId: 'pubg', idCompte: '2', name: 'B', purchasePrice: 1,
        salePrice: 2, status: GameAccountStatus.active);
    await repo.setPhoto(a, '/data/game_images/account_a_1.jpg');
    expect((await get(a)).photoPath, '/data/game_images/account_a_1.jpg');
    expect((await get(b)).photoPath, isNull);
    await repo.setPhoto(a, null);
    expect((await get(a)).photoPath, isNull);
  });
}
