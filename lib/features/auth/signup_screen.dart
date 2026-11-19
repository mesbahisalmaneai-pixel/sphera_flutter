import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sphera_logo.dart';
import '../../core/theme.dart';
import '../../data/auth/auth_repository.dart';
import '../../data/auth/auth_validation.dart';
import '../../data/profile.dart';
import 'auth_widgets.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  int _age = 18;
  bool _confirmed = false;
  bool _checkError = false;
  bool _showPassword = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_id, _username, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final err = await ref.read(profileProvider.notifier).pickPhoto();
    if (err != null && mounted) setState(() => _error = err);
  }

  Future<void> _submit() async {
    final formOk = _form.currentState!.validate();
    final ageError = AuthValidation.age(_age);
    setState(() {
      _checkError = !_confirmed;
      _error = ageError;
    });
    if (!formOk || ageError != null || !_confirmed) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authProvider.notifier).signUp(
            identifier: _id.text,
            username: _username.text,
            password: _password.text,
            confirm: _confirm.text,
            age: _age,
          );
      final id = AuthValidation.normalizeIdentifier(_id.text);
      await ref.read(profileProvider.notifier).setInfo(_username.text.trim(), id.contains('@') ? id : '');
      if (!mounted) return;
      Navigator.of(context).popUntil((r) => r.isFirst);
    } on AuthError catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _eye() => IconButton(
        icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: SpheraColors.muted, size: 20),
        onPressed: () => setState(() => _showPassword = !_showPassword),
      );

  @override
  Widget build(BuildContext context) {
    final photo = ref.watch(profileProvider).photoPath;
    return AuthScaffold(
      leading: AuthIconButton(
        icon: Icons.arrow_back,
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      child: Form(
        key: _form,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SpheraLogo(height: 56),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _pickPhoto,
            child: Stack(children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: SpheraColors.surfaceHigh,
                backgroundImage: photo == null ? null : FileImage(File(photo)),
                child: photo == null ? Icon(Icons.person_outline, size: 46, color: SpheraColors.ivory) : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: SpheraColors.gold,
                  child: Icon(Icons.add_a_photo_outlined, size: 15, color: SpheraColors.black),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 4),
          Text('Profile photo (optional)', style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
          const SizedBox(height: 14),
          PillField(
            controller: _id,
            hint: 'email or phone number',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: AuthValidation.identifier,
          ),
          const SizedBox(height: 12),
          PillField(
            controller: _username,
            hint: 'choose a username',
            textInputAction: TextInputAction.next,
            maxLength: 20,
            validator: AuthValidation.username,
          ),
          const SizedBox(height: 12),
          PillField(
            controller: _password,
            hint: 'create a password',
            obscure: !_showPassword,
            trailing: _eye(),
            textInputAction: TextInputAction.next,
            validator: AuthValidation.password,
          ),
          const SizedBox(height: 12),
          PillField(
            controller: _confirm,
            hint: 'confirm your password',
            obscure: !_showPassword,
            textInputAction: TextInputAction.done,
            validator: (v) => AuthValidation.confirm(_password.text, v),
          ),
          const SizedBox(height: 12),
          _AgeField(value: _age, onChanged: (v) => setState(() => _age = v)),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => setState(() {
              _confirmed = !_confirmed;
              _checkError = false;
            }),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Checkbox(
                value: _confirmed,
                activeColor: SpheraColors.gold,
                checkColor: SpheraColors.black,
                side: BorderSide(color: _checkError ? SpheraColors.danger : SpheraColors.ivory, width: 1.5),
                onChanged: (v) => setState(() {
                  _confirmed = v ?? false;
                  _checkError = false;
                }),
              ),
              Flexible(
                child: Text('I confirm my information is correct',
                    style: TextStyle(
                        color: _checkError ? SpheraColors.danger : SpheraColors.ivory, fontSize: 12)),
              ),
            ]),
          ),
          AuthErrorText(_error),
          const SizedBox(height: 10),
          PillButton(label: 'Create account', onPressed: _submit, loading: _busy),
        ]),
      ),
    );
  }
}

class _AgeField extends StatelessWidget {
  const _AgeField({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: SpheraColors.ivory, width: 1.5),
      ),
      child: Row(children: [
        Text('your age', style: TextStyle(color: SpheraColors.muted, fontSize: 14)),
        const Spacer(),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: value > kMinAge ? () => onChanged(value - 1) : null,
          icon: Icon(Icons.remove_circle_outline, color: SpheraColors.ivory, size: 22),
        ),
        SizedBox(
          width: 34,
          child: Text('$value',
              textAlign: TextAlign.center,
              style: TextStyle(color: SpheraColors.ivory, fontWeight: FontWeight.w700, fontSize: 16)),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: value < kMaxAge ? () => onChanged(value + 1) : null,
          icon: Icon(Icons.add_circle_outline, color: SpheraColors.ivory, size: 22),
        ),
      ]),
    );
  }
}
