import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Fixed cinematic palette of the Orbit universe: black + gold (no green).
class OrbitPalette {
  OrbitPalette._();
  static const space = Color(0xFF030303);
  static const gold = Color(0xFFD4AF37);
  static const champagne = Color(0xFFF1DFA6);
  static const amber = Color(0xFFB8860B);
  static const deep = Color(0xFF3B2A0A);
  static const text = Color(0xFFF5F1E6);
  static const muted = Color(0xFFA89F8A);
}

// ---------------------------------------------------------------------------
// Small value noise on the sphere (used once, to place the "terrain" points).
// ---------------------------------------------------------------------------

double _hash3(int x, int y, int z) {
  var h = (x * 374761393 + y * 668265263 + z * 1274126177) & 0x7fffffff;
  h = ((h ^ (h >> 13)) * 1103515245) & 0x7fffffff;
  h = (h ^ (h >> 16)) & 0xffff;
  return h / 65535.0;
}

double _vnoise(double x, double y, double z) {
  final xi = x.floor(), yi = y.floor(), zi = z.floor();
  double s(double t) => t * t * (3 - 2 * t);
  final u = s(x - xi), v = s(y - yi), w = s(z - zi);
  double l(double a, double b, double t) => a + (b - a) * t;
  return l(
    l(
      l(_hash3(xi, yi, zi), _hash3(xi + 1, yi, zi), u),
      l(_hash3(xi, yi + 1, zi), _hash3(xi + 1, yi + 1, zi), u),
      v,
    ),
    l(
      l(_hash3(xi, yi, zi + 1), _hash3(xi + 1, yi, zi + 1), u),
      l(_hash3(xi, yi + 1, zi + 1), _hash3(xi + 1, yi + 1, zi + 1), u),
      v,
    ),
    w,
  );
}

double _fbm(double x, double y, double z) =>
    0.55 * _vnoise(x * 2.2, y * 2.2, z * 2.2) +
    0.30 * _vnoise(x * 4.6 + 7.3, y * 4.6 + 1.7, z * 4.6 + 3.1) +
    0.15 * _vnoise(x * 9.4 + 2.9, y * 9.4 + 5.5, z * 9.4 + 8.2);

// ---------------------------------------------------------------------------
// Main planet: gold "terrain" points on a dark sphere, drawn with a cheap
// orthographic projection (no 3D engine, no textures to load).
// ---------------------------------------------------------------------------

class MainPlanetModel {
  MainPlanetModel() {
    final rnd = math.Random(11);
    final sLat = <double>[], cLat = <double>[], sLon = <double>[], cLon = <double>[];
    final bins = <int>[];
    var guard = 0;
    while (sLat.length < 950 && guard < 30000) {
      guard++;
      final y = rnd.nextDouble() * 2 - 1;
      final lon = rnd.nextDouble() * 2 * math.pi;
      final cl = math.sqrt(1 - y * y);
      final n = _fbm(cl * math.sin(lon), y, cl * math.cos(lon));
      final city = rnd.nextDouble() < 0.02;
      if (n < 0.54 && !city) continue;
      sLat.add(y);
      cLat.add(cl);
      sLon.add(math.sin(lon));
      cLon.add(math.cos(lon));
      bins.add(city ? 3 : math.min(2, ((n - 0.54) * 9).floor()));
    }
    count = sLat.length;
    sinLat = Float64List.fromList(sLat);
    cosLat = Float64List.fromList(cLat);
    sinLon = Float64List.fromList(sLon);
    cosLon = Float64List.fromList(cLon);
    bin = Uint8List.fromList(bins);
    buffers = List.generate(4, (_) => Float32List(count * 2));
  }

  late final int count;
  late final Float64List sinLat, cosLat, sinLon, cosLon;
  late final Uint8List bin;
  late final List<Float32List> buffers;
}

/// Draws the main planet (without rings). [rot] is the rotation in radians.
void paintMainPlanet(
  Canvas canvas,
  MainPlanetModel m,
  Offset c,
  double r, {
  required double rot,
  required double dim,
  ui.Image? logo,
}) {
  const tilt = 0.32;
  final ct = math.cos(tilt), st = math.sin(tilt);
  final rect = Rect.fromCircle(center: c, radius: r);

  // Atmosphere halo (outside the sphere).
  final haloRect = Rect.fromCircle(center: c, radius: r * 1.32);
  canvas.drawCircle(
    c,
    r * 1.32,
    Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0x00D4AF37),
          const Color(0x00D4AF37),
          OrbitPalette.gold.withValues(alpha: 0.26 * dim),
          const Color(0x00D4AF37),
        ],
        stops: const [0.0, 0.74, 0.79, 1.0],
      ).createShader(haloRect),
  );

  canvas.save();
  canvas.clipPath(Path()..addOval(rect));

  // Dark base.
  canvas.drawRect(
    rect,
    Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.4),
        radius: 1.0,
        colors: [Color(0xFF2B2318), Color(0xFF130F0A), Color(0xFF050403)],
        stops: [0.0, 0.55, 1.0],
      ).createShader(rect),
  );

  // Faint graticule (terrain contours).
  final grat = Path();
  Offset? proj(double lat, double lon) {
    final cl = math.cos(lat);
    final x = cl * math.sin(lon + rot);
    final y0 = math.sin(lat);
    final z0 = cl * math.cos(lon + rot);
    final y = y0 * ct - z0 * st;
    final z = y0 * st + z0 * ct;
    if (z < 0.02) return null;
    return Offset(c.dx + r * x, c.dy - r * y);
  }

  for (var k = 0; k < 8; k++) {
    final lon = k * math.pi / 4;
    var pen = false;
    for (var i = 0; i <= 36; i++) {
      final p = proj(-math.pi / 2 + math.pi * i / 36, lon);
      if (p == null) {
        pen = false;
        continue;
      }
      if (pen) {
        grat.lineTo(p.dx, p.dy);
      } else {
        grat.moveTo(p.dx, p.dy);
        pen = true;
      }
    }
  }
  for (final deg in const [-55.0, -25.0, 0.0, 25.0, 55.0]) {
    final lat = deg * math.pi / 180;
    var pen = false;
    for (var i = 0; i <= 48; i++) {
      final p = proj(lat, 2 * math.pi * i / 48);
      if (p == null) {
        pen = false;
        continue;
      }
      if (pen) {
        grat.lineTo(p.dx, p.dy);
      } else {
        grat.moveTo(p.dx, p.dy);
        pen = true;
      }
    }
  }
  canvas.drawPath(
    grat,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..color = OrbitPalette.gold.withValues(alpha: 0.10 * dim),
  );

  // Gold terrain points (4 brightness bins, one draw call each).
  final cr = math.cos(rot), sr = math.sin(rot);
  final counts = [0, 0, 0, 0];
  for (var i = 0; i < m.count; i++) {
    final sl = m.sinLon[i] * cr + m.cosLon[i] * sr;
    final cl = m.cosLon[i] * cr - m.sinLon[i] * sr;
    final x = m.cosLat[i] * sl;
    final y0 = m.sinLat[i];
    final z0 = m.cosLat[i] * cl;
    final z = y0 * st + z0 * ct;
    if (z < 0.05) continue;
    final y = y0 * ct - z0 * st;
    final b = m.bin[i];
    final buf = m.buffers[b];
    final n = counts[b]++;
    buf[n * 2] = c.dx + r * x;
    buf[n * 2 + 1] = c.dy - r * y;
  }
  final scale = (r / 90).clamp(0.6, 1.4).toDouble();
  const widths = [1.1, 1.5, 1.9, 2.6];
  final colors = [
    OrbitPalette.amber.withValues(alpha: 0.40 * dim),
    OrbitPalette.gold.withValues(alpha: 0.55 * dim),
    OrbitPalette.gold.withValues(alpha: 0.80 * dim),
    OrbitPalette.champagne.withValues(alpha: 0.95 * dim),
  ];
  for (var b = 0; b < 4; b++) {
    if (counts[b] == 0) continue;
    canvas.drawRawPoints(
      ui.PointMode.points,
      Float32List.sublistView(m.buffers[b], 0, counts[b] * 2),
      Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = widths[b] * scale
        ..color = colors[b],
    );
  }

  // The SPHERA logo as an extremely subtle golden emboss (only if it loaded).
  if (logo != null) {
    final lh = r * 0.95;
    final lw = lh * logo.width / logo.height;
    final dx = math.sin(rot * 0.5) * r * 0.05;
    final dst = Rect.fromCenter(center: c.translate(dx, -r * 0.02), width: lw, height: lh);
    final src = Rect.fromLTWH(0, 0, logo.width.toDouble(), logo.height.toDouble());
    final o = r * 0.012;
    Paint tint(Color col) => Paint()
      ..colorFilter = ColorFilter.mode(col, BlendMode.srcIn)
      ..filterQuality = FilterQuality.medium;
    canvas.drawImageRect(logo, src, dst.shift(Offset(o, o)), tint(Colors.black.withValues(alpha: 0.35 * dim)));
    canvas.drawImageRect(logo, src, dst.shift(Offset(-o, -o)), tint(OrbitPalette.champagne.withValues(alpha: 0.10 * dim)));
    canvas.drawImageRect(logo, src, dst, tint(OrbitPalette.gold.withValues(alpha: 0.10 * dim)));
  }

  // Light from the upper left: terminator shadow on the lower right.
  canvas.drawRect(
    rect,
    Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.45, -0.5),
        radius: 1.25,
        colors: [Color(0x00000000), Color(0x66000000), Color(0xE6000000)],
        stops: [0.38, 0.75, 1.0],
      ).createShader(rect),
  );
  canvas.restore();

  // Rim light on the lit edge.
  canvas.drawCircle(
    c,
    r,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, r * 0.018)
      ..shader = SweepGradient(
        colors: [
          OrbitPalette.champagne.withValues(alpha: 0.0),
          OrbitPalette.champagne.withValues(alpha: 0.85 * dim),
          OrbitPalette.champagne.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(0.79),
      ).createShader(rect),
  );
}

/// Saturn-like rings. Call once with [back] = true BEFORE the planet and once
/// with [back] = false AFTER it, so the planet really sits inside the rings.
void paintRings(
  Canvas canvas,
  Offset c,
  double r, {
  required bool back,
  required double u,
  required double alpha,
}) {
  const tilt = -0.30;
  canvas.save();
  canvas.translate(c.dx, c.dy);
  canvas.rotate(tilt);

  // (radius factor, stroke width factor, alpha)
  const rings = [
    (1.46, 0.030, 0.55),
    (1.58, 0.120, 0.07),
    (1.70, 0.012, 0.45),
    (1.84, 0.028, 0.30),
  ];
  for (final ring in rings) {
    final a = r * ring.$1;
    final rect = Rect.fromCenter(center: Offset.zero, width: a * 2, height: a * 2 * 0.26);
    canvas.drawArc(
      rect,
      back ? math.pi : 0,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(0.8, r * ring.$2)
        ..color = (ring.$2 > 0.1 ? OrbitPalette.amber : OrbitPalette.gold)
            .withValues(alpha: ring.$3 * alpha),
    );
  }

  // Tiny gold bodies drifting along the rings.
  final dot = Paint()..color = OrbitPalette.champagne.withValues(alpha: 0.8 * alpha);
  for (var k = 0; k < 26; k++) {
    final ringIdx = k % 3;
    final a = r * (1.46 + 0.12 * ringIdx + (ringIdx == 2 ? 0.14 : 0));
    final dir = ringIdx.isEven ? 1 : -1;
    final ang = k * 2.399963 + dir * u * 2 * math.pi * (1 + ringIdx);
    final sy = math.sin(ang);
    if ((sy >= 0) == back) continue; // sy >= 0 -> front half
    canvas.drawCircle(Offset(a * math.cos(ang), a * 0.26 * sy), math.max(0.7, r * 0.011), dot);
  }
  canvas.restore();
}

// ---------------------------------------------------------------------------
// Stars and floating gold dust
// ---------------------------------------------------------------------------

class StarDust {
  StarDust(this.x, this.y, this.kx, this.ky, this.kt, this.phase, this.a, this.r);
  final double x, y, phase, a, r;
  final int kx, ky, kt; // integers so the loop is seamless
}

class StarField {
  StarField() {
    final rnd = math.Random(3);
    for (var i = 0; i < 120; i++) {
      xs.add(rnd.nextDouble());
      ys.add(rnd.nextDouble());
      bins.add(rnd.nextInt(3));
    }
    for (var i = 0; i < 36; i++) {
      dust.add(StarDust(
        rnd.nextDouble(),
        rnd.nextDouble(),
        rnd.nextInt(5) - 2,
        -(rnd.nextInt(3) + 1),
        rnd.nextInt(10) + 4,
        rnd.nextDouble() * 6.28,
        0.15 + rnd.nextDouble() * 0.35,
        0.8 + rnd.nextDouble() * 1.1,
      ));
    }
    buffers = List.generate(3, (_) => Float32List(xs.length * 2));
  }

  final List<double> xs = [], ys = [];
  final List<int> bins = [];
  final List<StarDust> dust = [];
  late final List<Float32List> buffers;
}

void paintStars(Canvas canvas, Size s, StarField f, double u) {
  final counts = [0, 0, 0];
  for (var i = 0; i < f.xs.length; i++) {
    final b = f.bins[i];
    final n = counts[b]++;
    f.buffers[b][n * 2] = f.xs[i] * s.width;
    f.buffers[b][n * 2 + 1] = f.ys[i] * s.height;
  }
  const widths = [0.9, 1.3, 1.8];
  const alphas = [0.30, 0.45, 0.65];
  for (var b = 0; b < 3; b++) {
    canvas.drawRawPoints(
      ui.PointMode.points,
      Float32List.sublistView(f.buffers[b], 0, counts[b] * 2),
      Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = widths[b]
        ..color = OrbitPalette.text.withValues(alpha: alphas[b]),
    );
  }

  final p = Paint();
  for (final d in f.dust) {
    final x = ((d.x + u * d.kx) % 1.0 + 1.0) % 1.0;
    final y = ((d.y + u * d.ky) % 1.0 + 1.0) % 1.0;
    final tw = 0.55 + 0.45 * math.sin(u * 2 * math.pi * d.kt + d.phase);
    p.color = OrbitPalette.gold.withValues(alpha: d.a * tw);
    canvas.drawCircle(Offset(x * s.width, y * s.height), d.r, p);
  }
}

// ---------------------------------------------------------------------------
// Feature planets
// ---------------------------------------------------------------------------

void _pattern(Canvas c, int p, double r) {
  final dark = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = r * 0.06
    ..color = OrbitPalette.deep.withValues(alpha: 0.22);
  switch (p % 5) {
    case 0: // bands
      for (var i = -3; i <= 3; i++) {
        final y = i * r * 0.28;
        c.drawLine(Offset(-r, y), Offset(r, y + r * 0.06 * i), dark);
      }
    case 1: // dots
      final fill = Paint()..color = OrbitPalette.deep.withValues(alpha: 0.22);
      for (var gy = -3; gy <= 3; gy++) {
        for (var gx = -3; gx <= 3; gx++) {
          c.drawCircle(Offset(gx * r * 0.3 + (gy.isOdd ? r * 0.15 : 0), gy * r * 0.3), r * 0.035, fill);
        }
      }
    case 2: // concentric arcs
      for (final k in const [0.45, 0.75, 1.05]) {
        c.drawCircle(Offset(-r * 0.35, -r * 0.3), r * k, dark);
      }
    case 3: // hatch
      for (var i = -4; i <= 4; i++) {
        c.drawLine(Offset(-r + i * r * 0.4, -r), Offset(i * r * 0.4 + r, r), dark);
      }
    default: // craters
      c.drawCircle(Offset(r * 0.3, r * 0.25), r * 0.22, dark);
      c.drawCircle(Offset(-r * 0.35, r * 0.3), r * 0.13, dark);
      c.drawCircle(Offset(r * 0.05, -r * 0.4), r * 0.10, dark);
  }
}

/// A metallic gold sphere centred on the canvas origin (the caller translates
/// and scales). [glyph] is the engraved symbol, [glyphLight] its highlight.
void paintGoldSphere(
  Canvas canvas,
  double r, {
  required int pattern,
  required TextPainter glyph,
  required TextPainter glyphLight,
  required double glow,
}) {
  final rect = Rect.fromCircle(center: Offset.zero, radius: r);

  canvas.drawCircle(
    Offset.zero,
    r * 1.9,
    Paint()
      ..shader = RadialGradient(colors: [
        OrbitPalette.gold.withValues(alpha: glow),
        OrbitPalette.gold.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCircle(center: Offset.zero, radius: r * 1.9)),
  );

  canvas.save();
  canvas.clipPath(Path()..addOval(rect));
  canvas.drawRect(
    rect,
    Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.4, -0.45),
        radius: 1.05,
        colors: [Color(0xFFFFF1BD), Color(0xFFE6B93C), Color(0xFF93701F), Color(0xFF2B1D06)],
        stops: [0.0, 0.32, 0.72, 1.0],
      ).createShader(rect),
  );
  _pattern(canvas, pattern, r);
  canvas.drawRect(
    rect,
    Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.4, -0.45),
        radius: 1.15,
        colors: [Color(0x00000000), Color(0x00000000), Color(0x8C000000)],
        stops: [0.0, 0.55, 1.0],
      ).createShader(rect),
  );
  canvas.restore();

  canvas.drawCircle(
    Offset.zero,
    r,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = OrbitPalette.champagne.withValues(alpha: 0.55),
  );
  canvas.drawOval(
    Rect.fromCenter(center: Offset(-r * 0.35, -r * 0.4), width: r * 0.5, height: r * 0.3),
    Paint()
      ..color = Colors.white.withValues(alpha: 0.30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
  );

  glyphLight.paint(canvas, Offset(-glyphLight.width / 2 + 0.9, -glyphLight.height / 2 + 0.9));
  glyph.paint(canvas, Offset(-glyph.width / 2, -glyph.height / 2));
}
