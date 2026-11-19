import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import 'planet_painters.dart';

/// Bottom navigation: Home | Stats | ORBIT | Cards | Profile.
/// The Orbit button is the golden globe with its ring (assets/images/orbit_globe.png),
/// slightly raised above the bar (the globe itself is the icon, no logo next to it).
class OrbitNavigationBar extends StatelessWidget {
  const OrbitNavigationBar({super.key, required this.index, required this.onChanged});

  /// 0 Home, 1 Stats, 2 Orbit, 3 Cards, 4 Profile.
  final int index;
  final ValueChanged<int> onChanged;

  static const double _barHeight = 64;
  static const double _lift = 16;
  static const double _iconSize = 58;

  Widget _item(int i, IconData icon, IconData selectedIcon, String label) {
    final selected = index == i;
    final color = selected ? SpheraColors.gold : SpheraColors.muted;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: ExcludeSemantics(
          child: InkResponse(
            onTap: () => onChanged(i),
            radius: 36,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(selected ? selectedIcon : icon, color: color, size: 24),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final orbitSelected = index == 2;

    return SizedBox(
      height: _barHeight + _lift + bottom,
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: _barHeight + bottom,
          // The bar is its own Material so the tap splashes are visible.
          child: Material(
            color: SpheraColors.surface,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: SpheraColors.border)),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child: Row(children: [
                  _item(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                  _item(1, Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Stats'),
                  const Expanded(child: SizedBox.shrink()),
                  _item(3, Icons.style_outlined, Icons.style_rounded, 'Cards'),
                  _item(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
                ]),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: _barHeight + _lift,
          child: Center(
            child: Semantics(
              button: true,
              selected: orbitSelected,
              label: 'Orbit',
              child: ExcludeSemantics(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(2),
                  child: SizedBox(
                    width: 84,
                    height: _barHeight + _lift,
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(end: orbitSelected ? 1.0 : 0.0),
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        builder: (context, glow, _) => Transform.scale(
                          scale: 1.0 + 0.06 * glow,
                          child: SizedBox(
                            width: _iconSize,
                            height: _iconSize,
                            child: Stack(alignment: Alignment.center, children: [
                              CustomPaint(size: const Size.square(_iconSize), painter: _GlowPainter(glow)),
                              Opacity(
                                opacity: 0.82 + 0.18 * glow,
                                child: Image.asset(
                                  'assets/images/orbit_globe.png',
                                  width: _iconSize,
                                  height: _iconSize,
                                  filterQuality: FilterQuality.high,
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Orbit',
                        style: TextStyle(
                          fontSize: 11,
                          color: orbitSelected ? SpheraColors.gold : SpheraColors.muted,
                          fontWeight: orbitSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

/// Soft gold glow behind the globe (stronger when the Orbit tab is selected).
class _GlowPainter extends CustomPainter {
  _GlowPainter(this.glow);
  final double glow; // 0..1

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width * 0.5;
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(colors: [
          OrbitPalette.gold.withValues(alpha: 0.10 + 0.30 * glow),
          OrbitPalette.gold.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: c, radius: r)),
    );
  }

  @override
  bool shouldRepaint(_GlowPainter old) => old.glow != glow;
}
