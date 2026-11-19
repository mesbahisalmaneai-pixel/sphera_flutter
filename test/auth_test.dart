import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sphera_flutter/data/auth/auth_repository.dart';
import 'package:sphera_flutter/data/auth/auth_validation.dart';

void main() {
  group('validation', () {
    test('identifier accepts emails and phone numbers only', () {
      expect(AuthValidation.identifier('a@b.com'), isNull);
      expect(AuthValidation.identifier('+212 6 12-34-56-78'), isNull);
      expect(AuthValidation.identifier('0612345678'), isNull);
      expect(AuthValidation.identifier(''), isNotNull);
      expect(AuthValidation.identifier('not an email'), isNotNull);
      expect(AuthValidation.identifier('12345'), isNotNull);
    });

    test('identifier normalization', () {
      expect(AuthValidation.normalizeIdentifier(' Me@Mail.COM '), 'me@mail.com');
      expect(AuthValidation.normalizeIdentifier('+212 6 12-34-56-78'), '+212612345678');
    });

    test('username rules', () {
      expect(AuthValidation.username('sphera_01'), isNull);
      expect(AuthValidation.username('ab'), isNotNull);
      expect(AuthValidation.username('has space'), isNotNull);
      expect(AuthValidation.username('a' * 21), isNotNull);
    });

    test('password rules and confirmation', () {
      expect(AuthValidation.password('abc12345'), isNull);
      expect(AuthValidation.password('short1'), isNotNull);
      expect(AuthValidation.password('onlyletters'), isNotNull);
      expect(AuthValidation.password('12345678'), isNotNull);
      expect(AuthValidation.confirm('abc12345', 'abc12345'), isNull);
      expect(AuthValidation.confirm('abc12345', 'abc12346'), isNotNull);
      expect(AuthValidation.confirm('abc12345', ''), isNotNull);
    });

    test('age limits', () {
      expect(AuthValidation.age(kMinAge), isNull);
      expect(AuthValidation.age(kMinAge - 1), isNotNull);
      expect(AuthValidation.age(kMaxAge + 1), isNotNull);
    });
  });

  group('local account', () {
    late ProviderContainer c;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      c = ProviderContainer();
    });
    tearDown(() => c.dispose());

    AuthNotifier auth() => c.read(authProvider.notifier);

    Future<void> signUp({String password = 'abc12345', String confirm = 'abc12345', int age = 20}) =>
        auth().signUp(identifier: 'me@mail.com', username: 'Sphera1', password: password, confirm: confirm, age: age);

    test('sign up logs in, never stores the plain password', () async {
      await signUp();
      expect(c.read(authProvider).signedIn, isTrue);
      final raw = (await SharedPreferences.getInstance()).getString('auth_account_v1')!;
      expect(raw.contains('abc12345'), isFalse);
    });

    test('sign up rejects invalid input and a second account', () async {
      expect(() => signUp(confirm: 'different1'), throwsA(isA<AuthError>()));
      expect(() => signUp(age: 10), throwsA(isA<AuthError>()));
      await signUp();
      expect(() => signUp(), throwsA(isA<AuthError>()));
    });

    test('sign in by username or email; wrong password fails with one message', () async {
      await signUp();
      await auth().signOut();
      expect(c.read(authProvider).signedIn, isFalse);

      await expectLater(auth().signIn('sphera1', 'wrong-pass1'), throwsA(isA<AuthError>()));
      await expectLater(auth().signIn('nobody', 'abc12345'), throwsA(isA<AuthError>()));
      await auth().signIn('SPHERA1', 'abc12345');
      expect(c.read(authProvider).signedIn, isTrue);

      await auth().signOut();
      await auth().signIn('Me@Mail.com', 'abc12345');
      expect(c.read(authProvider).signedIn, isTrue);
    });

    test('session survives a restart; reset removes the login', () async {
      await signUp();
      final c2 = ProviderContainer();
      addTearDown(c2.dispose);
      await c2.read(authProvider.notifier).ready;
      expect(c2.read(authProvider).signedIn, isTrue);

      await c2.read(authProvider.notifier).resetLocalAccount();
      expect(c2.read(authProvider).account, isNull);
      expect(c2.read(authProvider).signedIn, isFalse);
      // A new login can be created afterwards (on the container that was reset).
      await c2.read(authProvider.notifier).signUp(
            identifier: 'me@mail.com',
            username: 'Sphera1',
            password: 'abc12345',
            confirm: 'abc12345',
            age: 20,
          );
      expect(c2.read(authProvider).signedIn, isTrue);
    });
  });
}
