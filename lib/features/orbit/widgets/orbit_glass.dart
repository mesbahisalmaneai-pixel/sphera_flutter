import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../core/l10n.dart';

import '../models/orbit_destination.dart';
import '../orbit_insights.dart';
import 'planet_painters.dart' show OrbitPalette;

/// Text styles of the Orbit screen. Set [family] once to change the font
/// everywhere (the reference design uses a wide geometric display face such as
/// Orbitron: add it under `fonts:` in pubspec.yaml, then put its name here).
class OrbitText {
  OrbitText._();

  static const String? family = null;

  static TextStyle label({double size = 11, Color? color, FontWeight weight = FontWeight.w500}) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        color: color ?? OrbitPalette.muted,
        fontWeight: weight,
        letterSpacing: 0.3,
        height: 1.25,
      );

  static TextStyle value({double size = 15, Color? color, FontWeight weight = FontWeight.w600}) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        color: color ?? OrbitPalette.text,
        fontWeight: weight,
        letterSpacing: 0.2,
        height: 1.2,
      );
}

const Color _edge = Color(0x33F1DFA6);

/// Frosted glass panel. Pass [onTap] to make the whole panel pressable
/// (the ripple is painted inside the glass, not behind it).
class OrbitGlass extends StatelessWidget {
  const OrbitGlass({
    super.key,
    required this.child,
    this.radius = 22,
    this.padding = EdgeInsets.zero,
    this.blur = 16,
    this.fill,
    this.borderColor,
    this.topOnly = false,
    this.onTap,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double blur;
  final Gradient? fill;
  final Color? borderColor;
  final bool topOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final br = topOnly
        ? BorderRadius.vertical(top: Radius.circular(radius))
        : BorderRadius.circular(radius);
    Widget body = Padding(padding: padding, child: child);
    if (onTap != null) {
      body = Material(
        type: MaterialType.transparency,
        child: InkWell(onTap: onTap, child: body),
      );
    }
    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter.grouped(
        filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: br,
            gradient: fill ??
                const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0x33FFF1BD), Color(0x14FFFFFF)],
                ),
            border: Border.all(color: borderColor ?? _edge),
          ),
          child: body,
        ),
      ),
    );
  }
}

/// The dark glass used by bottom sheets.
const LinearGradient kOrbitSheetFill = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xE61C150A), Color(0xF2070504)],
);

/// Square glass icon button (menu, settings, bell).
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 44,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(14);
    return Semantics(
      button: true,
      label: tooltip,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: Ink(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: br,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x40FFF1BD), Color(0x14FFFFFF)],
              ),
              border: Border.all(color: _edge),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: br,
              child: Icon(icon, color: OrbitPalette.champagne, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

/// The glowing outlined "Explore" button.
class GlowButton extends StatelessWidget {
  const GlowButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: const Color(0x73000000),
              border: Border.all(color: OrbitPalette.gold, width: 1.4),
              boxShadow: [
                BoxShadow(color: OrbitPalette.gold.withValues(alpha: 0.45), blurRadius: 20),
                BoxShadow(color: OrbitPalette.champagne.withValues(alpha: 0.22), blurRadius: 4),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              customBorder: const StadiumBorder(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                child: Text(
                  label,
                  style: OrbitText.value(size: 15, color: OrbitPalette.champagne)
                      .copyWith(letterSpacing: 2.6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _roundButton(IconData icon, String tooltip, VoidCallback onTap) {
  return Semantics(
    button: true,
    label: tooltip,
    child: ExcludeSemantics(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0x1FFFFFFF),
            border: Border.all(color: _edge),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Icon(icon, size: 20, color: OrbitPalette.text),
          ),
        ),
      ),
    ),
  );
}

/// The search bar of the reference ("Tell me what you want to know").
/// Here it is a real search over every screen of the app.
class OrbitSearchBar extends StatelessWidget {
  const OrbitSearchBar({
    super.key,
    required this.hint,
    required this.onTap,
    required this.onHelp,
    required this.onMenu,
  });

  final String hint;
  final VoidCallback onTap;
  final VoidCallback onHelp;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return OrbitGlass(
      radius: 28,
      blur: 14,
      fill: const LinearGradient(colors: [Color(0x2EFFF1BD), Color(0x12FFFFFF)]),
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x66000000),
                border: Border.all(color: OrbitPalette.gold.withValues(alpha: 0.8), width: 1.2),
              ),
              child: const Icon(Icons.auto_awesome, size: 19, color: OrbitPalette.champagne),
            ),
            Expanded(
              child: Semantics(
                button: true,
                label: appL10n.searchEveryScreen,
                child: ExcludeSemantics(
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: onTap,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            hint,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: OrbitText.label(size: 12.5, color: OrbitPalette.text),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _roundButton(Icons.help_outline_rounded, appL10n.howGlobeWorks, onHelp),
            const SizedBox(width: 8),
            _roundButton(Icons.apps_rounded, appL10n.allSections, onMenu),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

/// Rounded chip (the "Screens" / "Stats" tabs).
class GlassChip extends StatelessWidget {
  const GlassChip({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(14);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: br,
              color: selected ? OrbitPalette.gold.withValues(alpha: 0.22) : const Color(0x1FFFFFFF),
              border: Border.all(color: selected ? OrbitPalette.gold : _edge),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: br,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      label,
                      style: OrbitText.value(
                        size: 13,
                        color: selected ? OrbitPalette.champagne : OrbitPalette.text,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A dark brass tile with an icon: stands in for the photos of the reference.
class GoldTile extends StatelessWidget {
  const GoldTile({super.key, required this.icon, this.size = 64});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const RadialGradient(
          center: Alignment(-0.5, -0.6),
          radius: 1.1,
          colors: [Color(0xFF8A6A1E), Color(0xFF3A2B0C), Color(0xFF120D05)],
          stops: [0.0, 0.55, 1.0],
        ),
        border: Border.all(color: _edge),
      ),
      child: Icon(icon, size: size * 0.46, color: OrbitPalette.champagne),
    );
  }
}

/// Segmented ring gauge with a hatched centre (the two dials of the reference).
class RingGauge extends StatelessWidget {
  const RingGauge({super.key, required this.fraction, required this.label, this.size = 58});

  final double fraction;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final f = fraction.clamp(0.0, 1.0).toDouble();
    final pct = (f * 100).round();
    return Semantics(
      label: appL10n.percentSemantics(label, '$pct'),
      child: ExcludeSemantics(
        child: SizedBox(
          width: size + 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(size: Size.square(size), painter: _RingGaugePainter(f)),
                    Text('$pct%', style: OrbitText.value(size: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: OrbitText.label(size: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingGaugePainter extends CustomPainter {
  _RingGaugePainter(this.f);
  final double f;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final outer = size.shortestSide / 2 - 1;
    canvas.drawCircle(
      c,
      outer,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = OrbitPalette.champagne.withValues(alpha: 0.45),
    );

    const n = 24;
    final segR = outer - 6;
    final rect = Rect.fromCircle(center: c, radius: segR);
    final seg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    for (var i = 0; i < n; i++) {
      final a0 = -math.pi / 2 + i * 2 * math.pi / n;
      seg.color = (i + 0.5) / n <= f ? OrbitPalette.gold : const Color(0x24FFFFFF);
      canvas.drawArc(rect, a0, 2 * math.pi / n * 0.66, false, seg);
    }

    final inner = segR - 6;
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: c, radius: inner)));
    canvas.drawCircle(c, inner, Paint()..color = const Color(0x99000000));
    final hatch = Paint()
      ..strokeWidth = 1
      ..color = OrbitPalette.gold.withValues(alpha: 0.28);
    for (var d = -inner * 2; d < inner * 2; d += 5) {
      canvas.drawLine(Offset(c.dx + d - inner, c.dy + inner), Offset(c.dx + d + inner, c.dy - inner), hatch);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RingGaugePainter old) => old.f != f;
}

/// The round dial button (left of the gauges). Opens the section's main screen.
class OrbitDial extends StatelessWidget {
  const OrbitDial({super.key, required this.icon, required this.tooltip, required this.onTap, this.size = 60});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(size: Size.square(size), painter: _DialPainter()),
                Icon(icon, size: 22, color: OrbitPalette.champagne),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final rad = size.shortestSide / 2 - 4;
    canvas.drawCircle(c, rad, Paint()..color = const Color(0xCC000000));
    canvas.drawCircle(
      c,
      rad,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = OrbitPalette.gold.withValues(alpha: 0.85),
    );
    canvas.drawCircle(
      c,
      rad - 7,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = OrbitPalette.champagne.withValues(alpha: 0.3),
    );
    final tri = Paint()..color = OrbitPalette.gold;
    for (var k = 0; k < 4; k++) {
      final a = k * math.pi / 2;
      final dir = Offset(math.cos(a), math.sin(a));
      final perp = Offset(-dir.dy, dir.dx);
      final path = Path()
        ..moveTo(c.dx + dir.dx * (rad + 3.5), c.dy + dir.dy * (rad + 3.5))
        ..lineTo(c.dx + dir.dx * (rad - 1) + perp.dx * 3.5, c.dy + dir.dy * (rad - 1) + perp.dy * 3.5)
        ..lineTo(c.dx + dir.dx * (rad - 1) - perp.dx * 3.5, c.dy + dir.dy * (rad - 1) - perp.dy * 3.5)
        ..close();
      canvas.drawPath(path, tri);
    }
  }

  @override
  bool shouldRepaint(_DialPainter old) => false;
}

/// "Label ━━━━━ value" row (the "Energy 100" row of the reference).
class MetricBar extends StatelessWidget {
  const MetricBar({super.key, required this.bar});

  final OrbitBar bar;

  @override
  Widget build(BuildContext context) {
    final f = bar.fraction.clamp(0.0, 1.0).toDouble();
    return Semantics(
      label: '${bar.label}: ${bar.value}',
      child: ExcludeSemantics(
        child: SizedBox(
          height: 34,
          child: Row(
            children: [
              SizedBox(
                width: 112,
                child: Text(bar.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: OrbitText.label(size: 12, color: OrbitPalette.text)),
              ),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0x1FFFFFFF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: f,
                    child: Container(
                      decoration: BoxDecoration(
                        color: OrbitPalette.gold,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [BoxShadow(color: OrbitPalette.gold.withValues(alpha: 0.6), blurRadius: 6)],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 64,
                child: Text(
                  bar.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: OrbitText.value(size: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card of the Insights row.
class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.insight, required this.onTap, this.width = 168, this.height = 132});

  final OrbitInsight insight;
  final VoidCallback onTap;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${insight.label}. ${insight.value}. ${insight.caption}',
      child: ExcludeSemantics(
        child: SizedBox(
          width: width,
          height: height,
          child: OrbitGlass(
            radius: 20,
            blur: 12,
            padding: const EdgeInsets.all(10),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GoldTile(icon: insight.icon, size: 38),
                    const Spacer(),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0x26FFFFFF),
                        border: Border.all(color: _edge),
                      ),
                      child: const Icon(Icons.north_east_rounded, size: 16, color: OrbitPalette.champagne),
                    ),
                  ],
                ),
                const Spacer(),
                Text(insight.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: OrbitText.label(size: 10.5)),
                const SizedBox(height: 1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(insight.value, style: OrbitText.value(size: 15)),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(insight.captionIcon, size: 13, color: OrbitPalette.gold),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        insight.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: OrbitText.label(size: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A screen of the open section (the "ORBIT-258 / Active" card of the reference).
class DestinationCard extends StatelessWidget {
  const DestinationCard({super.key, required this.dest, required this.selected, required this.onTap});

  final OrbitDestination dest;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${dest.title}. ${dest.description}',
      child: ExcludeSemantics(
        child: SizedBox(
          height: 104,
          child: OrbitGlass(
            radius: 20,
            blur: 10,
            padding: const EdgeInsets.all(10),
            onTap: onTap,
            borderColor: selected ? OrbitPalette.gold : null,
            fill: const LinearGradient(colors: [Color(0x26FFF1BD), Color(0x0FFFFFFF)]),
            child: Row(
              children: [
                GoldTile(icon: dest.icon, size: 80),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(dest.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: OrbitText.value(size: 14)),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0x26FFFFFF),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: OrbitPalette.gold),
                                ),
                                const SizedBox(width: 5),
                                Text(appL10n.open, style: OrbitText.label(size: 10, color: OrbitPalette.text)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dest.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: OrbitText.label(size: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
