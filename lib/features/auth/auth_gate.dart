import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth/auth_repository.dart';
import '../shell/main_shell.dart';
import 'welcome_screen.dart';

/// Decides what the user sees after the splash: the app when signed in,
/// otherwise the Welcome screen. Auth screens are pushed on top of this and
/// pop back to it when they succeed.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(authProvider);
    if (!a.loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return a.signedIn ? const MainShell() : const WelcomeScreen();
  }
}
