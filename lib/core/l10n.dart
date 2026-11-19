import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show DateFormat;
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

/// The app language for code that has no BuildContext: labels used by data
/// providers, painters and helpers such as [boxLabel]. SpheraApp sets it on
/// every build (the whole tree rebuilds when the language changes). English
/// until then, and in tests that do not set it.
AppLocalizations appL10n = lookupAppLocalizations(const Locale('en'));

const _enShortMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// Short month name in the app language ("Jan", "janv.", "يناير"). The app's
/// localization delegates load the month names; without them (a screen shown
/// on its own in a test) English is used.
String shortMonth(DateTime d) {
  try {
    return DateFormat.MMM(appL10n.localeName).format(d);
  } on Exception {
    return _enShortMonths[d.month - 1];
  }
}
