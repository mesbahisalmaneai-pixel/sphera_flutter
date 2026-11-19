/// Minimum / maximum age accepted at sign-up.
const kMinAge = 13;
const kMaxAge = 100;

/// Pure validation rules for the sign-up / login forms (unit-tested).
/// Every method returns an error message, or null when the value is valid.
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

  static String? identifier(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Enter your email or phone number';
    final n = normalizeIdentifier(t);
    if (_email.hasMatch(n) || _phone.hasMatch(n)) return null;
    return 'Enter a valid email or phone number';
  }

  static String? username(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Choose a username';
    if (!_user.hasMatch(t)) return '3-20 characters: letters, numbers, _ or .';
    return null;
  }

  static String? password(String? v) {
    final t = v ?? '';
    if (t.isEmpty) return 'Create a password';
    if (t.length < 8) return 'At least 8 characters';
    if (!t.contains(RegExp(r'[A-Za-z]')) || !t.contains(RegExp(r'\d'))) {
      return 'Use both letters and numbers';
    }
    return null;
  }

  static String? confirm(String password, String? confirm) {
    if ((confirm ?? '').isEmpty) return 'Confirm your password';
    if (confirm != password) return 'Passwords do not match';
    return null;
  }

  static String? age(int v) {
    if (v < kMinAge) return 'SPHERA is for users $kMinAge and older';
    if (v > kMaxAge) return 'Enter a valid age';
    return null;
  }
}
