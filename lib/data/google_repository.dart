import 'activity_text.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'activity_log.dart';
import 'database.dart';

class DuplicateEmailException implements Exception {
  DuplicateEmailException(this.email);
  final String email;
  @override
  String toString() => 'A Google account with $email already exists.';
}

String normalizeEmail(String e) => e.trim().toLowerCase();

/// Business logic for Google Play accounts and their per-game status boxes.
class GoogleRepository {
  GoogleRepository(this.db, this.ownerId);
  final AppDatabase db;
  final String ownerId;
  static const _uuid = Uuid();

  Future<GoogleAccount?> _acc(String id) =>
      (db.select(db.googleAccounts)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<void> _log(ActivityAction action, String title, {String? detail}) =>
      logActivity(db, ownerId, ActivityType.googleAccount, action, title, detail: detail);

  Future<void> _assertEmailFree(String email, {String? excludeId}) async {
    final dup = await (db.select(db.googleAccounts)
          ..where((a) =>
              a.email.equals(email) & a.deletedAt.isNull() & a.id.isNotValue(excludeId ?? '')))
        .getSingleOrNull();
    if (dup != null) throw DuplicateEmailException(email);
  }

  Future<void> _upsertBox(String accountId, String gameId, BoxStatus s, DateTime now) async {
    final existing = await (db.select(db.googleGameBoxes)
          ..where((b) => b.googleAccountId.equals(accountId) & b.gameId.equals(gameId)))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.googleGameBoxes).insert(GoogleGameBoxesCompanion.insert(
          id: _uuid.v4(), googleAccountId: accountId, gameId: gameId, updatedAt: now, status: Value(s)));
    } else {
      await (db.update(db.googleGameBoxes)..where((b) => b.id.equals(existing.id)))
          .write(GoogleGameBoxesCompanion(status: Value(s), updatedAt: Value(now)));
    }
  }

  /// Creates the account plus one box per current game (EMPTY unless given).
  Future<String> createAccount({
    required String email,
    required Grade grade,
    Map<String, BoxStatus> statuses = const {},
  }) async {
    final e = normalizeEmail(email);
    final id = _uuid.v4();
    await db.transaction(() async {
      await _assertEmailFree(e);
      final now = DateTime.now();
      await db.into(db.googleAccounts).insert(GoogleAccountsCompanion.insert(
          id: id, ownerId: ownerId, email: e, grade: grade, createdAt: now, updatedAt: now));
      final games = await (db.select(db.games)..where((g) => g.archivedAt.isNull())).get();
      for (final g in games) {
        await _upsertBox(id, g.id, statuses[g.id] ?? BoxStatus.empty, now);
      }
      await _log(ActivityAction.created, e, detail: codeGrade(grade));
    });
    return id;
  }

  /// Updates only what is provided; unchanged fields and boxes are preserved.
  Future<void> updateAccount(
    String id, {
    String? email,
    Grade? grade,
    Map<String, BoxStatus> statuses = const {},
  }) async {
    await db.transaction(() async {
      final now = DateTime.now();
      final e = email == null ? null : normalizeEmail(email);
      if (e != null) await _assertEmailFree(e, excludeId: id);
      await (db.update(db.googleAccounts)..where((a) => a.id.equals(id))).write(
          GoogleAccountsCompanion(
              email: e == null ? const Value.absent() : Value(e),
              grade: grade == null ? const Value.absent() : Value(grade),
              updatedAt: Value(now)));
      for (final entry in statuses.entries) {
        await _upsertBox(id, entry.key, entry.value, now);
      }
      final acc = await _acc(id);
      if (acc != null) {
        final parts = <String>[
          if (grade != null) codeGrade(grade),
          if (statuses.isNotEmpty) codeBoxes(statuses.length),
        ];
        await _log(ActivityAction.updated, acc.email, detail: parts.isEmpty ? null : joinDetail(parts));
      }
    });
  }

  Future<void> setBoxStatus(String accountId, String gameId, BoxStatus s) async {
    await _upsertBox(accountId, gameId, s, DateTime.now());
    final acc = await _acc(accountId);
    if (acc == null) return;
    final game = await (db.select(db.games)..where((g) => g.id.equals(gameId))).getSingleOrNull();
    await _log(ActivityAction.statusChanged, acc.email, detail: joinDetail([game?.name ?? gameId, codeBoxTo(s)]));
  }

  /// Move to Trash (soft delete). Boxes and grade are kept for restoring.
  Future<void> moveToTrash(String id) async {
    final acc = await _acc(id);
    final now = DateTime.now();
    await (db.update(db.googleAccounts)..where((a) => a.id.equals(id)))
        .write(GoogleAccountsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
    if (acc != null) await _log(ActivityAction.trashed, acc.email);
  }

  Future<void> restore(String id) async {
    final acc = await (db.select(db.googleAccounts)..where((a) => a.id.equals(id))).getSingle();
    await _assertEmailFree(acc.email, excludeId: id);
    await (db.update(db.googleAccounts)..where((a) => a.id.equals(id))).write(
        GoogleAccountsCompanion(deletedAt: const Value(null), updatedAt: Value(DateTime.now())));
    await _log(ActivityAction.restored, acc.email);
  }

  Future<void> deletePermanently(String id) async {
    final acc = await _acc(id);
    await db.transaction(() async {
      await (db.delete(db.googleGameBoxes)..where((b) => b.googleAccountId.equals(id))).go();
      await (db.delete(db.googleAccounts)..where((a) => a.id.equals(id))).go();
    });
    if (acc != null) await _log(ActivityAction.deleted, acc.email);
  }
}
