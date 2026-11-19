import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    if (!PhoneNotifications.supported) {
      messenger.showSnackBar(const SnackBar(content: Text('Phone notifications work on Android and iOS only.')));
      return;
    }
    final allowed = await PhoneNotifications.instance.requestPermission();
    if (allowed) {
      await notifier.setPhone(true);
    } else {
      messenger.showSnackBar(const SnackBar(
          content: Text('Notifications are blocked for SPHERA. Allow them in your phone settings, then try again.')));
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
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          child: Column(children: [
            SwitchListTile(
              secondary: Icon(Icons.notifications_outlined, color: SpheraColors.gold),
              title: const Text('Notifications'),
              subtitle: const Text('Warnings and reminders in SPHERA'),
              value: prefs.enabled,
              onChanged: notifier.setEnabled,
            ),
            Divider(height: 1, color: SpheraColors.border),
            SwitchListTile(
              secondary: Icon(Icons.alarm_outlined, color: iconColor(prefs.enabled)),
              title: const Text('Reminders'),
              subtitle: const Text('Stale FOR SALE listings, COMING boxes, goals behind pace'),
              value: prefs.enabled && prefs.reminders,
              onChanged: prefs.enabled ? notifier.setReminders : null,
            ),
          ]),
        ),
        note('Alerts always appear in the Notifications center (bell icon), with a red count.'),
        Card(
          child: Column(children: [
            SwitchListTile(
              secondary: Icon(Icons.phone_android_rounded, color: iconColor(prefs.enabled)),
              title: const Text('Phone notifications'),
              subtitle: const Text('Show new alerts on your phone when you leave the app'),
              value: phoneOn,
              onChanged: prefs.enabled ? (v) => _togglePhone(context, ref, v) : null,
            ),
            Divider(height: 1, color: SpheraColors.border),
            SwitchListTile(
              secondary: Icon(Icons.today_outlined, color: iconColor(phoneOn)),
              title: const Text('Daily summary'),
              subtitle: const Text('Alerts, net profit and accounts, once a day'),
              value: phoneOn && prefs.daily,
              onChanged: phoneOn ? notifier.setDaily : null,
            ),
            Divider(height: 1, color: SpheraColors.border),
            ListTile(
              enabled: phoneOn && prefs.daily,
              leading: Icon(Icons.schedule_rounded, color: iconColor(phoneOn && prefs.daily)),
              title: const Text('Summary time'),
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
              title: const Text('Send a test notification'),
              onTap: () => PhoneNotifications.instance.showTest(),
            ),
          ]),
        ),
        note('Phone notifications are created on this device, no account or internet needed. '
            'The daily summary may arrive a few minutes late to save battery. Some phones (Xiaomi, Huawei...) '
            'block background notifications unless you allow SPHERA in battery settings.'),
      ]),
    );
  }
}
