import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/activity_text.dart';
import '../../data/activity_providers.dart';
import '../../data/database.dart';

/// Activity Center: the activity log, filtered by date range and type.
class ActivityCenterScreen extends ConsumerStatefulWidget {
  const ActivityCenterScreen({super.key});

  @override
  ConsumerState<ActivityCenterScreen> createState() => _ActivityCenterScreenState();
}

class _ActivityCenterScreenState extends ConsumerState<ActivityCenterScreen> {
  String _range = 'all'; // today | 7 | 30 | all
  ActivityType? _type; // null = all types

  static String _two(int n) => n.toString().padLeft(2, '0');

  String _dayLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return appL10n.todayCap;
    if (diff == 1) return appL10n.yesterday;
    return '${_two(d.day)}/${_two(d.month)}/${d.year}';
  }

  String _typeLabel(ActivityType t) => switch (t) {
        ActivityType.googleAccount => appL10n.typeGoogle,
        ActivityType.gameAccount => appL10n.typeGaming,
        ActivityType.game => appL10n.typeGames,
        ActivityType.system => appL10n.typeSystem,
      };

  (IconData, Color, String) _meta(ActivityAction a) => switch (a) {
        ActivityAction.created => (Icons.add_circle_outline, SpheraColors.done, appL10n.actionAdded),
        ActivityAction.updated => (Icons.edit_outlined, SpheraColors.gold, appL10n.actionUpdated),
        ActivityAction.statusChanged => (Icons.swap_horiz_rounded, SpheraColors.coming, appL10n.actionStatusChanged),
        ActivityAction.trashed => (Icons.delete_outline, SpheraColors.danger, appL10n.actionMovedToTrash),
        ActivityAction.restored => (Icons.restore_rounded, SpheraColors.done, appL10n.actionRestored),
        ActivityAction.deleted => (Icons.delete_forever_outlined, SpheraColors.danger, appL10n.actionDeleted),
      };

  bool _inRange(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return switch (_range) {
      'today' => !d.isBefore(today),
      '7' => !d.isBefore(today.subtract(const Duration(days: 6))),
      '30' => !d.isBefore(today.subtract(const Duration(days: 29))),
      _ => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    final entries = (ref.watch(activityLogProvider).value ?? <ActivityEntry>[])
        .where((e) => _inRange(e.createdAt) && (_type == null || e.type == _type))
        .toList();

    final children = <Widget>[];
    String? lastDay;
    for (final e in entries) {
      final day = _dayLabel(e.createdAt);
      if (day != lastDay) {
        lastDay = day;
        children.add(Padding(
          padding: EdgeInsets.fromLTRB(4, 16, 0, 8),
          child: Text(day,
              style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 14)),
        ));
      }
      final (icon, color, label) = _meta(e.action);
      children.add(Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(e.title, overflow: TextOverflow.ellipsis),
          subtitle: Text(e.detail == null ? label : '$label · ${describeActivityDetail(e.detail, context.l10n)}',
              style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${_two(e.createdAt.hour)}:${_two(e.createdAt.minute)}',
                style: TextStyle(fontSize: 12)),
            SizedBox(height: 2),
            Text(_typeLabel(e.type), style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
          ]),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.activityCenter)),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'today', label: Text(context.l10n.todayCap)),
              ButtonSegment(value: '7', label: Text(context.l10n.last7Days)),
              ButtonSegment(value: '30', label: Text(context.l10n.last30Days)),
              ButtonSegment(value: 'all', label: Text(context.l10n.all)),
            ],
            selected: {_range},
            onSelectionChanged: (s) => setState(() => _range = s.first),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(children: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(context.l10n.allTypes),
                selected: _type == null,
                onSelected: (_) => setState(() => _type = null),
              ),
            ),
            for (final t in ActivityType.values)
              Padding(
                padding: EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text(_typeLabel(t)),
                  selected: _type == t,
                  onSelected: (_) => setState(() => _type = t),
                ),
              ),
          ]),
        ),
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(context.l10n.noActivityFromNow,
                        textAlign: TextAlign.center, style: TextStyle(color: SpheraColors.muted)),
                  ),
                )
              : ListView(padding: EdgeInsets.fromLTRB(16, 0, 16, 24), children: children),
        ),
      ]),
    );
  }
}
