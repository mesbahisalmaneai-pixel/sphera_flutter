import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sphera_logo.dart';
import '../../core/theme.dart';
import '../../data/auth/auth_repository.dart';
import '../../data/settings.dart';
import 'auth_widgets.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _user = TextEditingController();
  final _password = TextEditingController();
  bool _show = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _user.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_user.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _error = 'Enter your username and password.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authProvider.notifier).signIn(_user.text, _password.text);
      if (!mounted) return;
      Navigator.of(context).popUntil((r) => r.isFirst);
    } on AuthError catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _languageSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Consumer(builder: (ctx, ref, _) {
        final current = ref.watch(languageProvider);
        return SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Language', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            for (final e in kLanguages.entries)
              ListTile(
                title: Text(e.value),
                trailing: e.key == current ? Icon(Icons.check, color: SpheraColors.gold) : null,
                onTap: () {
                  ref.read(languageProvider.notifier).set(e.key);
                  Navigator.pop(ctx);
                },
              ),
          ]),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      leading: AuthIconButton(icon: Icons.settings, tooltip: 'Language', onPressed: _languageSheet),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SpheraLogo(height: 170),
        const SizedBox(height: 22),
        const AuthTitle('WELCOME!'),
        const SizedBox(height: 28),
        PillField(
          controller: _user,
          hint: 'username',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        PillField(
          controller: _password,
          hint: 'password',
          obscure: !_show,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _login(),
          trailing: IconButton(
            icon: Icon(_show ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: SpheraColors.muted, size: 20),
            onPressed: () => setState(() => _show = !_show),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: AuthLink(
            'you forgot your password?',
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen())),
          ),
        ),
        AuthErrorText(_error),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: PillButton(label: 'Login', onPressed: _login, loading: _busy, width: 130),
        ),
      ]),
    );
  }
}
