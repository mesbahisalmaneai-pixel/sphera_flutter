import '../../data/auth/auth_repository.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../../core/progress.dart';
import '../../core/theme.dart';
import '../../data/achievements.dart';
import '../../data/profile.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../shell/header_actions.dart';

/// "Profile" tab: picture & info, activity summary, rank, achievements, session.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Widget _section(String t) => Padding(
        padding: EdgeInsets.fromLTRB(4, 22, 0, 8),
        child: Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
      );

  String _two(int n) => n.toString().padLeft(2, '0');

  void _toast(BuildContext context, String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _photoSheet(BuildContext context, WidgetRef ref, ProfileData profile) async {
    final notifier = ref.read(profileProvider.notifier);
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: Icon(Icons.photo_library_outlined, color: SpheraColors.gold),
            title: Text('Choose from gallery'),
            onTap: () => Navigator.pop(ctx, 'pick'),
          ),
          if (profile.photoPath != null)
            ListTile(
              leading: Icon(Icons.delete_outline, color: SpheraColors.danger),
              title: Text('Remove photo'),
              onTap: () => Navigator.pop(ctx, 'remove'),
            ),
        ]),
      ),
    );
    if (action == 'pick') {
      final err = await notifier.pickPhoto();
      if (err != null && context.mounted) _toast(context, err);
    } else if (action == 'remove') {
      await notifier.removePhoto();
    }
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, ProfileData profile) async {
    final res = await showDialog<(String, String)>(
      context: context,
      builder: (_) => _EditDialog(name: profile.name, email: profile.email),
    );
    if (res != null) await ref.read(profileProvider.notifier).setInfo(res.$1, res.$2);
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Log out?'),
        content: Text(
            'You will need to log in again. Your profile, accounts, games and statistics are kept on this device.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Log out', style: TextStyle(color: SpheraColors.danger))),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(authProvider.notifier).signOut();
    if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final google = ref.watch(googleAccountCountProvider).value ?? 0;
    final games = ref.watch(gameCountProvider).value ?? 0;
    final accounts = ref.watch(gameAccountCountProvider).value ?? 0;
    final profit = ref.watch(totalProfitProvider).value ?? 0.0;
    final cur = ref.watch(currencyProvider);

    final points = championshipPoints(googleAccounts: google, games: games, gameAccounts: accounts, profit: profit);
    final rIdx = rankIndex(points);
    final rank = kRanks[rIdx];
    final next = rIdx + 1 < kRanks.length ? kRanks[rIdx + 1] : null;
    final rankProgress = next == null ? 1.0 : (points - rank.min) / (next.min - rank.min);

    final achievements = ref.watch(achievementsProvider);
    final unlocked = achievements.where((a) => a.done).length;
    final upNext = achievements.where((a) => !a.done).toList()
      ..sort((a, b) => b.fraction.compareTo(a.fraction));

    final hasPhoto = profile.photoPath != null && File(profile.photoPath!).existsSync();
    final onAccent = Theme.of(context).colorScheme.onPrimary;
    final s = profile.sessionStart;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [HeaderActions(), SizedBox(width: 4)],
      ),
      body: ListView(padding: EdgeInsets.all(16), children: [
        // ---------- Picture & personal info ----------
        Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              GestureDetector(
                onTap: () => _photoSheet(context, ref, profile),
                child: Stack(children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: SpheraColors.surfaceHigh,
                    backgroundImage: hasPhoto ? FileImage(File(profile.photoPath!)) : null,
                    child: hasPhoto ? null : Icon(Icons.person_outline, size: 44, color: SpheraColors.gold),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: SpheraColors.gold,
                      child: Icon(Icons.camera_alt, size: 15, color: onAccent),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 14),
              Text(profile.name.isEmpty ? 'SPHERA User' : profile.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text(profile.email.isEmpty ? 'Local mode' : profile.email,
                  style: TextStyle(color: SpheraColors.muted, fontSize: 13)),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: SpheraColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: SpheraColors.gold.withValues(alpha: 0.6)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.military_tech_outlined, size: 18, color: SpheraColors.gold),
                  SizedBox(width: 6),
                  Text('${rank.name} · $points pts',
                      style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w700, fontSize: 13)),
                ]),
              ),
              SizedBox(height: 6),
              TextButton.icon(
                onPressed: () => _edit(context, ref, profile),
                icon: Icon(Icons.edit_outlined, size: 18),
                label: Text('Edit profile'),
              ),
            ]),
          ),
        ),

        // ---------- Activity summary ----------
        _section('Activity summary'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.9,
          children: [
            _StatTile(icon: Icons.mail_outline, label: 'Google accounts', value: '$google'),
            _StatTile(icon: Icons.sports_esports_outlined, label: 'Games', value: '$games'),
            _StatTile(icon: Icons.person_search_outlined, label: 'Game accounts', value: '$accounts'),
            _StatTile(
              icon: Icons.trending_up_rounded,
              label: 'Profit / loss',
              value: money(profit, currency: cur),
              color: profit >= 0 ? SpheraColors.done : SpheraColors.danger,
            ),
          ],
        ),

        // ---------- Rank points ----------
        _section('Rank'),
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed('/arena'),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.emoji_events_outlined, color: SpheraColors.gold, size: 30),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Rank: ${rank.name}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      Text('$points rank points', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                    ]),
                  ),
                  Icon(Icons.chevron_right, color: SpheraColors.muted),
                ]),
                SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: rankProgress.clamp(0.0, 1.0).toDouble(),
                    minHeight: 10,
                    backgroundColor: SpheraColors.surfaceHigh,
                    color: SpheraColors.gold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  next == null
                      ? 'Top rank reached'
                      : '${next.min - points} pts to ${next.name}',
                  style: TextStyle(color: SpheraColors.muted, fontSize: 12),
                ),
              ]),
            ),
          ),
        ),

        // ---------- Achievement progress ----------
        _section('Achievements'),
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed('/achievements'),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.military_tech_outlined, color: SpheraColors.gold, size: 30),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('$unlocked / ${achievements.length} unlocked',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                  Icon(Icons.chevron_right, color: SpheraColors.muted),
                ]),
                SizedBox(height: 10),
                if (upNext.isEmpty)
                  Text('All achievements unlocked.', style: TextStyle(color: SpheraColors.muted, fontSize: 12))
                else
                  for (final a in upNext.take(3))
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(a.title, style: TextStyle(fontSize: 13))),
                          Text('${a.current} / ${a.target}',
                              style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                        ]),
                        SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: a.fraction,
                            minHeight: 8,
                            backgroundColor: SpheraColors.surfaceHigh,
                            color: SpheraColors.gold,
                          ),
                        ),
                      ]),
                    ),
              ]),
            ),
          ),
        ),

        // ---------- Session & logout ----------
        _section('Session'),
        Card(
          child: Column(children: [
            ListTile(
              leading: Icon(Icons.schedule, color: SpheraColors.gold),
              title: Text('Current session'),
              subtitle: Text('Started at ${_two(s.hour)}:${_two(s.minute)}'),
            ),
            Divider(height: 1, color: SpheraColors.border),
            ListTile(
              leading: Icon(Icons.phone_android, color: SpheraColors.gold),
              title: Text('Local mode'),
              subtitle: Text('Your data is stored on this device only.'),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _logout(context, ref),
                  icon: Icon(Icons.logout, color: SpheraColors.danger),
                  label: Text('Log out', style: TextStyle(color: SpheraColors.danger)),
                  style: OutlinedButton.styleFrom(side: BorderSide(color: SpheraColors.danger)),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value, this.color});
  final IconData icon;
  final String label, value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(children: [
            Icon(icon, size: 16, color: SpheraColors.gold),
            SizedBox(width: 6),
            Expanded(
              child: Text(label,
                  overflow: TextOverflow.ellipsis, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            ),
          ]),
          SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
          ),
        ]),
      ),
    );
  }
}

class _EditDialog extends StatefulWidget {
  const _EditDialog({required this.name, required this.email});
  final String name, email;

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  late final TextEditingController _name = TextEditingController(text: widget.name);
  late final TextEditingController _email = TextEditingController(text: widget.email);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit profile'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _name,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(hintText: 'Name'),
        ),
        SizedBox(height: 12),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(hintText: 'Email'),
        ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(
            onPressed: () => Navigator.pop(context, (_name.text.trim(), _email.text.trim())),
            child: Text('Save')),
      ],
    );
  }
}
