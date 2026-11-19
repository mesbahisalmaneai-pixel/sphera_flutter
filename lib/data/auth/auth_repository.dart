import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_validation.dart';

const _kAccount = 'auth_account_v1';
const _kSignedIn = 'auth_signed_in_v1';

class AuthError implements Exception {
  AuthError(this.message);
  final String message;
  @override
  String toString() => message;
}

/// The account stored on THIS device. The password is never stored, only a
/// salted, stretched hash. This is a local login: it keeps casual users out
/// of the app, it is not server-side authentication.
class AuthAccount {
  const AuthAccount({
    required this.username,
    required this.identifier,
    required this.salt,
    required this.hash,
    required this.age,
    required this.createdAt,
  });

  final String username;
  final String identifier; // normalized email or phone
  final String salt;
  final String hash;
  final int age;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'username': username,
        'identifier': identifier,
        'salt': salt,
        'hash': hash,
        'age': age,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AuthAccount.fromJson(Map<String, dynamic> j) => AuthAccount(
        username: j['username'] as String,
        identifier: j['identifier'] as String,
        salt: j['salt'] as String,
        hash: j['hash'] as String,
        age: (j['age'] as num).toInt(),
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}

class AuthState {
  const AuthState({this.loaded = false, this.account, this.signedIn = false});
  final bool loaded;
  final AuthAccount? account;
  final bool signedIn;
}

/// Salted SHA-256, repeated 10,000 times so guessing is slower.
String hashPassword(String password, String salt) {
  final saltBytes = utf8.encode(salt);
  var digest = sha256.convert([...saltBytes, ...utf8.encode(password)]);
  for (var i = 0; i < 10000; i++) {
    digest = sha256.convert([...digest.bytes, ...saltBytes]);
  }
  return digest.toString();
}

String _newSalt() {
  final r = Random.secure();
  return base64UrlEncode(List<int>.generate(16, (_) => r.nextInt(256)));
}

bool _sameHash(String a, String b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return diff == 0;
}

class AuthNotifier extends Notifier<AuthState> {
  /// Completes when the stored account has been read (used by tests).
  Future<void> ready = Future.value();

  @override
  AuthState build() {
    ready = _load();
    return const AuthState();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    AuthAccount? account;
    final raw = p.getString(_kAccount);
    if (raw != null) {
      try {
        account = AuthAccount.fromJson((jsonDecode(raw) as Map).cast<String, dynamic>());
      } catch (_) {
        account = null;
      }
    }
    final signedIn = account != null && (p.getBool(_kSignedIn) ?? false);
    state = AuthState(loaded: true, account: account, signedIn: signedIn);
  }

  Future<void> signUp({
    required String identifier,
    required String username,
    required String password,
    required String confirm,
    required int age,
  }) async {
    await ready;
    final error = AuthValidation.identifier(identifier) ??
        AuthValidation.username(username) ??
        AuthValidation.password(password) ??
        AuthValidation.confirm(password, confirm) ??
        AuthValidation.age(age);
    if (error != null) throw AuthError(error);
    if (state.account != null) {
      throw AuthError('An account already exists on this device. Log in instead.');
    }
    final salt = _newSalt();
    final account = AuthAccount(
      username: username.trim(),
      identifier: AuthValidation.normalizeIdentifier(identifier),
      salt: salt,
      hash: hashPassword(password, salt),
      age: age,
      createdAt: DateTime.now(),
    );
    final p = await SharedPreferences.getInstance();
    await p.setString(_kAccount, jsonEncode(account.toJson()));
    await p.setBool(_kSignedIn, true);
    state = AuthState(loaded: true, account: account, signedIn: true);
  }

  /// [login] is the username, or the email / phone used at sign-up.
  Future<void> signIn(String login, String password) async {
    await ready;
    final a = state.account;
    final l = login.trim();
    final matches = a != null &&
        l.isNotEmpty &&
        (a.username.toLowerCase() == l.toLowerCase() ||
            a.identifier == AuthValidation.normalizeIdentifier(l));
    // Same message for every failure, so it does not reveal what exists.
    if (!matches || !_sameHash(hashPassword(password, a.salt), a.hash)) {
      throw AuthError('Wrong username or password.');
    }
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kSignedIn, true);
    state = AuthState(loaded: true, account: a, signedIn: true);
  }

  Future<void> signOut() async {
    await ready;
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kSignedIn, false);
    state = AuthState(loaded: true, account: state.account, signedIn: false);
  }

  /// Removes the login from this device. Accounts, games and statistics are
  /// NOT touched (they are stored separately).
  Future<void> resetLocalAccount() async {
    await ready;
    final p = await SharedPreferences.getInstance();
    await p.remove(_kAccount);
    await p.remove(_kSignedIn);
    state = const AuthState(loaded: true);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
