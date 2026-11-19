import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/insights.dart';
import '../../data/settings.dart';
import '../intelligence/insight_widgets.dart';
import '../settings/notifications_settings_screen.dart';

/// In-app notifications: warnings and reminders found by SPHERA Intelligence.
/// Opening this screen marks them as read (the bell badge clears).
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  /// What was unread when the screen opened, so the dots stay visible while reading.
  Set<String>? _unreadOnOpen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final read = ref.read(readNotificationsProvider);
      final current = ref.read(notificationsProvider);
      setState(() => _unreadOnOpen = {for (final i in current) if (!read.contains(i.id)) i.id});
      ref.read(readNotificationsProvider.notifier).markAllRead(current.map((i) => i.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(notificationPrefsProvider);
    final items = ref.watch(notificationsProvider);
    final unread = _unreadOnOpen ?? const <String>{};

    // Keep "read" in sync if new alerts appear while the screen is open.
    ref.listen(notificationsProvider, (_, next) {
      ref.read(readNotificationsProvider.notifier).markAllRead(next.map((i) => i.id));
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notifications),
        actions: [
          IconButton(
            tooltip: context.l10n.notificationSettings,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const NotificationsSettingsScreen())),
          ),
        ],
      ),
      body: !prefs.enabled
          ? _empty(Icons.notifications_off_outlined, context.l10n.notifsOff,
              context.l10n.turnOnInSettings)
          : items.isEmpty
              ? _empty(Icons.notifications_none_rounded, context.l10n.allClear, context.l10n.noWarningsNow)
              : ListView(padding: const EdgeInsets.all(16), children: [
                  for (final i in items) InsightTile(i, unread: unread.contains(i.id)),
                  if (!prefs.reminders)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                      child: Text(context.l10n.remindersMuted,
                          style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                    ),
                ]),
    );
  }

  Widget _empty(IconData icon, String title, String body) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 56, color: SpheraColors.gold),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(body, textAlign: TextAlign.center, style: TextStyle(color: SpheraColors.muted)),
          ]),
        ),
      );
}

/// Bell icon with the unread count, used in every header.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(unreadNotificationCountProvider);
    return IconButton(
      tooltip: n == 0 ? context.l10n.notifications : context.l10n.notificationsNew(n),
      icon: Badge(
        isLabelVisible: n > 0,
        label: Text(n > 9 ? '9+' : '$n'),
        backgroundColor: SpheraColors.danger,
        child: Icon(Icons.notifications_none_rounded, color: color ?? SpheraColors.muted),
      ),
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const NotificationsScreen())),
    );
  }
}
