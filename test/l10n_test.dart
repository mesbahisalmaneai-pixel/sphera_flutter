import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sphera_flutter/core/l10n.dart';
import 'package:sphera_flutter/core/theme.dart';
import 'package:sphera_flutter/data/database.dart';
import 'package:sphera_flutter/data/providers.dart';
import 'package:sphera_flutter/features/settings/settings_screen.dart';
import 'package:sphera_flutter/features/stats/statistics_screen.dart';

/// English, French and Arabic: every text exists in all three, screens render
/// in each language at phone size, and Arabic is right-to-left.
void main() {
  Map<String, dynamic> arb(String lang) =>
      (jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync()) as Map).cast<String, dynamic>();

  test('French and Arabic translate every English text', () {
    final keys = arb('en').keys.where((k) => !k.startsWith('@')).toSet();
    for (final lang in ['fr', 'ar']) {
      final other = arb(lang).keys.where((k) => !k.startsWith('@')).toSet();
      expect(keys.difference(other), isEmpty, reason: '$lang is missing these texts');
      expect(other.difference(keys), isEmpty, reason: '$lang has texts English does not');
    }
  });

  test('plurals', () {
    final fr = lookupAppLocalizations(const Locale('fr'));
    final ar = lookupAppLocalizations(const Locale('ar'));
    expect(fr.accountsCount(1), '1 compte');
    expect(fr.accountsCount(3), '3 comptes');
    expect(ar.accountsCount(1), 'حساب واحد');
    expect(ar.accountsCount(2), 'حسابان');
    expect(ar.accountsCount(5), '5 حسابات');
  });

  Widget app(Widget screen, String lang) => ProviderScope(
        overrides: [
          trashedGoogleAccountsProvider.overrideWith((ref) => Stream.value(const <GoogleAccount>[])),
          trashedGameAccountsProvider.overrideWith((ref) => Stream.value(const <GameAccount>[])),
          activeGamesProvider.overrideWith((ref) => Stream.value(const <Game>[])),
          allGameAccountsProvider.overrideWith((ref) => Stream.value(const <GameAccount>[])),
          googleAccountsProvider.overrideWith((ref) => Stream.value(const <GoogleAccount>[])),
          googleBoxesProvider.overrideWith((ref) => Stream.value(const <GoogleGameBox>[])),
        ],
        child: MaterialApp(
          theme: buildSpheraTheme(style: 'gold', dark: true),
          locale: Locale(lang),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: screen,
        ),
      );

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pumpPhone(WidgetTester tester, Widget screen, String lang) async {
    tester.view.physicalSize = const Size(360 * 3, 740 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(screen, lang));
    await tester.pumpAndSettle();
  }

  testWidgets('Statistics in French', (tester) async {
    await pumpPhone(tester, const StatisticsScreen(), 'fr');
    expect(find.text('Statistiques'), findsWidgets);
    expect(find.text('Centre des bénéfices'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Statistics in Arabic is right-to-left', (tester) async {
    await pumpPhone(tester, const StatisticsScreen(), 'ar');
    expect(find.text('مركز الأرباح'), findsOneWidget);
    final dir = Directionality.of(tester.element(find.text('مركز الأرباح')));
    expect(dir, TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Settings renders in all three languages', (tester) async {
    for (final (lang, title) in [('en', 'Tools & Settings'), ('fr', 'Outils et paramètres'), ('ar', 'الأدوات والإعدادات')]) {
      await pumpPhone(tester, const SettingsScreen(), lang);
      expect(find.text(title), findsOneWidget, reason: lang);
      expect(tester.takeException(), isNull, reason: lang);
    }
  });
}
