import 'dart:ui' show Locale;

import '../../l10n/app_localizations.dart';

/// Minimum / maximum age accepted at sign-up.
const kMinAge = 13;
const kMaxAge = 100;

AppLocalizations _en() => lookupAppLocalizations(const Locale('en'));

/// Pure validation rules for the sign-up / login forms (unit-tested).
/// Every method returns an error message in the language of [l] (English
/// when it is left out), or null when the value is valid.
class AuthValidation {
  AuthValidation._();

  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final _phone = RegExp(r'^\+?\d{8,15}$');
  static final _user = RegExp(r'^[A-Za-z0-9_.]{3,20}$');

  /// Emails are lower-cased; phone numbers lose spaces, dashes, dots, brackets.
  static String normalizeIdentifier(String v) {
    final t = v.trim();
    if (t.contains('@')) return t.toLowerCase();
    return t.replaceAll(RegExp(r'[\s\-().]'), '');
  }

  static String? identifier(String? v, [AppLocalizations? l]) {
    l ??= _en();
    final t = (v ?? '').trim();
    if (t.isEmpty) return l.valEnterIdentifier;
    final n = normalizeIdentifier(t);
    if (_email.hasMatch(n) || _phone.hasMatch(n)) return null;
    return l.valInvalidIdentifier;
  }

  static String? username(String? v, [AppLocalizations? l]) {
    l ??= _en();
    final t = (v ?? '').trim();
    if (t.isEmpty) return l.valChooseUsername;
    if (!_user.hasMatch(t)) return l.valUsernameRule;
    return null;
  }

  static String? password(String? v, [AppLocalizations? l]) {
    l ??= _en();
    final t = v ?? '';
    if (t.isEmpty) return l.valCreatePassword;
    if (t.length < 8) return l.valPasswordLength;
    if (!t.contains(RegExp(r'[A-Za-z]')) || !t.contains(RegExp(r'\d'))) {
      return l.valPasswordMix;
    }
    return null;
  }

  static String? confirm(String password, String? confirm, [AppLocalizations? l]) {
    l ??= _en();
    if ((confirm ?? '').isEmpty) return l.valConfirmPassword;
    if (confirm != password) return l.valPasswordsMismatch;
    return null;
  }

  static String? age(int v, [AppLocalizations? l]) {
    l ??= _en();
    if (v < kMinAge) return l.valMinAge(kMinAge);
    if (v > kMaxAge) return l.valInvalidAge;
    return null;
  }
}
