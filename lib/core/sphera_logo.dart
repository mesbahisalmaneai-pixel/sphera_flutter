import 'package:flutter/material.dart';
import 'theme.dart';

/// Original SPHERA logo (assets/images/sphera_logo.png, white on transparent).
/// Extracted from the supplied screenshot; replace the PNG with a
/// higher-resolution original when available (aspect ratio 285 x 321).
class SpheraLogo extends StatelessWidget {
  const SpheraLogo({super.key, this.height = 64});
  final double height;

  @override
  Widget build(BuildContext context) => ColorFiltered(
        colorFilter: ColorFilter.mode(SpheraColors.ivory, BlendMode.srcIn),
        child: Image.asset('assets/images/sphera_logo.png', height: height, fit: BoxFit.contain),
      );
}

/// Reveals the logo bottom -> top: left half first, then the right half.
class SpheraLogoReveal extends StatelessWidget {
  const SpheraLogoReveal({super.key, required this.progress, this.height = 160});

  /// 0..1 over the whole animation.
  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    final width = height * 285 / 321;
    final left = Curves.easeInOutCubic.transform((progress / 0.55).clamp(0.0, 1.0));
    final right = Curves.easeInOutCubic.transform(((progress - 0.45) / 0.55).clamp(0.0, 1.0));
    return SizedBox(
      width: width,
      height: height,
      child: Stack(children: [
        ClipRect(clipper: _RevealClipper(left, true), child: SpheraLogo(height: height)),
        ClipRect(clipper: _RevealClipper(right, false), child: SpheraLogo(height: height)),
      ]),
    );
  }
}

class _RevealClipper extends CustomClipper<Rect> {
  _RevealClipper(this.t, this.isLeft);
  final double t;
  final bool isLeft;

  @override
  Rect getClip(Size size) {
    final x0 = isLeft ? 0.0 : size.width / 2;
    final x1 = isLeft ? size.width / 2 : size.width;
    return Rect.fromLTRB(x0, size.height * (1 - t), x1, size.height);
  }

  @override
  bool shouldReclip(_RevealClipper old) => old.t != t;
}
