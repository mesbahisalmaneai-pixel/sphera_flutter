import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../data/achievements.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  AchievementStatus? _filter; // null = all

  Widget _chip(String label, AchievementStatus? value) => Padding(
        padding: EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(label),
          selected: _filter == value,
          onSelected: (_) => setState(() => _filter = value),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(achievementsProvider);
    final unlocked = all.where((a) => a.done).length;
    final totalPts = all.fold<int>(0, (t, a) => t + a.points);
    final earnedPts = all.where((a) => a.done).fold<int>(0, (t, a) => t + a.points);
    final shown = _filter == null ? all : all.where((a) => a.status == _filter).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Achievements')),
      body: ListView(padding: EdgeInsets.all(16), children: [
        // ---------- Summary ----------
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.military_tech_outlined, color: SpheraColors.gold, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('$unlocked / ${all.length} unlocked',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    Text('$earnedPts / $totalPts achievement points',
                        style: TextStyle(color: SpheraColors.gold, fontSize: 12, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ]),
              SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: all.isEmpty ? 0 : unlocked / all.length,
                  minHeight: 10,
                  backgroundColor: SpheraColors.surfaceHigh,
                  color: SpheraColors.gold,
                ),
              ),
              SizedBox(height: 8),
              Text('Achievement points are separate from rank points and from Google Play grades.',
                  style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            ]),
          ),
        ),
        SizedBox(height: 12),
        // ---------- Filters ----------
        SizedBox(
          height: 44,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            _chip('All', null),
            _chip('Unlocked', AchievementStatus.unlocked),
            _chip('In progress', AchievementStatus.inProgress),
            _chip('Locked', AchievementStatus.locked),
          ]),
        ),
        // ---------- By category ----------
        if (shown.isEmpty)
          Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: Text('Nothing here yet', style: TextStyle(color: SpheraColors.muted))),
          ),
        for (final cat in AchievementCategory.values) ..._category(cat, all, shown),
        SizedBox(height: 8),
        Text('Dates show when an achievement was first detected on this device. Profit amounts are counted in DH.',
            style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
      ]),
    );
  }

  List<Widget> _category(AchievementCategory cat, List<Achievement> all, List<Achievement> shown) {
    final items = shown.where((a) => a.category == cat).toList();
    if (items.isEmpty) return [];
    final inCat = all.where((a) => a.category == cat);
    final doneInCat = inCat.where((a) => a.done).length;
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(4, 20, 0, 8),
        child: Row(children: [
          Icon(cat.icon, size: 18, color: SpheraColors.gold),
          SizedBox(width: 8),
          Text(cat.label,
              style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
          Spacer(),
          Text('$doneInCat / ${inCat.length}', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        ]),
      ),
      for (final a in items) _AchievementCard(a),
    ];
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard(this.a);
  final Achievement a;

  String _date(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final st = a.status;
    final onAccent = Theme.of(context).colorScheme.onPrimary;
    final gold = SpheraColors.gold;

    final (Color fill, Color border, Color iconColor, IconData icon) = switch (st) {
      AchievementStatus.unlocked => (gold, gold, onAccent, a.icon),
      AchievementStatus.inProgress => (gold.withValues(alpha: 0.12), gold, gold, a.icon),
      AchievementStatus.locked => (SpheraColors.surfaceHigh, SpheraColors.border, SpheraColors.muted, Icons.lock_outline),
    };
    final (String label, Color labelColor) = switch (st) {
      AchievementStatus.unlocked => ('Unlocked', gold),
      AchievementStatus.inProgress => ('In progress', SpheraColors.goldSoft),
      AchievementStatus.locked => ('Locked', SpheraColors.muted),
    };

    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              border: Border.all(color: border, width: 1.5),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(a.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                Text(label, style: TextStyle(color: labelColor, fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
              SizedBox(height: 3),
              Text('Unlock: ${a.description}', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
              SizedBox(height: 8),
              if (st == AchievementStatus.unlocked)
                Row(children: [
                  Icon(Icons.check_circle, size: 14, color: gold),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      a.unlockedAt == null ? 'Unlocked' : 'Unlocked on ${_date(a.unlockedAt!)}',
                      style: TextStyle(color: SpheraColors.muted, fontSize: 12),
                    ),
                  ),
                  Text('+${a.points} pts', style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.w700)),
                ])
              else ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: a.fraction,
                    minHeight: 8,
                    backgroundColor: SpheraColors.surfaceHigh,
                    color: gold,
                  ),
                ),
                SizedBox(height: 4),
                Row(children: [
                  Expanded(
                    child: Text('${a.current} / ${a.target}  ·  ${(a.fraction * 100).floor()}%',
                        style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                  ),
                  Text('+${a.points} pts', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                ]),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}
