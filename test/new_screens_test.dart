import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sphera_flutter/core/theme.dart';
import 'package:sphera_flutter/data/database.dart';
import 'package:sphera_flutter/data/providers.dart';
import 'package:sphera_flutter/data/assistant/assistant_chat.dart';
import 'package:sphera_flutter/features/intelligence/intelligence_screen.dart';
import 'package:sphera_flutter/features/settings/notifications_settings_screen.dart';
import 'package:sphera_flutter/features/notifications/notifications_screen.dart';
import 'package:sphera_flutter/features/stats/performance_center_screen.dart';

/// Renders the Performance Center, SPHERA Intelligence and Notifications at
/// phone size with sample data: no exceptions, no overflow.
void main() {
  final now = DateTime.now();
  GameAccount acc(String id, double p, double s, DateTime t, GameAccountStatus st, {String g = 'efootball'}) =>
      GameAccount(
          id: id,
          ownerId: 'u1',
          gameId: g,
          idCompte: id,
          name: 'Account $id',
          purchasePrice: p,
          salePrice: s,
          status: st,
          playerPhotoIds: '[]',
          createdAt: t,
          updatedAt: t);
  Game game(String id) =>
      Game(id: id, ownerId: 'u1', name: id.toUpperCase(), createdAt: DateTime(2025), updatedAt: DateTime(2025));

  final accounts = [
    acc('1', 100, 300, now, GameAccountStatus.active),
    acc('2', 100, 160, now.subtract(const Duration(days: 1)), GameAccountStatus.sell),
    acc('3', 200, 120, now.subtract(const Duration(days: 40)), GameAccountStatus.sell, g: 'ff'),
    acc('4', 90, 0, now.subtract(const Duration(days: 30)), GameAccountStatus.forSale),
  ];

  Widget app(Widget screen) => ProviderScope(
        overrides: [
          activeGamesProvider.overrideWith((ref) => Stream.value([game('efootball'), game('ff')])),
          allGameAccountsProvider.overrideWith((ref) => Stream.value(accounts)),
          googleAccountsProvider.overrideWith((ref) => Stream.value(const <GoogleAccount>[])),
          googleBoxesProvider.overrideWith((ref) => Stream.value(const <GoogleGameBox>[])),
          trashedGoogleAccountsProvider.overrideWith((ref) => Stream.value(const <GoogleAccount>[])),
          trashedGameAccountsProvider.overrideWith((ref) => Stream.value(const <GameAccount>[])),
          googleAccountCountProvider.overrideWith((ref) => Stream.value(0)),
          gameCountProvider.overrideWith((ref) => Stream.value(2)),
          gameAccountCountProvider.overrideWith((ref) => Stream.value(accounts.length)),
          totalProfitProvider.overrideWith((ref) => Stream.value(0.0)),
          keyStoreProvider.overrideWithValue(_NoKeys()),
        ],
        child: MaterialApp(theme: buildSpheraTheme(style: 'gold', dark: true), home: screen),
      );

  setUp(() => SharedPreferences.setMockInitialValues({'goal_month_profit': 1000.0}));

  Future<void> pumpPhone(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(360 * 3, 740 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(screen));
    await tester.pumpAndSettle();
  }

  testWidgets('Performance Center shows periods, goal and highlights', (tester) async {
    await pumpPhone(tester, const PerformanceCenterScreen());
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('This month'), findsOneWidget);
    expect(find.text('Profit'), findsOneWidget); // goal row (1000 DH goal)
    await tester.scrollUntilVisible(find.text('Add streak'), 300);
    expect(find.text('Add streak'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ask tab: a suggested question gets an offline answer with a button', (tester) async {
    await pumpPhone(tester, const IntelligenceScreen());
    expect(find.text('Ask SPHERA anything'), findsOneWidget);
    await tester.tap(find.text('Which game makes the most money?'));
    await tester.pumpAndSettle();
    expect(find.textContaining('EFOOTBALL makes the most'), findsOneWidget);
    expect(find.text('Games Statistics'), findsOneWidget); // action chip
    expect(find.text('Offline'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'how do I restore an account');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();
    expect(find.textContaining('Settings > Trash'), findsOneWidget);

    await tester.tap(find.byTooltip('AI mode: off'));
    await tester.pumpAndSettle();
    expect(find.text('Use Claude AI'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Notification settings render at phone size', (tester) async {
    await pumpPhone(tester, const NotificationsSettingsScreen());
    expect(find.text('Phone notifications'), findsOneWidget);
    expect(find.text('20:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Intelligence lists insights and filters by level', (tester) async {
    await pumpPhone(tester, const IntelligenceScreen(initialTab: 1));
    expect(find.text('FF is losing money'), findsOneWidget);
    await tester.tap(find.textContaining('Good news ('));
    await tester.pumpAndSettle();
    expect(find.text('FF is losing money'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Notifications show alerts and clear the bell badge', (tester) async {
    await pumpPhone(
        tester, Scaffold(appBar: AppBar(actions: const [NotificationBell()]), body: const SizedBox()));
    expect(find.byType(Badge), findsOneWidget);
    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.isLabelVisible, isTrue);

    await tester.tap(find.byType(NotificationBell));
    await tester.pumpAndSettle();
    expect(find.text('FF is losing money'), findsOneWidget);
    expect(find.textContaining('waiting for over'), findsOneWidget); // stale FOR SALE reminder

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isFalse);
    expect(tester.takeException(), isNull);
  });
}

class _NoKeys implements KeyStore {
  @override
  Future<String?> read() async => null;
  @override
  Future<void> write(String? value) async {}
}
