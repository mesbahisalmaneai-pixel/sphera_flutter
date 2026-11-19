import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
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
      appBar: AppBar(title: Text(context.l10n.securityCenter)),
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
                  Text(h.issues == 0 ? context.l10n.everythingGood : context.l10n.itemsToReview(h.issues),
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                  Text(context.l10n.basedOnDeviceData,
                      style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                ]),
              ),
            ]),
          ),
        ),
        _section(context.l10n.dataHealth),
        Card(
          child: Column(children: [
            _row(
              h.duplicates == 0 ? Icons.check_circle : Icons.warning_amber_rounded,
              h.duplicates == 0 ? ok : warn,
              context.l10n.duplicateAccounts,
              h.duplicates == 0 ? context.l10n.noneFound : context.l10n.groupsToReview(h.duplicates),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => DuplicateScannerScreen())),
            ),
            Divider(height: 1, color: SpheraColors.border),
            _row(
              h.gameDuplicates == 0 ? Icons.check_circle : Icons.warning_amber_rounded,
              h.gameDuplicates == 0 ? ok : warn,
              context.l10n.duplicateGameIds,
              h.gameDuplicates == 0 ? context.l10n.noneFound : context.l10n.groupsToReview(h.gameDuplicates),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => DuplicateScannerScreen())),
            ),
            Divider(height: 1, color: SpheraColors.border),
            _row(
              h.missingIds == 0 ? Icons.check_circle : Icons.warning_amber_rounded,
              h.missingIds == 0 ? ok : warn,
              context.l10n.accountsWithoutId,
              h.missingIds == 0 ? context.l10n.allHaveId : context.l10n.accountsMissingId(h.missingIds),
            ),
            Divider(height: 1, color: SpheraColors.border),
            _row(
              h.invalidEmails == 0 ? Icons.check_circle : Icons.warning_amber_rounded,
              h.invalidEmails == 0 ? ok : warn,
              context.l10n.invalidEmails,
              h.invalidEmails == 0 ? context.l10n.allEmailsValid : context.l10n.accountsWrongEmail(h.invalidEmails),
            ),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.info_outline, info, context.l10n.accountsNoBoxes,
                context.l10n.justInformational(h.noBoxes)),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.delete_outline, info, context.l10n.itemsInTrash,
                h.trashed == 0 ? context.l10n.empty : context.l10n.trashKept(h.trashed),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TrashScreen()))),
          ]),
        ),
        _section(context.l10n.protection),
        Card(
          child: Column(children: [
            _row(Icons.lock_outline, warn, context.l10n.appLock, context.l10n.notEnabledYet),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.phone_android, ok, context.l10n.localStorage, context.l10n.dataStaysOnDevice),
          ]),
        ),
        _section(context.l10n.backup),
        Card(child: _row(Icons.backup_outlined, warn, context.l10n.backup, context.l10n.noBackupYet)),
        _section(context.l10n.syncStatus),
        Card(child: _row(Icons.cloud_off_outlined, info, context.l10n.cloudSync, context.l10n.localOnly)),
        _section(context.l10n.safetyRules),
        Card(
          child: Column(children: [
            _row(Icons.check_circle, ok, context.l10n.noAutoDeletion, context.l10n.nothingDeletedWithoutYou),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.check_circle, ok, context.l10n.noAutoMerging, context.l10n.neverMerge),
            Divider(height: 1, color: SpheraColors.border),
            _row(Icons.check_circle, ok, context.l10n.manualReviewFirst, context.l10n.changesByYou),
          ]),
        ),
      ]),
    );
  }
}
