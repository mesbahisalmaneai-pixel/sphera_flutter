import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

export '../l10n/app_localizations.dart';

/// Translated texts: `context.l10n.navHome`.
///
/// To add a text: put it in lib/l10n/app_en.arb, app_fr.arb and app_ar.arb,
/// then run `flutter gen-l10n` (flutter run does it too).
extension L10nX on BuildContext {
  /// Falls back to English where no localizations are set up (widget tests
  /// that pump a screen in a bare MaterialApp).
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      lookupAppLocalizations(const Locale('en'));
}
