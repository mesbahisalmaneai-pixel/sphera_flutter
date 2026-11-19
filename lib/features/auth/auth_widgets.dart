import 'package:flutter/material.dart';

import '../../core/sphera_logo.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';

/// Shared layout of the Welcome / Sign up / Login / Forgot password screens:
/// optional top-left and top-right actions, centred content that fades in,
/// and a footer. Scrolls on small phones.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child, this.leading, this.trailing, this.footer});

  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    return Scaffold(
      backgroundColor: SpheraColors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(children: [
                      leading ?? const SizedBox(height: 48),
                      const Spacer(),
                      trailing ?? const SizedBox.shrink(),
                    ]),
                  ),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        child: reduce
                            ? child
                            : TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                                builder: (context, t, w) => Opacity(
                                  opacity: t,
                                  child: Transform.translate(offset: Offset(0, 14 * (1 - t)), child: w),
                                ),
                                child: child,
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 8),
                    child: footer ?? const AuthCopyright(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCopyright extends StatelessWidget {
  const AuthCopyright({super.key});

  @override
  Widget build(BuildContext context) => Text(
        '\u00A9 ${DateTime.now().year} \u2014 SPHERA',
        style: TextStyle(color: SpheraColors.muted, fontSize: 11),
      );
}

/// Logo + wordmark footer used on the Welcome screen.
class AuthBrandFooter extends StatelessWidget {
  const AuthBrandFooter({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpheraLogo(height: 20),
          const SizedBox(width: 8),
          Text('SPHERA',
              style: TextStyle(color: SpheraColors.ivory, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 13)),
        ],
      );
}

class AuthIconButton extends StatelessWidget {
  const AuthIconButton({super.key, required this.icon, required this.tooltip, required this.onPressed});
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, color: SpheraColors.ivory, size: 26),
      );
}

/// Pill-shaped text field (white outline, gold when focused).
class PillField extends StatelessWidget {
  const PillField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.trailing,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
    this.maxLength,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final int? maxLength;

  OutlineInputBorder _border(Color c, [double w = 1.5]) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: c, width: w));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(color: SpheraColors.ivory),
      cursorColor: SpheraColors.gold,
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        hintStyle: TextStyle(color: SpheraColors.muted, fontSize: 14),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        suffixIcon: trailing,
        enabledBorder: _border(SpheraColors.ivory),
        focusedBorder: _border(SpheraColors.gold, 2),
        errorBorder: _border(SpheraColors.danger),
        focusedErrorBorder: _border(SpheraColors.danger, 2),
        errorStyle: const TextStyle(color: SpheraColors.danger, fontSize: 11),
      ),
    );
  }
}

/// White pill button (black text); shows a spinner while [loading].
class PillButton extends StatelessWidget {
  const PillButton({super.key, required this.label, required this.onPressed, this.loading = false, this.width});
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: SpheraColors.ivory,
          foregroundColor: SpheraColors.black,
          disabledBackgroundColor: SpheraColors.ivory.withValues(alpha: 0.5),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        child: loading
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: SpheraColors.black))
            : Text(label),
      ),
    );
  }
}

/// Small underlined link.
class AuthLink extends StatelessWidget {
  const AuthLink(this.text, {super.key, required this.onTap, this.gold = false});
  final String text;
  final VoidCallback onTap;
  final bool gold;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Text(
            text,
            style: TextStyle(
              color: gold ? SpheraColors.gold : SpheraColors.ivory,
              fontSize: 12,
              decoration: TextDecoration.underline,
              decorationColor: gold ? SpheraColors.gold : SpheraColors.ivory,
            ),
          ),
        ),
      );
}

class AuthTitle extends StatelessWidget {
  const AuthTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: SpheraColors.ivory, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      );
}

Future<void> showAuthHelp(BuildContext context) => showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.authNeedHelp),
        content: Text(context.l10n.authHelpBody),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.gotIt))],
      ),
    );

class AuthErrorText extends StatelessWidget {
  const AuthErrorText(this.message, {super.key});
  final String? message;

  @override
  Widget build(BuildContext context) => message == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(message!, textAlign: TextAlign.center, style: const TextStyle(color: SpheraColors.danger, fontSize: 12)),
        );
}
