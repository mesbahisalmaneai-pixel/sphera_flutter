import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/format.dart' show amountsInRtl;
import 'core/l10n.dart';
import 'core/theme.dart';
import 'core/sphera_logo.dart';
import 'data/phone_notifications.dart';
import 'data/settings.dart';

import 'features/auth/auth_gate.dart';
import 'features/earth/earth_scene.dart' show EarthModel;
import 'features/google/google_accounts_screen.dart';
import 'features/games/games_screen.dart';
import 'features/stats/statistics_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/arena/arena_screen.dart';
import 'features/achievements/achievements_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SpheraApp(),
    ),
  );
  // Started after the first frame is scheduled so the splash shows at once.
  // Phone notifications: no-op on desktop/web, never throws.
  unawaited(PhoneNotifications.instance.init());
  // Builds the dotted Earth of the Orbit tab in the background during the
  // splash, so opening that tab does not freeze.
  unawaited(EarthModel.warmUp());
}

class SpheraApp extends ConsumerWidget {
  const SpheraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final look = ref.watch(appearanceProvider);
    final lang = ref.watch(languageProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPHERA',
      // Settings > Language. Arabic also turns the layout right-to-left.
      locale: Locale(lang),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      themeMode: switch (look.mode) {
        ThemeModeSetting.dark => ThemeMode.dark,
        ThemeModeSetting.light => ThemeMode.light,
        ThemeModeSetting.system => ThemeMode.system,
      },
      theme: buildSpheraTheme(style: look.style, dark: false),
      darkTheme: buildSpheraTheme(style: look.style, dark: true),
      // Keep the static SpheraColors in sync with the active theme.
      builder: (context, child) {
        final platformDark =
            MediaQuery.platformBrightnessOf(context) == Brightness.dark;
        final dark = switch (look.mode) {
          ThemeModeSetting.dark => true,
          ThemeModeSetting.light => false,
          ThemeModeSetting.system => platformDark,
        };
        SpheraColors.apply(paletteFor(look.style, dark: dark));
        // Texts built outside widgets (labels, providers) follow the language.
        appL10n = context.l10n;
        // Amounts keep "+770 DH" order inside Arabic text.
        amountsInRtl = Directionality.of(context) == TextDirection.rtl;
        // Forces every widget below to rebuild when the palette or the
        // language changes (amount strings are built outside the widgets).
        return _ThemeRefresher(token: '${look.style}-$dark-$lang', child: child!);
      },
      // Named routes used by the cards in HomeScreen (pushNamed).
      routes: {
        '/google': (_) => const GoogleAccountsScreen(),
        '/games': (_) => const GamesScreen(),
        '/stats': (_) => const StatisticsScreen(),
        '/tools': (_) => const SettingsScreen(),
        '/arena': (_) => const ArenaScreen(),
        '/achievements': (_) => const AchievementsScreen(),
      },
      home: const SplashScreen(),
    );
  }
}

/// SpheraColors is static, so widgets that don't watch anything (const widgets,
/// screens already on the navigator stack) would keep the old colours.
/// When [token] changes, this marks the whole subtree dirty after the frame.
class _ThemeRefresher extends StatefulWidget {
  const _ThemeRefresher({required this.token, required this.child});
  final String token;
  final Widget child;

  @override
  State<_ThemeRefresher> createState() => _ThemeRefresherState();
}

class _ThemeRefresherState extends State<_ThemeRefresher> {
  @override
  void didUpdateWidget(covariant _ThemeRefresher old) {
    super.didUpdateWidget(old);
    if (old.token != widget.token) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        void rebuild(Element e) {
          e.markNeedsBuild();
          e.visitChildren(rebuild);
        }

        (context as Element).visitChildren(rebuild);
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _flashController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _flashAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();

  final String _fullText = 'SPHERA';
  String _currentText = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      // Was 6 s. The letters, flash and progress bar all scale with it.
      duration: const Duration(milliseconds: 2800),
      vsync: this,
    );

    _flashController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _flashAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(
      CurvedAnimation(
        parent: _flashController,
        curve: Curves.easeInOut,
      ),
    );

    _playSound();

    _controller.addListener(() {
      if (!mounted) return;

      final letterCount = (_controller.value * _fullText.length)
          .floor()
          .clamp(0, _fullText.length);

      if (_currentText != _fullText.substring(0, letterCount)) {
        setState(() {
          _currentText = _fullText.substring(0, letterCount);
        });
      }

      if (_controller.value > 0.8 &&
          !_flashController.isAnimating &&
          !_flashController.isCompleted) {
        _flashController.forward();
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const AuthGate(),
          ),
        );
      }
    });

    _controller.forward();
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(
        AssetSource('sounds/splash_sound.mp3'),
      );
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _flashController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theme-aware colours (follow the selected style + dark/light mode).
    final ivory = SpheraColors.ivory;
    final shine = SpheraColors.muted;

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpheraLogo(height: 110),
              const SizedBox(height: 30),
              AnimatedBuilder(
                animation: _flashAnimation,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [ivory, shine, ivory],
                        stops: [
                          (_flashAnimation.value - 0.3).clamp(0.0, 1.0),
                          _flashAnimation.value.clamp(0.0, 1.0),
                          (_flashAnimation.value + 0.3).clamp(0.0, 1.0),
                        ],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      _currentText,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        color: ivory,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _controller.value,
                        backgroundColor: SpheraColors.surfaceHigh,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(SpheraColors.gold),
                        minHeight: 6,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                '© 2026 — SPHERA',
                style: TextStyle(
                  fontSize: 12,
                  color: SpheraColors.muted,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
