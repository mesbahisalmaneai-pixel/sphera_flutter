import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/phone_notifications.dart';
import '../../data/settings.dart';

/// Settings > Notifications: in-app alerts, reminders, phone notifications
/// and the daily summary.
class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  static String _two(int n) => n.toString().padLeft(2, '0');

  Future<void> _togglePhone(BuildContext context, WidgetRef ref, bool on) async {
    final notifier = ref.read(notificationPrefsProvider.notifier);
    if (!on) return notifier.setPhone(false);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    if (!PhoneNotifications.supported) {
      messenger.showSnackBar(SnackBar(content: Text(l.phoneNotifsMobileOnly)));
      return;
    }
    final allowed = await PhoneNotifications.instance.requestPermission();
    if (allowed) {
      await notifier.setPhone(true);
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l.notifsBlocked)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPrefsProvider);
    final notifier = ref.read(notificationPrefsProvider.notifier);
    final phoneOn = prefs.enabled && prefs.phone;

    Color iconColor(bool on) => on ? SpheraColors.gold : SpheraColors.muted;
    Widget note(String t) => Padding(
          padding: const EdgeInsets.fromLTRB(4, 10, 4, 14),
          child: Text(t, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.notifications)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          child: Column(children: [
            SwitchListTile(
              secondary: Icon(Icons.notifications_outlined, color: SpheraColors.gold),
              title: Text(context.l10n.notifications),
              subtitle: Text(context.l10n.notifsSub),
              value: prefs.enabled,
              onChanged: notifier.setEnabled,
            ),
            Divider(height: 1, color: SpheraColors.border),
            SwitchListTile(
              secondary: Icon(Icons.alarm_outlined, color: iconColor(prefs.enabled)),
              title: Text(context.l10n.reminders),
              subtitle: Text(context.l10n.remindersSub),
              value: prefs.enabled && prefs.reminders,
              onChanged: prefs.enabled ? notifier.setReminders : null,
            ),
          ]),
        ),
        note(context.l10n.alertsNote),
        Card(
          child: Column(children: [
            SwitchListTile(
              secondary: Icon(Icons.phone_android_rounded, color: iconColor(prefs.enabled)),
              title: Text(context.l10n.phoneNotifications),
              subtitle: Text(context.l10n.phoneNotificationsSub),
              value: phoneOn,
              onChanged: prefs.enabled ? (v) => _togglePhone(context, ref, v) : null,
            ),
            Divider(height: 1, color: SpheraColors.border),
            SwitchListTile(
              secondary: Icon(Icons.today_outlined, color: iconColor(phoneOn)),
              title: Text(context.l10n.dailySummary),
              subtitle: Text(context.l10n.dailySummarySub),
              value: phoneOn && prefs.daily,
              onChanged: phoneOn ? notifier.setDaily : null,
            ),
            Divider(height: 1, color: SpheraColors.border),
            ListTile(
              enabled: phoneOn && prefs.daily,
              leading: Icon(Icons.schedule_rounded, color: iconColor(phoneOn && prefs.daily)),
              title: Text(context.l10n.summaryTime),
              trailing: Text('${_two(prefs.dailyHour)}:${_two(prefs.dailyMinute)}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              onTap: () async {
                final t = await showTimePicker(
                    context: context, initialTime: TimeOfDay(hour: prefs.dailyHour, minute: prefs.dailyMinute));
                if (t != null) await notifier.setDailyTime(t.hour, t.minute);
              },
            ),
            Divider(height: 1, color: SpheraColors.border),
            ListTile(
              enabled: phoneOn,
              leading: Icon(Icons.send_outlined, color: iconColor(phoneOn)),
              title: Text(context.l10n.sendTestNotification),
              onTap: () => PhoneNotifications.instance.showTest(),
            ),
          ]),
        ),
        note(context.l10n.phoneNotifsNote),
      ]),
    );
  }
}
