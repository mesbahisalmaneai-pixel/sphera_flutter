import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sphera_logo.dart';
import '../../data/auth/auth_repository.dart';
import '../../data/auth/auth_validation.dart';
import 'auth_widgets.dart';
import 'signup_screen.dart';

/// "Oops!" - password help.
///
/// Sending a verification code by email/SMS needs an online service that is
/// not connected yet, so this screen offers the one recovery that works on a
/// device-only account: resetting the login on this device (data is kept).
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _id = TextEditingController();
  final _code = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _id.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _explain() async {
    final idError = AuthValidation.identifier(_id.text);
    if (idError != null) {
      setState(() => _error = idError);
      return;
    }
    setState(() => _error = null);
    final reset = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Verification is not available yet'),
        content: const Text(
          'Codes by email or SMS need an online service, which is not connected to SPHERA yet.\n\n'
          'You can reset the login on this device instead and create a new one. '
          'Your accounts, games and statistics are kept.\n\n'
          'This login only protects casual access to the app on this device.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Reset login')),
        ],
      ),
    );
    if (reset != true || !mounted) return;
    final nav = Navigator.of(context);
    await ref.read(authProvider.notifier).resetLocalAccount();
    nav.popUntil((r) => r.isFirst);
    nav.push(MaterialPageRoute<void>(builder: (_) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      leading: AuthIconButton(
        icon: Icons.arrow_back,
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      trailing: AuthIconButton(
        icon: Icons.help_outline,
        tooltip: 'Help',
        onPressed: () => showAuthHelp(context),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SpheraLogo(height: 170),
        const SizedBox(height: 22),
        const AuthTitle('Oops!'),
        const SizedBox(height: 28),
        PillField(
          controller: _id,
          hint: 'email or phone number',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        PillField(
          controller: _code,
          hint: 'validation code',
          keyboardType: TextInputType.number,
          maxLength: 6,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _explain(),
        ),
        AuthErrorText(_error),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerRight,
          child: PillButton(label: 'Login', onPressed: _explain, width: 130),
        ),
        const SizedBox(height: 6),
        AuthLink("I didn't receive the verification code", onTap: _explain),
      ]),
    );
  }
}
