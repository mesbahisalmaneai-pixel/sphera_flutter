import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/database.dart';
import 'package:sphera_flutter/data/game_repository.dart';
import 'package:sphera_flutter/data/google_repository.dart';

void main() {
  late AppDatabase db;
  late GoogleRepository google;
  late GameRepository games;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedInitialGames('u1');
    google = GoogleRepository(db, 'u1');
    games = GameRepository(db, 'u1');
  });
  tearDown(() => db.close());

  Future<Map<String, BoxStatus>> boxesOf(String accountId) async {
    final rows = await (db.select(db.googleGameBoxes)
          ..where((b) => b.googleAccountId.equals(accountId)))
        .get();
    return {for (final r in rows) r.gameId: r.status};
  }

  test('creating an account creates one box per game, EMPTY by default', () async {
    final id = await google.createAccount(email: ' A@Mail.com ', grade: Grade.gold);
    final acc = await (db.select(db.googleAccounts)..where((a) => a.id.equals(id))).getSingle();
    expect(acc.email, 'a@mail.com');
    expect(acc.grade, Grade.gold);
    final boxes = await boxesOf(id);
    expect(boxes.length, 4);
    expect(boxes.values.every((s) => s == BoxStatus.empty), isTrue);
  });

  test('changing one box does not change the others (or other accounts)', () async {
    final a = await google.createAccount(email: 'a@x.com', grade: Grade.bronze);
    final b = await google.createAccount(email: 'b@x.com', grade: Grade.bronze);
    await google.setBoxStatus(a, 'efootball', BoxStatus.done);
    final ba = await boxesOf(a);
    expect(ba['efootball'], BoxStatus.done);
    expect(ba['free_fire'], BoxStatus.empty);
    expect((await boxesOf(b))['efootball'], BoxStatus.empty);
  });

  test('editing preserves unchanged fields and statuses', () async {
    final id = await google.createAccount(
        email: 'a@x.com', grade: Grade.silver, statuses: {'pubg': BoxStatus.coming});
    await google.updateAccount(id, grade: Grade.diamond);
    final acc = await (db.select(db.googleAccounts)..where((a) => a.id.equals(id))).getSingle();
    expect(acc.email, 'a@x.com');
    expect(acc.grade, Grade.diamond);
    expect((await boxesOf(id))['pubg'], BoxStatus.coming);
  });

  test('duplicate email is rejected', () async {
    await google.createAccount(email: 'a@x.com', grade: Grade.bronze);
    expect(() => google.createAccount(email: 'A@X.com', grade: Grade.gold),
        throwsA(isA<DuplicateEmailException>()));
  });

  test('new game gets EMPTY boxes for existing accounts; duplicate name rejected', () async {
    final id = await google.createAccount(email: 'a@x.com', grade: Grade.bronze);
    final gid = await games.addGame('Valorant');
    expect((await boxesOf(id))[gid], BoxStatus.empty);
    expect(() => games.addGame('valorant'), throwsA(isA<DuplicateGameException>()));
  });

  test('renaming a game keeps its id and the box statuses', () async {
    final id = await google.createAccount(
        email: 'a@x.com', grade: Grade.bronze, statuses: {'pubg': BoxStatus.done});
    await games.renameGame('pubg', 'PUBG Mobile');
    final g = await (db.select(db.games)..where((x) => x.id.equals('pubg'))).getSingle();
    expect(g.name, 'PUBG Mobile');
    expect((await boxesOf(id))['pubg'], BoxStatus.done);
  });

  test('trash excludes from counts; restore keeps grade and boxes', () async {
    final id = await google.createAccount(
        email: 'a@x.com', grade: Grade.platinum, statuses: {'efootball': BoxStatus.notYet});
    expect(await db.watchGoogleAccountCount().first, 1);
    await google.moveToTrash(id);
    expect(await db.watchGoogleAccountCount().first, 0);
    await google.restore(id);
    expect(await db.watchGoogleAccountCount().first, 1);
    final acc = await (db.select(db.googleAccounts)..where((a) => a.id.equals(id))).getSingle();
    expect(acc.grade, Grade.platinum);
    expect((await boxesOf(id))['efootball'], BoxStatus.notYet);
  });

  test('permanent delete removes the account and its boxes', () async {
    final id = await google.createAccount(email: 'a@x.com', grade: Grade.bronze);
    await google.moveToTrash(id);
    await google.deletePermanently(id);
    expect(await db.select(db.googleAccounts).get(), isEmpty);
    expect(await db.select(db.googleGameBoxes).get(), isEmpty);
  });

  test('archiving a game hides it but keeps gaming accounts and box statuses', () async {
    final id = await google.createAccount(
        email: 'a@x.com', grade: Grade.bronze, statuses: {'pubg': BoxStatus.done});
    final now = DateTime.now();
    await db.into(db.gameAccounts).insert(GameAccountsCompanion.insert(
        id: 'g1', ownerId: 'u1', gameId: 'pubg', idCompte: '1', name: 'X',
        purchasePrice: 1, salePrice: 2, status: GameAccountStatus.active,
        createdAt: now, updatedAt: now));
    expect(await games.countGameAccounts('pubg'), 1);
    await games.archiveGame('pubg');
    expect(await db.watchGameCount().first, 3);
    expect(await games.countGameAccounts('pubg'), 1);
    expect((await boxesOf(id))['pubg'], BoxStatus.done);
  });
}
