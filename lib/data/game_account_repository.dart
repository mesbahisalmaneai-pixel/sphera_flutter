import 'activity_text.dart';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'activity_log.dart';
import 'database.dart';

/// Profit/loss of one gaming account = sale price - purchase price.
/// FOR SALE accounts have no price yet, so they count 0.
double profitOf(GameAccount a) =>
    a.status == GameAccountStatus.forSale ? 0 : a.salePrice - a.purchasePrice;

class GameAccountRepository {
  GameAccountRepository(this.db, this.ownerId);
  final AppDatabase db;
  final String ownerId;
  static const _uuid = Uuid();

  Future<GameAccount?> _row(String id) =>
      (db.select(db.gameAccounts)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<String> _gameName(String gameId) async {
    final g = await (db.select(db.games)..where((x) => x.id.equals(gameId))).getSingleOrNull();
    return g?.name ?? gameId;
  }

  Future<void> _log(ActivityAction action, String title, {String? detail}) =>
      logActivity(db, ownerId, ActivityType.gameAccount, action, title, detail: detail);

  void _validate(String? idCompte, String? name, double? purchase, double? sale) {
    if (idCompte != null && idCompte.trim().isEmpty) throw ArgumentError('ID compte is required');
    if (name != null && name.trim().isEmpty) throw ArgumentError('Account name is required');
    if (purchase != null && (purchase.isNaN || purchase < 0)) throw ArgumentError('Invalid purchase price');
    if (sale != null && (sale.isNaN || sale < 0)) throw ArgumentError('Invalid sale price');
  }

  Future<String> create({
    required String gameId,
    required String idCompte,
    required String name,
    required double purchasePrice,
    required double salePrice,
    required GameAccountStatus status,
    String? notes,
  }) async {
    _validate(idCompte, name, purchasePrice, salePrice);
    final id = _uuid.v4();
    final now = DateTime.now();
    await db.into(db.gameAccounts).insert(GameAccountsCompanion.insert(
        id: id, ownerId: ownerId, gameId: gameId, idCompte: idCompte.trim(), name: name.trim(),
        purchasePrice: purchasePrice, salePrice: salePrice, status: status,
        notes: Value(notes == null || notes.trim().isEmpty ? null : notes.trim()),
        createdAt: now, updatedAt: now));
    await _log(ActivityAction.created, name.trim(),
        detail: joinDetail([await _gameName(gameId), codeStatus(status)]));
    return id;
  }

  /// Updates only the provided fields; everything else is preserved.
  Future<void> update(
    String id, {
    String? gameId,
    String? idCompte,
    String? name,
    double? purchasePrice,
    double? salePrice,
    GameAccountStatus? status,
    String? notes,
  }) async {
    _validate(idCompte, name, purchasePrice, salePrice);
    final old = await _row(id);
    await (db.update(db.gameAccounts)..where((a) => a.id.equals(id))).write(GameAccountsCompanion(
      gameId: gameId == null ? const Value.absent() : Value(gameId),
      idCompte: idCompte == null ? const Value.absent() : Value(idCompte.trim()),
      name: name == null ? const Value.absent() : Value(name.trim()),
      purchasePrice: purchasePrice == null ? const Value.absent() : Value(purchasePrice),
      salePrice: salePrice == null ? const Value.absent() : Value(salePrice),
      status: status == null ? const Value.absent() : Value(status),
      notes: notes == null ? const Value.absent() : Value(notes.trim().isEmpty ? null : notes.trim()),
      updatedAt: Value(DateTime.now()),
    ));
    final now = await _row(id);
    if (now == null) return;
    if (old != null && old.status != now.status) {
      await _log(ActivityAction.statusChanged, now.name,
          detail: codeStatusChange(old.status, now.status));
    } else {
      await _log(ActivityAction.updated, now.name, detail: await _gameName(now.gameId));
    }
  }

  Future<void> moveToTrash(String id) async {
    final row = await _row(id);
    final now = DateTime.now();
    await (db.update(db.gameAccounts)..where((a) => a.id.equals(id)))
        .write(GameAccountsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
    if (row != null) await _log(ActivityAction.trashed, row.name, detail: await _gameName(row.gameId));
  }

  Future<void> restore(String id) async {
    await (db.update(db.gameAccounts)..where((a) => a.id.equals(id))).write(
        GameAccountsCompanion(deletedAt: const Value(null), updatedAt: Value(DateTime.now())));
    final row = await _row(id);
    if (row != null) await _log(ActivityAction.restored, row.name, detail: await _gameName(row.gameId));
  }

  /// Sets (or clears with null) the photo of this single account.
  Future<void> setPhoto(String id, String? path) =>
      (db.update(db.gameAccounts)..where((a) => a.id.equals(id))).write(
          GameAccountsCompanion(photoPath: Value(path), updatedAt: Value(DateTime.now())));

  Future<void> deletePermanently(String id) async {
    final row = await _row(id);
    final gameName = row == null ? null : await _gameName(row.gameId);
    await (db.delete(db.gameAccounts)..where((a) => a.id.equals(id))).go();
    if (row != null) await _log(ActivityAction.deleted, row.name, detail: gameName);
    // Remove the account's own picked photo from the app storage (never bundled assets).
    final path = row?.photoPath;
    if (path != null && !path.startsWith('assets/') && path.contains('game_images')) {
      final f = File(path);
      if (await f.exists()) await f.delete();
    }
  }
}
