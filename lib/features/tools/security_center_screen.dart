import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../data/smart_tools.dart';
import '../settings/trash_screen.dart';
import 'duplicate_scanner_screen.dart';

/// Data problems, protection, backup and sync status. Read-only: it reports,
/// it never deletes or merges anything.
class SecurityCenterScreen extends ConsumerWidget {
  const SecurityCenterScreen({super.key});

  Widget _section(String t) => Padding(
        padding: EdgeInsets.fromLTRB(4, 22, 0, 8),
        child: Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
      );

  Widget _row(IconData icon, Color color, String title, String subtitle, {VoidCallback? onTap}) => ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        trailing: onTap == null ? null : Icon(Icons.chevron_right),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = ref.watch(dataHealthProvider);
    final ok = SpheraColors.done;
    final warn = SpheraColors.coming;
    final info = SpheraColors.muted;

    return Scaffold(
      appBar: AppBar(title: Text('Security Center')),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Row(children: [
              Icon(h.issues == 0 ? Icons.verified_user_outlined : Icons.shield_outlined,
                  size: 36, color: h.issues == 0 ? ok : warn),
              SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(h.issues == 0 ? 'Everything looks good' : '${h.issues} item${h.issues == 1 ? '' : 's'} to review',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  Text('Based on the data stored on this device.',
                      style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                ]),
              ),
            ]),
          ),
        ),
        _section('Data health'),
        Card(
          child: Column(children: [
            _row(
              h.duplicates == 0 ? Icons.check_circle : Icons.warning_amber_rounded,
              h.duplicates == 0 ? ok : warn,
              'Duplicate accounts',
              h.duplicates == 0 ? 'None found' : '${h.duplicates} group(s) to review',
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => DuplicateScannerScreen())),
            ),
            Divider(height: 1, color: SpheraColors.border),
            _row(
              h.gameDuplicates == 0 ? Icons.check_circle : Icons.warning_amber_rounded,
              h.gameDuplicates == 0 ? ok : warn,
              'Duplicate game Account IDs',
              h.gameDuplicates == 0 ? 'None found' : '${h.gameDuplicates} group(s) to review',
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => DuplicateScannerScreen())),
            ),
            Divider(height: 1, color: SpheraColors.border),
            _row(
              h.missingIds == 0 ? Icons.check_circle : Icons.warning_amber_rounded,
              h.missingIds == 0 ? ok : warn,
              'Game accounts without Account ID',
              h.missingIds == 0 ? 'All have an Account ID' : '${h.missingIds} account(s) missing an ID',
            ),
            Divider(height: 1, color: SpheraColors.border),
            _row(
              h.invalidEmails == 0 ? Icons.check_circle : Icons.warning_amber_rounded,
              h.invalidEmails == 0 ? ok : warn,
              'Invalid emails',
              h.invalidEmails == 0 ? 'All emails look valid' : '${h.invalidEmails} account(s) with a wrong email format',
            ),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.info_outline, info, 'Accounts with no boxes set',
                '${h.noBoxes} (just informational)'),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.delete_outline, info, 'Items in Trash',
                h.trashed == 0 ? 'Empty' : '${h.trashed} kept, nothing is removed automatically',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TrashScreen()))),
          ]),
        ),
        _section('Protection'),
        Card(
          child: Column(children: [
            _row(Icons.lock_outline, warn, 'App lock', 'Not enabled yet'),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.phone_android, ok, 'Local storage', 'Your data stays on this device'),
          ]),
        ),
        _section('Backup'),
        Card(child: _row(Icons.backup_outlined, warn, 'Backup', 'No backup yet. Backup is not available in this version.')),
        _section('Sync status'),
        Card(child: _row(Icons.cloud_off_outlined, info, 'Cloud sync', 'Local only. Sync is not connected yet.')),
        _section('Safety rules'),
        Card(
          child: Column(children: [
            _row(Icons.check_circle, ok, 'No automatic deletion', 'Nothing is deleted without you'),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.check_circle, ok, 'No automatic merging', 'Scanning and organizing never merge accounts'),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.check_circle, ok, 'Manual review first', 'Every change is made by you, after review'),
          ]),
        ),
      ]),
    );
  }
}
