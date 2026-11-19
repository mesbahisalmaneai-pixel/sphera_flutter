import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'database.dart';

const _uuid = Uuid();

/// Writes one entry in the activity log. Never throws into the caller's flow
/// more than the DB itself would.
Future<void> logActivity(
  AppDatabase db,
  String ownerId,
  ActivityType type,
  ActivityAction action,
  String title, {
  String? detail,
}) =>
    db.into(db.activityLogs).insert(ActivityLogsCompanion.insert(
          id: _uuid.v4(),
          ownerId: ownerId,
          type: type,
          action: action,
          title: title,
          createdAt: DateTime.now(),
          detail: Value(detail),
        ));
