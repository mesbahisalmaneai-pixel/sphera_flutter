import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';
import 'providers.dart';

/// Latest 1000 activity entries, newest first.
final activityLogProvider = StreamProvider<List<ActivityEntry>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.activityLogs)
        ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
        ..limit(1000))
      .watch();
});
