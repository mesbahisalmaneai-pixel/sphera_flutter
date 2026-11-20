import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show ValueNotifier, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../core/l10n.dart';
import 'insights.dart';

/// Phone (system) notifications: new alerts when you leave the app, and a
/// daily summary at the time chosen in Settings > Notifications.
/// Everything is local: no server, no push service.

const _alertsId = 1;
const _dailyId = 2;
const _testId = 3;

// Channel names are shown in the phone's settings, in the app language.
AndroidNotificationDetails _alertsChannel([StyleInformation? style]) => AndroidNotificationDetails(
      'sphera_alerts',
      appL10n.notifChannelAlerts,
      channelDescription: appL10n.notifChannelAlertsDesc,
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: style,
    );
AndroidNotificationDetails _dailyChannel([StyleInformation? style]) => AndroidNotificationDetails(
      'sphera_daily',
      appL10n.notifChannelDaily,
      channelDescription: appL10n.notifChannelDailyDesc,
      styleInformation: style,
    );

/// (title, body) for a grouped "new alerts" notification, in [l]'s language
/// (the app language by default).
(String, String) alertPushText(List<Insight> alerts, [AppLocalizations? l]) {
  l ??= appL10n;
  if (alerts.length == 1) return (alerts.first.title, alerts.first.body);
  final titles = alerts.take(3).map((i) => i.title).join(' · ');
  final more = alerts.length > 3 ? l.notifMore(alerts.length - 3) : '';
  return (l.notifManyTitle(alerts.length), '$titles$more');
}

/// (title, body) of the daily summary. The same text repeats every day until
/// the app reschedules it, so it only uses values that change when you act in
/// the app (no "today" or "this month" numbers that would go stale).
(String, String) dailySummaryText(
    {required int alerts, required String netProfit, required int accounts, AppLocalizations? l}) {
  l ??= appL10n;
  final head = alerts == 0 ? l.notifAllClear : l.notifAlertsWaiting(alerts);
  return (l.notifDailyTitle, l.notifDailyBody(head, netProfit, l.accountsCount(accounts)));
}

class PhoneNotifications {
  PhoneNotifications._();
  static final instance = PhoneNotifications._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Bumped when a notification is tapped (or opened the app). The shell
  /// listens and opens the Notifications center.
  final openRequests = ValueNotifier<int>(0);

  static bool get supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void>? _initFuture;

  /// Safe to call many times: the work runs once, and callers that come while
  /// it is running wait for it. main() starts it without waiting, so the first
  /// frame is not held back by the time zone database.
  Future<void> init() {
    if (!supported || _ready) return Future.value();
    return _initFuture ??= _init().whenComplete(() {
      if (!_ready) _initFuture = null; // failed: allow a retry later
    });
  }

  Future<void> _init() async {
    try {
      tzdata.initializeTimeZones();
      try {
        final info = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(info.identifier));
      } catch (_) {
        // Unknown zone name: keep UTC; the daily time may then be off by the UTC offset.
      }
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_stat_sphera'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (_) => openRequests.value++,
      );
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) openRequests.value++;
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  /// Asks the system for permission (Android 13+ / iOS). True when allowed.
  Future<bool> requestPermission() async {
    if (!supported) return false;
    await init();
    try {
      if (Platform.isAndroid) {
        return await _plugin
                .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
                ?.requestNotificationsPermission() ??
            false;
      }
      return await _plugin
              .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    } catch (_) {
      return false;
    }
  }

  Future<void> showAlerts(List<Insight> alerts) async {
    if (alerts.isEmpty) return;
    await init();
    if (!_ready) return;
    final (title, body) = alertPushText(alerts);
    try {
      await _plugin.show(
        id: _alertsId,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: _alertsChannel(BigTextStyleInformation(body)),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: 'notifications',
      );
    } catch (_) {}
  }

  Future<void> showTest() async {
    await init();
    if (!_ready) return;
    try {
      await _plugin.show(
        id: _testId,
        title: appL10n.notifTestTitle,
        body: appL10n.notifTestBody,
        notificationDetails: NotificationDetails(android: _alertsChannel(), iOS: const DarwinNotificationDetails()),
        payload: 'notifications',
      );
    } catch (_) {}
  }

  /// (Re)schedules the repeating daily summary with up-to-date text.
  Future<void> scheduleDaily({required int hour, required int minute, required String title, required String body}) async {
    await init();
    if (!_ready) return;
    final now = tz.TZDateTime.now(tz.local);
    var at = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!at.isAfter(now)) at = at.add(const Duration(days: 1));
    try {
      await _plugin.zonedSchedule(
        id: _dailyId,
        scheduledDate: at,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: _dailyChannel(BigTextStyleInformation(body)),
          iOS: const DarwinNotificationDetails(),
        ),
        // Inexact: no exact-alarm permission needed; may arrive a few minutes late.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'notifications',
      );
    } catch (_) {}
  }

  Future<void> cancelDaily() async {
    await init();
    if (!_ready) return;
    try {
      await _plugin.cancel(id: _dailyId);
    } catch (_) {}
  }
}
