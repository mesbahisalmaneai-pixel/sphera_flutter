
import 'package:flutter/material.dart';
import '../../core/sphera_logo.dart';
import '../../core/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..forward().whenComplete(() {
        if (mounted) widget.onDone();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final p = reduce ? 1.0 : _controller.value;

            // Reveal the original logo continuously.
            final logoProgress =
                Curves.easeInOutCubic.transform((p / 0.78).clamp(0.0, 1.0));

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 0.94 + (0.06 * logoProgress),
                  child: SpheraLogoReveal(
                    progress: logoProgress,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 28),

                // SPHERA fades in smoothly as the logo finishes.
                Opacity(
                  opacity: reduce
                      ? 1
                      : Curves.easeInOut.transform(
                          ((p - 0.52) / 0.35).clamp(0.0, 1.0),
                        ),
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      reduce
                          ? 0
                          : 8 *
                              (1 -
                                  ((p - 0.52) / 0.35)
                                      .clamp(0.0, 1.0)),
                    ),
                    child: Text(
                      'SPHERA',
                      style: TextStyle(
                        color: SpheraColors.gold,
                        fontSize: 22,
                        letterSpacing: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
