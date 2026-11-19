import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../orbit/widgets/planet_painters.dart';
import 'earth_continents.dart';

/// A tappable marker on the globe: one app section that lives on one continent.
class EarthPin {
  const EarthPin({
    required this.sectionIndex,
    required this.continent,
    required this.label,
    required this.icon,
  });

  /// Index of the section in the list built by `buildOrbitSections`.
  final int sectionIndex;
  final Continent continent;
  final String label;
  final IconData icon;

  ContinentInfo get info => kContinentInfo[continent.index];
}

// ---------------------------------------------------------------------------
// Projection: a sphere seen from far away (orthographic), rotated by
//   yaw   around the vertical axis (the Earth turning), then
//   pitch around the horizontal axis (tilting the north pole to the viewer).
// A point (lat, lon) faces the camera exactly when yaw = -lon and pitch = lat.
// ---------------------------------------------------------------------------

class EarthPoint {
  const EarthPoint(this.offset, this.z);

  /// Position on screen.
  final Offset offset;

  /// Depth: 1 = facing the viewer, 0 = on the rim, negative = behind the Earth.
  final double z;
}

class LatLon {
  const LatLon(this.lat, this.lon);
  final double lat, lon; // degrees
}

class EarthProjection {
  EarthProjection({
    required this.yaw,
    required this.pitch,
    required this.center,
    required this.radius,
  })  : _cy = math.cos(yaw),
        _sy = math.sin(yaw),
        _cp = math.cos(pitch),
        _sp = math.sin(pitch);

  final double yaw, pitch, radius;
  final Offset center;
  final double _cy, _sy, _cp, _sp;

  EarthPoint project(double latDeg, double lonDeg) {
    final la = latDeg * math.pi / 180, lo = lonDeg * math.pi / 180;
    final cl = math.cos(la);
    final x0 = cl * math.sin(lo), y0 = math.sin(la), z0 = cl * math.cos(lo);
    final x1 = x0 * _cy + z0 * _sy;
    final z1 = -x0 * _sy + z0 * _cy;
    final y2 = y0 * _cp - z1 * _sp;
    final z2 = y0 * _sp + z1 * _cp;
    return EarthPoint(Offset(center.dx + radius * x1, center.dy - radius * y2), z2);
  }

  /// The point of the Earth under a screen position, or null when the position
  /// is farther than [slackPx] outside the disc (a small slack lets a finger
  /// that lands just past the rim still select the coast).
  LatLon? unproject(Offset p, {double slackPx = 0}) {
    if (radius <= 0) return null;
    var dx = (p.dx - center.dx) / radius;
    var dy = -(p.dy - center.dy) / radius;
    final d2 = dx * dx + dy * dy;
    if (d2 > 1) {
      final limit = 1 + slackPx / radius;
      if (d2 > limit * limit) return null;
      final k = 0.999 / math.sqrt(d2);
      dx *= k;
      dy *= k;
    }
    final z2 = math.sqrt(math.max(0.0, 1 - dx * dx - dy * dy));
    final y = dy * _cp + z2 * _sp;
    final z1 = -dy * _sp + z2 * _cp;
    final x = dx * _cy - z1 * _sy;
    final z = dx * _sy + z1 * _cy;
    return LatLon(
      math.asin(y.clamp(-1.0, 1.0).toDouble()) * 180 / math.pi,
      math.atan2(x, z) * 180 / math.pi,
    );
  }
}

// ---------------------------------------------------------------------------
// The dotted Earth: land and ocean dots on a latitude/longitude grid, built
// ONCE from the land mask of the Orbit planet. The rings of dots get thinner
// toward the poles, so the dots stay evenly spaced on the sphere.
// ---------------------------------------------------------------------------

class EarthModel {
  EarthModel._({
    required this.landCount,
    required this.lx,
    required this.ly,
    required this.lz,
    required this.landContinent,
    required this.continentCounts,
    required this.oceanCount,
    required this.ox,
    required this.oy,
    required this.oz,
  });

  static EarthModel? _cached;

  /// Shared instance. Normally ready already (see [warmUp]); otherwise it is
  /// built right here, on first use.
  static EarthModel get instance => _cached ??= _build();

  /// Builds the model on a background isolate (about 35k point-in-polygon
  /// tests) so the UI thread never stalls on it. Safe to call more than once.
  static Future<void> warmUp() async {
    if (_cached != null) return;
    if (kIsWeb) {
      // No isolates on the web: build it after the splash's first frames.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      _cached ??= _build();
      return;
    }
    try {
      final m = await Isolate.run(_build);
      _cached ??= m;
    } catch (_) {
      // Falls back to building on first use.
    }
  }

  static const double landStep = 1.2; // degrees between land dots
  static const double oceanStep = 2.6; // degrees between (faint) ocean dots

  final int landCount;
  final Float32List lx, ly, lz; // unit vectors of the land dots
  final Uint8List landContinent; // Continent.index, or kOtherLand
  final List<int> continentCounts; // land dots per continent (7 entries)

  final int oceanCount;
  final Float32List ox, oy, oz;

  static void _walk(double step, void Function(double lat, double lon) visit) {
    var lat = -90.0 + step / 2;
    while (lat < 90) {
      final cl = math.cos(lat * math.pi / 180);
      final n = math.max(1, (360 * cl / step).round());
      final d = 360 / n;
      for (var i = 0; i < n; i++) {
        visit(lat, -180 + (i + 0.5) * d);
      }
      lat += step;
    }
  }

  static EarthModel _build() {
    final lxs = <double>[], lys = <double>[], lzs = <double>[];
    final lc = <int>[];
    final counts = List<int>.filled(kOtherLand + 1, 0);
    _walk(landStep, (lat, lon) {
      if (!earthIsLand(lat, lon)) return;
      final c = continentAt(lat, lon);
      final idx = c == null ? kOtherLand : c.index;
      final la = lat * math.pi / 180, lo = lon * math.pi / 180;
      final cl = math.cos(la);
      lxs.add(cl * math.sin(lo));
      lys.add(math.sin(la));
      lzs.add(cl * math.cos(lo));
      lc.add(idx);
      counts[idx]++;
    });

    final oxs = <double>[], oys = <double>[], ozs = <double>[];
    _walk(oceanStep, (lat, lon) {
      if (earthIsLand(lat, lon)) return;
      final la = lat * math.pi / 180, lo = lon * math.pi / 180;
      final cl = math.cos(la);
      oxs.add(cl * math.sin(lo));
      oys.add(math.sin(la));
      ozs.add(cl * math.cos(lo));
    });

    return EarthModel._(
      landCount: lxs.length,
      lx: Float32List.fromList(lxs),
      ly: Float32List.fromList(lys),
      lz: Float32List.fromList(lzs),
      landContinent: Uint8List.fromList(lc),
      continentCounts: counts,
      oceanCount: oxs.length,
      ox: Float32List.fromList(oxs),
      oy: Float32List.fromList(oys),
      oz: Float32List.fromList(ozs),
    );
  }
}

// ---------------------------------------------------------------------------
// Renderer: plain Dart, one canvas pass. It owns drawing AND hit-testing, so
// what the user sees is exactly what the user can tap.
// ---------------------------------------------------------------------------

class EarthRenderer {
  EarthRenderer() {
    // 4 depth/light levels per continent (+1 "other land"), one draw call each.
    for (var c = 0; c <= kOtherLand; c++) {
      final cap = _model.continentCounts[c] * 2;
      for (var l = 0; l < _levels; l++) {
        _landBuf.add(Float32List(cap));
      }
    }
  }

  static const int _levels = 4;
  static const double _hitSlackPx = 24; // finger forgiveness around a coast
  static const double _pinHitPx = 30; // pin hit radius (60 px target)
  static const double _pinR = 15;

  final EarthModel _model = EarthModel.instance;
  final StarField _stars = StarField();
  final Map<String, TextPainter> _tp = {};
  final List<Float32List> _landBuf = [];
  late final Float32List _oceanBuf = Float32List(_model.oceanCount * 2);
  final Paint _dot = Paint()..strokeCap = StrokeCap.round;

  /// One pin per app section (see earth_sections.dart).
  List<EarthPin> pins = const [];

  /// Camera. [zoom] multiplies the base radius; [cyFrac] is the vertical
  /// position of the Earth's center as a fraction of the height.
  double yaw = -0.35, pitch = 0.32, zoom = 1.0, cyFrac = 0.46, roll = 0.0;

  /// 0 = whole Earth, 1 = zoomed into a continent.
  double focus = 0.0;

  /// Pin (index in [pins]) whose continent is open, if any.
  int? focusPin;

  /// Ambient loop position 0..1 (stars, pulses).
  double u = 0.083;

  // ------------------------------------------------------------------ layout

  /// Radius of the Earth when nothing is zoomed: almost the full screen width.
  double baseRadius(Size s) => math.min(s.width * 0.49, s.height * 0.33);

  double radius(Size s) => baseRadius(s) * zoom;

  Offset center(Size s) => Offset(s.width / 2, s.height * cyFrac);

  EarthProjection projection(Size s) =>
      EarthProjection(yaw: yaw, pitch: pitch, center: center(s), radius: radius(s));

  // --------------------------------------------------------------- hit test

  /// Which pin (index in [pins]) is under [p]? Tapping the pin itself or the
  /// land of its continent both count. Only works on the whole-Earth view.
  int? hitTest(Offset p, Size s) {
    if (focusPin != null || focus > 0.05 || pins.isEmpty) return null;
    final proj = projection(s);

    // 1) pins: the front-most one within reach of the finger.
    int? best;
    var bestZ = -9.0;
    for (var i = 0; i < pins.length; i++) {
      final info = pins[i].info;
      final pt = proj.project(info.lat, info.lon);
      if (pt.z < 0.2) continue;
      if ((p - pt.offset).distance <= _pinHitPx && pt.z > bestZ) {
        best = i;
        bestZ = pt.z;
      }
    }
    if (best != null) return best;

    // 2) land: look under the finger, then in growing rings around it.
    final ll = proj.unproject(p, slackPx: _hitSlackPx);
    if (ll == null) return null;
    final r = proj.radius;
    final tol = _hitSlackPx / r * 180 / math.pi; // finger radius in degrees
    for (final f in const [0.0, 0.35, 0.7, 1.0]) {
      final d = tol * f;
      final steps = f == 0 ? 1 : 8;
      for (var k = 0; k < steps; k++) {
        final a = k * math.pi / 4;
        final lat = (ll.lat + d * math.sin(a)).clamp(-89.9, 89.9).toDouble();
        final cl = math.max(0.2, math.cos(lat * math.pi / 180));
        var lon = ll.lon + d * math.cos(a) / cl;
        lon = ((lon + 180) % 360 + 360) % 360 - 180;
        if (!earthIsLand(lat, lon)) continue;
        final c = continentAt(lat, lon);
        if (c == null) continue;
        for (var i = 0; i < pins.length; i++) {
          if (pins[i].continent == c) return i;
        }
      }
    }
    return null;
  }

  // ------------------------------------------------------------------- paint

  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = OrbitPalette.space);
    paintStars(canvas, s, _stars, u);

    final c = center(s);
    final r = radius(s);
    if (r <= 0) return;
    final f = focus.clamp(0.0, 1.0).toDouble();
    final fp = (focusPin != null && focusPin! < pins.length) ? pins[focusPin!] : null;
    final focusIdx = fp?.continent.index;
    final accent = fp?.info.color ?? OrbitPalette.gold;
    final rect = Rect.fromCircle(center: c, radius: r);

    canvas.save();
    if (roll != 0) {
      // A touch of camera roll while flying in/out: it makes the move feel 3D.
      canvas.translate(c.dx, c.dy);
      canvas.rotate(roll);
      canvas.translate(-c.dx, -c.dy);
    }

    // Atmosphere: a thin glow just outside the rim, tinted by the open continent.
    canvas.drawCircle(
      c,
      r * 1.3,
      Paint()
        ..shader = ui.Gradient.radial(
          c,
          r * 1.3,
          [
            accent.withValues(alpha: 0.0),
            accent.withValues(alpha: 0.0),
            accent.withValues(alpha: 0.24 - 0.10 * f),
            accent.withValues(alpha: 0.0),
          ],
          const [0.0, 0.765, 0.80, 1.0],
        ),
    );

    // Ocean body.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.4, -0.45),
          radius: 1.05,
          colors: [Color(0xFF172030), Color(0xFF0A0D14), Color(0xFF020304)],
          stops: [0.0, 0.55, 1.0],
        ).createShader(rect),
    );

    // Projection constants for this frame.
    final cyw = math.cos(yaw), syw = math.sin(yaw);
    final cp = math.cos(pitch), sp = math.sin(pitch);
    final w = s.width, h = s.height;
    final pad = 40.0 + r * 0.02;
    final dotW = math.max(2.0, r * 0.0175);

    // Light from the upper left (unit vector).
    const lxv = -0.45, lyv = 0.50, lzv = 0.74;
    final ln = math.sqrt(lxv * lxv + lyv * lyv + lzv * lzv);
    final lx = lxv / ln, ly = lyv / ln, lz = lzv / ln;

    // Faint ocean dots: they make the rotation readable over open water.
    var on = 0;
    final ox = _model.ox, oy = _model.oy, oz = _model.oz;
    for (var i = 0; i < _model.oceanCount; i++) {
      final x0 = ox[i], y0 = oy[i], z0 = oz[i];
      final z1 = -x0 * syw + z0 * cyw;
      final z2 = y0 * sp + z1 * cp;
      if (z2 < 0.05) continue;
      final x1 = x0 * cyw + z0 * syw;
      final y2 = y0 * cp - z1 * sp;
      final sx = c.dx + r * x1, sy = c.dy - r * y2;
      if (sx < -pad || sx > w + pad || sy < -pad || sy > h + pad) continue;
      _oceanBuf[on * 2] = sx;
      _oceanBuf[on * 2 + 1] = sy;
      on++;
    }
    if (on > 0) {
      _dot
        ..strokeWidth = math.max(1.2, dotW * 0.36)
        ..color = OrbitPalette.gold.withValues(alpha: 0.17 * (1 - 0.45 * f));
      canvas.drawRawPoints(ui.PointMode.points, Float32List.sublistView(_oceanBuf, 0, on * 2), _dot);
    }

    // Land dots, sorted into (continent, light level) bins.
    final counts = List<int>.filled((kOtherLand + 1) * _levels, 0);
    final lxs = _model.lx, lys = _model.ly, lzs = _model.lz;
    final lcs = _model.landContinent;
    for (var i = 0; i < _model.landCount; i++) {
      final x0 = lxs[i], y0 = lys[i], z0 = lzs[i];
      final z1 = -x0 * syw + z0 * cyw;
      final z2 = y0 * sp + z1 * cp;
      if (z2 < 0.03) continue;
      final x1 = x0 * cyw + z0 * syw;
      final y2 = y0 * cp - z1 * sp;
      final sx = c.dx + r * x1, sy = c.dy - r * y2;
      if (sx < -pad || sx > w + pad || sy < -pad || sy > h + pad) continue;
      final lit = x1 * lx + y2 * ly + z2 * lz;
      final shade = 0.30 * z2 + 0.70 * (lit > 0 ? lit : 0.0);
      final level = shade < 0.28 ? 0 : (shade < 0.5 ? 1 : (shade < 0.75 ? 2 : 3));
      final bin = lcs[i] * _levels + level;
      final buf = _landBuf[bin];
      final n = counts[bin]++;
      buf[n * 2] = sx;
      buf[n * 2 + 1] = sy;
    }

    final active = List<bool>.filled(kOtherLand + 1, false);
    for (final p in pins) {
      active[p.continent.index] = true;
    }
    const levelAlpha = [0.34, 0.58, 0.84, 1.0];
    const levelWidth = [0.78, 0.90, 1.0, 1.08];
    const muted = Color(0xFFB59A5B);
    // Unfocused continents first, the open one last (drawn on top).
    final order = <int>[
      for (var k = 0; k <= kOtherLand; k++)
        if (k != focusIdx) k,
      if (focusIdx != null) focusIdx,
    ];
    for (final k in order) {
      final isFocus = k == focusIdx;
      final base = k == kOtherLand ? muted : (active[k] ? kContinentInfo[k].color : muted);
      // Continents that are not open dim down while zoomed in; land without a
      // section is always a little quieter.
      var mult = isFocus ? 1.0 : 1.0 - 0.74 * f;
      if (k == kOtherLand || !active[k]) mult *= 0.62;
      for (var l = 0; l < _levels; l++) {
        final bin = k * _levels + l;
        final n = counts[bin];
        if (n == 0) continue;
        _dot
          ..strokeWidth = dotW * levelWidth[l] * (isFocus ? 1.0 + 0.12 * f : 1.0)
          ..color = base.withValues(alpha: (levelAlpha[l] * mult).clamp(0.0, 1.0).toDouble());
        canvas.drawRawPoints(ui.PointMode.points, Float32List.sublistView(_landBuf[bin], 0, n * 2), _dot);
      }
    }

    // Terminator + limb darkening, then a thin rim light.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.45, -0.5),
          radius: 1.25,
          colors: [Color(0x00000000), Color(0x38000000), Color(0xD0000000)],
          stops: [0.45, 0.80, 1.0],
        ).createShader(rect),
    );
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = OrbitPalette.champagne.withValues(alpha: 0.28),
    );

    // Pins (they fade out as the camera dives into a continent).
    if (f < 0.98) {
      final proj = EarthProjection(yaw: yaw, pitch: pitch, center: c, radius: r);
      final pinOrder = <int>[for (var i = 0; i < pins.length; i++) i]
        ..sort((a, b) {
          final za = proj.project(pins[a].info.lat, pins[a].info.lon).z;
          final zb = proj.project(pins[b].info.lat, pins[b].info.lon).z;
          return za.compareTo(zb);
        });
      for (final i in pinOrder) {
        _pin(canvas, proj, pins[i], i, 1 - f);
      }
    }
    canvas.restore();
  }

  // ----------------------------------------------------------- text caching

  TextPainter _iconPainter(IconData icon, double size, Color color) {
    final key = 'i:${icon.codePoint}:${size.round()}:${color.toARGB32()}';
    return _tp.putIfAbsent(key, () {
      return TextPainter(
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
    });
  }

  TextPainter _labelPainter(String text, double size, Color color) {
    final key = 'l:$text:${size.round()}:${color.toARGB32()}';
    return _tp.putIfAbsent(key, () {
      return TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 1,
        ellipsis: '…',
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: size,
            color: color,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            shadows: const [
              Shadow(color: Color(0xFF000000), blurRadius: 5),
              Shadow(color: Color(0xFF000000), blurRadius: 2),
            ],
          ),
        ),
      )..layout(maxWidth: 110);
    });
  }

  void _pin(Canvas canvas, EarthProjection proj, EarthPin pin, int index, double visible) {
    final info = pin.info;
    final pt = proj.project(info.lat, info.lon);
    if (pt.z < 0.12) return;
    final k = ((pt.z - 0.12) / 0.35).clamp(0.0, 1.0).toDouble();
    final alpha = (k * visible).clamp(0.0, 1.0).toDouble();
    if (alpha < 0.02) return;

    final color = info.color;
    final scale = 0.88 + 0.24 * pt.z;
    final pulse = 1 + 0.10 * math.sin(u * 2 * math.pi * 40 + index * 1.3);

    canvas.saveLayer(
      Rect.fromCircle(center: pt.offset, radius: _pinR * scale * 3 + 40),
      Paint()..color = Color.fromRGBO(0, 0, 0, alpha),
    );
    canvas.translate(pt.offset.dx, pt.offset.dy);
    canvas.scale(scale);

    // Soft halo + pulsing ring.
    canvas.drawCircle(
      Offset.zero,
      _pinR * 2.3,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset.zero,
          _pinR * 2.3,
          [color.withValues(alpha: 0.38), color.withValues(alpha: 0.0)],
        ),
    );
    canvas.drawCircle(
      Offset.zero,
      _pinR * 1.28 * pulse,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = color.withValues(alpha: 0.55),
    );

    // Disc with the section icon.
    final disc = Rect.fromCircle(center: Offset.zero, radius: _pinR);
    canvas.drawCircle(
      Offset.zero,
      _pinR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.45),
          radius: 1.05,
          colors: [Color.lerp(color, Colors.white, 0.55)!, color, Color.lerp(color, Colors.black, 0.55)!],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(disc),
    );
    canvas.drawCircle(
      Offset.zero,
      _pinR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = OrbitPalette.champagne.withValues(alpha: 0.7),
    );
    final glyph = _iconPainter(pin.icon, _pinR * 1.2, OrbitPalette.deep);
    glyph.paint(canvas, Offset(-glyph.width / 2, -glyph.height / 2));

    final label = _labelPainter(pin.label, 11, OrbitPalette.text);
    label.paint(canvas, Offset(-label.width / 2, _pinR + 6));
    canvas.restore();
  }
}
