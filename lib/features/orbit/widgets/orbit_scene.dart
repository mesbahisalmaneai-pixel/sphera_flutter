import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/orbit_destination.dart';
import 'planet_painters.dart';

/// What the user tapped.
class OrbitHit {
  const OrbitHit.section(this.index) : isSection = true;
  const OrbitHit.feature(this.index) : isSection = false;
  final bool isSection;
  final int index;
}

class _Placement {
  const _Placement(this.index, this.center, this.scale, this.z, this.alpha);
  final int index;
  final Offset center;
  final double scale;
  final double z; // -1 (behind the planet) .. 1 (in front)
  final double alpha;
}

class _Layout {
  Offset center = Offset.zero;
  double r = 0;
  double tt = 0;
  double indR = 12;
  double featR = 28;
  List<_Placement> indicators = const [];
  List<_Placement> features = const [];
}

/// Owns everything needed to draw and hit-test the Orbit scene.
/// It is plain Dart (no widgets), so the scene is drawn in ONE canvas pass and
/// the widget tree is never rebuilt on an animation tick.
class OrbitRenderer {
  final MainPlanetModel _planet = MainPlanetModel();
  final StarField _stars = StarField();
  final Map<String, TextPainter> _tp = {};

  ui.Image? logo;
  List<OrbitSection> sections = const [];

  /// Section being explored (kept until the return animation ends).
  int? sectionIndex;

  /// Selected feature planet inside the section.
  int? selected;

  /// Loop position 0..1 (one loop = 120 s), transition 0..1, selection 0..1.
  double u = 0.08;
  double t = 0;
  double sel = 0;

  static const double _twoPi = 2 * math.pi;

  // ------------------------------------------------------------------ layout

  _Layout _layout(Size s) {
    final w = s.width, h = s.height;
    final tt = Curves.easeInOutCubic.transform(t.clamp(0.0, 1.0).toDouble());
    final r0 = math.min(w * 0.22, h * 0.20);
    final r1 = r0 * 0.80;
    final c0 = Offset(w / 2, h * 0.47);
    final c1 = Offset(w / 2, h * 0.36);

    final l = _Layout()
      ..tt = tt
      ..center = Offset.lerp(c0, c1, tt)!
      ..r = r0 + (r1 - r0) * tt
      ..featR = (w * 0.075).clamp(24.0, 31.0).toDouble();

    // Section indicators on a tilted orbit around the planet (overview).
    final n = sections.length;
    final aInd = math.min(r0 * 2.15, w / 2 - 30);
    const tiltI = 0.16;
    final cti = math.cos(tiltI), sti = math.sin(tiltI);
    final inds = <_Placement>[];
    for (var i = 0; i < n; i++) {
      final phi = _twoPi * i / n + u * _twoPi + 0.5;
      final lx = aInd * math.cos(phi), ly = aInd * 0.30 * math.sin(phi);
      final z = math.sin(phi);
      final k = (z + 1) / 2;
      inds.add(_Placement(
        i,
        l.center + Offset(lx * cti - ly * sti, lx * sti + ly * cti),
        0.84 + 0.26 * k,
        z,
        (1 - tt) * (0.60 + 0.40 * k),
      ));
    }
    l.indicators = inds;

    // Feature planets of the active section, on two layered orbits.
    final si = sectionIndex;
    if (si != null && si < sections.length && tt > 0) {
      final dests = sections[si].destinations;
      final m = dests.length;
      final n0 = (m + 1) ~/ 2;
      final n1 = m - n0;
      final aMax = w / 2 - 40;
      final a1 = math.min(aMax, r1 * 2.8);
      final a0 = a1 * 0.62;
      const tilt = -0.20;
      final ct = math.cos(tilt), st = math.sin(tilt);
      final feats = <_Placement>[];
      for (var j = 0; j < m; j++) {
        final orbit = j % 2;
        final idx = j ~/ 2;
        final count = orbit == 0 ? n0 : n1;
        final base = _twoPi * idx / math.max(1, count) + (orbit == 0 ? 0.6 : 0.6 + math.pi / math.max(1, count));
        final phi = base + (orbit == 0 ? 1 : -1) * u * _twoPi;
        final a = orbit == 0 ? a0 : a1;
        final b = a * (orbit == 0 ? 0.34 : 0.38);
        final lx = a * math.cos(phi), ly = b * math.sin(phi);
        final float = math.sin(u * _twoPi * 16 + j * 1.7) * 2.5;
        final target = l.center + Offset(lx * ct - ly * st, lx * st + ly * ct + float);

        final start = 0.10 + 0.5 * j / math.max(1, m);
        final ri = Curves.easeOutCubic.transform(((tt - start) / 0.4).clamp(0.0, 1.0).toDouble());
        final z = math.sin(phi);
        final k = (z + 1) / 2;
        var sc = (0.80 + 0.26 * k) * ri;
        if (selected == j) sc *= 1 + 0.22 * sel;
        feats.add(_Placement(
          j,
          Offset.lerp(l.center, target, ri)!,
          sc,
          z,
          ri * (0.70 + 0.30 * k) * (selected != null && selected != j ? 0.82 : 1.0),
        ));
      }
      l.features = feats;
    }
    return l;
  }

  /// Returns what is under [p], or null.
  OrbitHit? hitTest(Offset p, Size s) {
    final l = _layout(s);
    if (l.tt < 0.5) {
      OrbitHit? bestSection;
      var bestSectionZ = -9.0;
      for (final pl in l.indicators) {
        final rad = math.max(28.0, l.indR * pl.scale + 12);
        if ((p - pl.center).distance <= rad && pl.z > bestSectionZ) {
          bestSection = OrbitHit.section(pl.index);
          bestSectionZ = pl.z;
        }
      }
      return bestSection;
    }
    OrbitHit? best;
    var bz = -9.0;
    for (final pl in l.features) {
      if (pl.alpha < 0.45) continue;
      final rad = l.featR * pl.scale + 8;
      final z = pl.index == selected ? 9.0 : pl.z;
      if ((p - pl.center).distance <= rad && z > bz) {
        best = OrbitHit.feature(pl.index);
        bz = z;
      }
    }
    return best;
  }

  // ------------------------------------------------------------------- paint

  void paint(Canvas canvas, Size s) {
    final l = _layout(s);

    // Deep black space + a very restrained amber nebula behind the planet.
    canvas.drawRect(Offset.zero & s, Paint()..color = OrbitPalette.space);
    canvas.drawCircle(
      l.center,
      l.r * 3.2,
      Paint()
        ..shader = RadialGradient(colors: [
          OrbitPalette.amber.withValues(alpha: 0.10),
          OrbitPalette.amber.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: l.center, radius: l.r * 3.2)),
    );
    paintStars(canvas, s, _stars, u);

    final backInd = l.indicators.where((p) => p.z < 0 && p.alpha > 0.01).toList()
      ..sort((a, b) => a.z.compareTo(b.z));
    final frontInd = l.indicators.where((p) => p.z >= 0 && p.alpha > 0.01).toList()
      ..sort((a, b) => a.z.compareTo(b.z));
    final backFeat = l.features.where((p) => p.z < 0 && p.index != selected && p.scale > 0.02).toList()
      ..sort((a, b) => a.z.compareTo(b.z));
    final frontFeat = l.features.where((p) => p.z >= 0 && p.index != selected && p.scale > 0.02).toList()
      ..sort((a, b) => a.z.compareTo(b.z));

    // 1) everything BEHIND the planet
    for (final p in backInd) {
      _indicator(canvas, l, p);
    }
    for (final p in backFeat) {
      _feature(canvas, l, p, false);
    }

    // 2) rings (back half), planet, rings (front half)
    final ringAlpha = 1.0 - 0.4 * l.tt;
    paintRings(canvas, l.center, l.r, back: true, u: u, alpha: ringAlpha);
    paintMainPlanet(canvas, _planet, l.center, l.r,
        rot: u * _twoPi * 2, dim: 1.0 - 0.2 * l.tt, logo: logo);
    paintRings(canvas, l.center, l.r, back: false, u: u, alpha: ringAlpha);

    // 3) everything IN FRONT of the planet (selected planet always on top)
    for (final p in frontInd) {
      _indicator(canvas, l, p);
    }
    for (final p in frontFeat) {
      _feature(canvas, l, p, false);
    }
    for (final p in l.features) {
      if (p.index == selected && p.scale > 0.02) _feature(canvas, l, p, true);
    }
  }

  // ----------------------------------------------------------- text caching

  TextPainter _iconPainter(IconData icon, double size, Color color) {
    final key = 'i:${icon.codePoint}:${size.round()}:${color.toARGB32()}';
    return _tp.putIfAbsent(key, () {
      final tp = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            fontSize: size,
            color: color,
          ),
        ),
      )..layout();
      return tp;
    });
  }

  TextPainter _labelPainter(String text, double size, Color color, double maxWidth) {
    final key = 'l:$text:${size.round()}:${color.toARGB32()}:${maxWidth.round()}';
    return _tp.putIfAbsent(key, () {
      final tp = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 1,
        ellipsis: '…',
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w600, letterSpacing: 0.4),
        ),
      )..layout(maxWidth: maxWidth);
      return tp;
    });
  }

  // ------------------------------------------------------------- the pieces

  void _indicator(Canvas canvas, _Layout l, _Placement p) {
    final sec = sections[p.index];
    final r = l.indR;
    final a = p.alpha.clamp(0.0, 1.0).toDouble();
    canvas.saveLayer(
      Rect.fromCircle(center: p.center, radius: r * p.scale * 3 + 24),
      Paint()..color = Color.fromRGBO(0, 0, 0, a),
    );
    canvas.translate(p.center.dx, p.center.dy);
    canvas.scale(p.scale);

    final rect = Rect.fromCircle(center: Offset.zero, radius: r);
    canvas.drawCircle(
      Offset.zero,
      r * 2.2,
      Paint()
        ..shader = RadialGradient(colors: [
          OrbitPalette.gold.withValues(alpha: 0.20),
          OrbitPalette.gold.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: r * 2.2)),
    );
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.4, -0.45),
          radius: 1.05,
          colors: [Color(0xFFFFF1BD), Color(0xFFE6B93C), Color(0xFF6E5216)],
          stops: [0.0, 0.45, 1.0],
        ).createShader(rect),
    );
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = OrbitPalette.champagne.withValues(alpha: 0.6),
    );
    final glyph = _iconPainter(sec.icon, r * 1.15, OrbitPalette.deep);
    glyph.paint(canvas, Offset(-glyph.width / 2, -glyph.height / 2));

    final label = _labelPainter(sec.label, 10.5, OrbitPalette.text.withValues(alpha: 0.78), 80);
    label.paint(canvas, Offset(-label.width / 2, r + 5));
    canvas.restore();
  }

  void _feature(Canvas canvas, _Layout l, _Placement p, bool isSel) {
    final si = sectionIndex;
    if (si == null) return;
    final dests = sections[si].destinations;
    if (p.index >= dests.length) return;
    final d = dests[p.index];
    final r = l.featR;
    final a = p.alpha.clamp(0.0, 1.0).toDouble();
    if (a <= 0.01) return;

    canvas.saveLayer(
      Rect.fromCircle(center: p.center, radius: r * p.scale * 2.4 + 30),
      Paint()..color = Color.fromRGBO(0, 0, 0, a),
    );
    canvas.translate(p.center.dx, p.center.dy);
    canvas.scale(p.scale);

    final glyph = _iconPainter(d.icon, r * 0.95, OrbitPalette.deep);
    final glyphLight = _iconPainter(d.icon, r * 0.95, OrbitPalette.champagne.withValues(alpha: 0.55));
    paintGoldSphere(
      canvas,
      r,
      pattern: d.pattern,
      glyph: glyph,
      glyphLight: glyphLight,
      glow: isSel ? 0.40 : 0.16,
    );

    if (isSel) {
      final pulse = 1 + 0.04 * math.sin(u * _twoPi * 60);
      canvas.drawCircle(
        Offset.zero,
        r * 1.24 * pulse,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = OrbitPalette.gold.withValues(alpha: 0.9),
      );
    }

    final label = _labelPainter(
      d.title,
      isSel ? 11.5 : 10.5,
      OrbitPalette.text.withValues(alpha: isSel ? 1.0 : 0.66),
      104,
    );
    label.paint(canvas, Offset(-label.width / 2, r * 1.32));
    canvas.restore();
  }
}
