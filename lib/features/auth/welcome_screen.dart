import 'package:flutter/material.dart';

import '../../core/sphera_logo.dart';
import 'auth_widgets.dart';
import 'forgot_password_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

/// "HELLO!" - entry point for new and returning users.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _open(BuildContext context, Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      trailing: AuthIconButton(
        icon: Icons.help_outline,
        tooltip: 'Help',
        onPressed: () => showAuthHelp(context),
      ),
      footer: const AuthBrandFooter(),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SpheraLogo(height: 190),
        const SizedBox(height: 22),
        const AuthTitle('HELLO!'),
        const SizedBox(height: 34),
        PillButton(label: 'Create a new account', onPressed: () => _open(context, const SignUpScreen())),
        const SizedBox(height: 14),
        PillButton(label: 'I have an existing account', onPressed: () => _open(context, const LoginScreen())),
        const SizedBox(height: 14),
        AuthLink('I have a problem in login & password', onTap: () => _open(context, const ForgotPasswordScreen())),
      ]),
    );
  }
}
