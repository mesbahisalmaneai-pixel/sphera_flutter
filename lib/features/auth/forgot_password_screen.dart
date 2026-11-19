import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n.dart';
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
    final idError = AuthValidation.identifier(_id.text, context.l10n);
    if (idError != null) {
      setState(() => _error = idError);
      return;
    }
    setState(() => _error = null);
    final reset = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.authVerifyUnavailableTitle),
        content: Text(context.l10n.authVerifyUnavailableBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(context.l10n.authResetLogin)),
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
        tooltip: context.l10n.back,
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      trailing: AuthIconButton(
        icon: Icons.help_outline,
        tooltip: context.l10n.help,
        onPressed: () => showAuthHelp(context),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SpheraLogo(height: 170),
        const SizedBox(height: 22),
        AuthTitle(context.l10n.authOops),
        const SizedBox(height: 28),
        PillField(
          controller: _id,
          hint: context.l10n.authHintEmailOrPhone,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        PillField(
          controller: _code,
          hint: context.l10n.authHintCode,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _explain(),
        ),
        AuthErrorText(_error),
        const SizedBox(height: 14),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: PillButton(label: context.l10n.authLogin, onPressed: _explain, width: 130),
        ),
        const SizedBox(height: 6),
        AuthLink(context.l10n.authNoCode, onTap: _explain),
      ]),
    );
  }
}
