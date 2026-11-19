import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/database.dart';
import 'package:sphera_flutter/data/game_repository.dart';

void main() {
  late AppDatabase db;
  late GameRepository games;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedInitialGames('u1');
    games = GameRepository(db, 'u1');
  });
  tearDown(() => db.close());

  Future<Game> game(String id) =>
      (db.select(db.games)..where((g) => g.id.equals(id))).getSingle();

  test('set and reset card image and account photo independently', () async {
    await games.setCardImage('pubg', '/data/game_images/pubg_card_1.jpg');
    var g = await game('pubg');
    expect(g.logoAssetPath, '/data/game_images/pubg_card_1.jpg');
    expect(g.accountImagePath, isNull);

    await games.setAccountImage('pubg', '/data/game_images/pubg_account_1.jpg');
    g = await game('pubg');
    expect(g.accountImagePath, '/data/game_images/pubg_account_1.jpg');
    expect(g.logoAssetPath, '/data/game_images/pubg_card_1.jpg');

    await games.setCardImage('pubg', null);
    await games.setAccountImage('pubg', null);
    g = await game('pubg');
    expect(g.logoAssetPath, isNull);
    expect(g.accountImagePath, isNull);
  });

  test('renaming a game keeps its custom images', () async {
    await games.setCardImage('pubg', '/data/game_images/x.jpg');
    await games.renameGame('pubg', 'PUBG Mobile');
    expect((await game('pubg')).logoAssetPath, '/data/game_images/x.jpg');
  });
}
