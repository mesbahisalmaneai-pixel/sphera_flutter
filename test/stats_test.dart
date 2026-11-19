import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/database.dart';
import 'package:sphera_flutter/data/game_account_repository.dart';
import 'package:sphera_flutter/data/game_repository.dart';
import 'package:sphera_flutter/data/google_repository.dart';
import 'package:sphera_flutter/data/stats.dart';

void main() {
  late AppDatabase db;
  late GoogleRepository google;
  late GameAccountRepository accounts;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedInitialGames('u1');
    google = GoogleRepository(db, 'u1');
    accounts = GameAccountRepository(db, 'u1');
  });
  tearDown(() => db.close());

  Future<GoogleStats> googleStats() async => computeGoogleStats(
      await db.select(db.googleAccounts).get(),
      await db.select(db.googleGameBoxes).get(),
      await db.select(db.games).get());

  test('grade and box-status counts exclude trashed accounts', () async {
    final a = await google.createAccount(
        email: 'a@x.com', grade: Grade.gold, statuses: {'pubg': BoxStatus.done});
    await google.createAccount(email: 'b@x.com', grade: Grade.gold);
    await google.createAccount(email: 'c@x.com', grade: Grade.diamond);
    var st = await googleStats();
    expect(st.total, 3);
    expect(st.byGrade[Grade.gold], 2);
    expect(st.byGrade[Grade.diamond], 1);
    expect(st.byGrade[Grade.bronze], 0);
    expect(st.byStatus[BoxStatus.done], 1);
    expect(st.byStatus[BoxStatus.empty], 11); // 3 accounts x 4 games - 1 done
    await google.moveToTrash(a);
    st = await googleStats();
    expect(st.total, 2);
    expect(st.byStatus[BoxStatus.done], 0);
    expect(st.byStatus[BoxStatus.empty], 8);
  });

  test('archived games are excluded from box-status counts', () async {
    await google.createAccount(email: 'a@x.com', grade: Grade.bronze);
    await GameRepository(db, 'u1').archiveGame('pubg');
    final st = await googleStats();
    expect(st.byStatus.values.fold<int>(0, (a, b) => a + b), 3);
  });

  test('game stats: profit, counts and ACTIVE/SELL per game', () async {
    await accounts.create(gameId: 'efootball', idCompte: '1', name: 'A', purchasePrice: 150,
        salePrice: 200, status: GameAccountStatus.sell);
    await accounts.create(gameId: 'efootball', idCompte: '2', name: 'B', purchasePrice: 300,
        salePrice: 250, status: GameAccountStatus.active);
    final trashed = await accounts.create(gameId: 'efootball', idCompte: '3', name: 'C',
        purchasePrice: 1, salePrice: 999, status: GameAccountStatus.sell);
    await accounts.moveToTrash(trashed);
    await accounts.create(gameId: 'pubg', idCompte: '4', name: 'D', purchasePrice: 10,
        salePrice: 40, status: GameAccountStatus.active);

    final stats = computeGameStats(
        await db.select(db.games).get(), await db.select(db.gameAccounts).get());
    final ef = stats.firstWhere((s) => s.game.id == 'efootball');
    expect(ef.count, 2);
    expect(ef.profit, 0); // +50 and -50, trashed ignored
    expect(ef.active, 1);
    expect(ef.sell, 1);
    final pubg = stats.firstWhere((s) => s.game.id == 'pubg');
    expect(pubg.profit, 30);
    expect(stats.firstWhere((s) => s.game.id == 'free_fire').count, 0);
  });
}
