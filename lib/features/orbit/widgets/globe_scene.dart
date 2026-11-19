import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../earth/earth_continents.dart';
import '../../earth/earth_scene.dart';
import '../models/orbit_destination.dart';
import 'planet_painters.dart';

// ---------------------------------------------------------------------------
// Which continent hosts which section
// ---------------------------------------------------------------------------

/// Which continent hosts which section of the app on the Orbit globe.
/// Change a line to move a section. The Earth starts facing Europe / Africa /
/// Asia, so the sections used most (Stats, Settings, Cards) sit there.
/// A section without a continent here takes the first free one.
const Map<String, Continent> kOrbitContinent = {
  'stats': Continent.africa,
  'settings': Continent.asia,
  'cards': Continent.europe,
  'games': Continent.northAmerica,
  'google': Continent.southAmerica,
  'profile': Continent.oceania,
};

/// One section on its continent: the hub pin, plus one small node per screen
/// of that section (visible once the camera has dived into the continent).
class GlobeHub {
  const GlobeHub({required this.pin, required this.nodes});

  final EarthPin pin;

  /// One position per destination of the section, in destination order.
  final List<LatLon> nodes;

  Continent get continent => pin.continent;
  ContinentInfo get info => pin.info;
  int get sectionIndex => pin.sectionIndex;
}

/// One hub per section (at most one per continent, so six).
List<GlobeHub> buildGlobeHubs(List<OrbitSection> sections) {
  final used = <Continent>{};
  final picked = <int, Continent>{};
  final unplaced = <int>[];

  for (var i = 0; i < sections.length; i++) {
    final c = kOrbitContinent[sections[i].id];
    if (c != null && used.add(c)) {
      picked[i] = c;
    } else {
      unplaced.add(i);
    }
  }
  for (final i in unplaced) {
    Continent? free;
    for (final c in Continent.values) {
      if (!used.contains(c)) {
        free = c;
        break;
      }
    }
    if (free == null) break;
    used.add(free);
    picked[i] = free;
  }

  final hubs = <GlobeHub>[];
  for (var i = 0; i < sections.length; i++) {
    final c = picked[i];
    if (c == null) continue;
    final s = sections[i];
    hubs.add(GlobeHub(
      pin: EarthPin(sectionIndex: i, continent: c, label: s.label, icon: s.icon),
      nodes: placeNodes(c, s.destinations.length),
    ));
  }
  return hubs;
}

// ---------------------------------------------------------------------------
// Placing the screen nodes on the land of a continent
// ---------------------------------------------------------------------------

final Map<int, List<LatLon>> _placed = <int, List<LatLon>>{};

/// [count] positions on the land of [c], spread around its anchor, inside the
/// part of the continent the camera sees once it has dived in. They are sorted
/// by angle around the anchor, so lines drawn from one to the next never cross.
/// Pure and deterministic; the result is cached.
List<LatLon> placeNodes(Continent c, int count) {
  if (count <= 0) return const <LatLon>[];
  return _placed.putIfAbsent(c.index * 1000 + count, () => _computeNodes(c, count));
}

class _Cand {
  const _Cand(this.dx, this.dy, this.lat, this.lon);
  final double dx, dy, lat, lon;
}

List<LatLon> _computeNodes(Continent c, int count) {
  final info = kContinentInfo[c.index];
  final cosLat = math.max(0.35, math.cos(info.lat * math.pi / 180));
  // Half-size, in degrees of arc, of what the camera sees at this continent's zoom.
  final aDeg = 39.8 / info.zoom;
  final bDeg = 26.0 / info.zoom;
  const golden = 2.399963229728653;

  var minSep = 0.42;
  var chosen = <_Cand>[];
  for (var pass = 0; pass < 4; pass++) {
    chosen = <_Cand>[];
    for (var k = 1; k <= 600 && chosen.length < count; k++) {
      final rho = math.sqrt(k / 600.0) * 0.95;
      final th = k * golden;
      final dx = rho * math.cos(th), dy = rho * math.sin(th);
      final lat = info.lat + bDeg * dy;
      final lon = info.lon + aDeg * dx / cosLat;
      if (lat < -89 || lat > 89) continue;
      if (!earthIsLand(lat, lon) || continentAt(lat, lon) != c) continue;
      if (math.sqrt(dx * dx + dy * dy) < minSep) continue; // keep clear of the hub
      var clear = true;
      for (final q in chosen) {
        final ex = dx - q.dx, ey = dy - q.dy;
        if (math.sqrt(ex * ex + ey * ey) < minSep) {
          clear = false;
          break;
        }
      }
      if (clear) chosen.add(_Cand(dx, dy, lat, lon));
    }
    if (chosen.length == count) break;
    minSep *= 0.7;
  }
  // Never happens with the shipped map; keeps the list the right length anyway.
  while (chosen.length < count) {
    chosen.add(_Cand(0, 0, info.lat, info.lon));
  }
  chosen.sort((a, b) => math.atan2(a.dy, a.dx).compareTo(math.atan2(b.dy, b.dx)));
  return List<LatLon>.unmodifiable([for (final q in chosen) LatLon(q.lat, q.lon)]);
}

// ---------------------------------------------------------------------------
// Small 3D helpers (same projection as EarthProjection)
// ---------------------------------------------------------------------------

List<double> _unit(double latDeg, double lonDeg) {
  final la = latDeg * math.pi / 180, lo = lonDeg * math.pi / 180;
  final cl = math.cos(la);
  return [cl * math.sin(lo), math.sin(la), cl * math.cos(lo)];
}

class _Cam {
  _Cam(this.c, this.r, double yaw, double pitch)
      : cyw = math.cos(yaw),
        syw = math.sin(yaw),
        cp = math.cos(pitch),
        sp = math.sin(pitch);

  final Offset c;
  final double r, cyw, syw, cp, sp;

  /// Screen position and depth (1 = facing the viewer, < 0 = behind the Earth)
  /// of a 3D point. A unit vector is a point on the surface; longer is lifted.
  (Offset, double) p3(double x0, double y0, double z0) {
    final x1 = x0 * cyw + z0 * syw;
    final z1 = -x0 * syw + z0 * cyw;
    final y2 = y0 * cp - z1 * sp;
    final z2 = y0 * sp + z1 * cp;
    return (Offset(c.dx + r * x1, c.dy - r * y2), z2);
  }
}

/// A great-circle arc between two points, lifted above the surface in the
/// middle so it reads as a link floating over the Earth.
class _Arc {
  _Arc._(this.va, this.vb, this.om, this.lift);

  factory _Arc(LatLon a, LatLon b, {double base = 0.03, double span = 0.10}) {
    final va = _unit(a.lat, a.lon), vb = _unit(b.lat, b.lon);
    final d = (va[0] * vb[0] + va[1] * vb[1] + va[2] * vb[2]).clamp(-1.0, 1.0).toDouble();
    final om = math.acos(d);
    return _Arc._(va, vb, om, base + span * om / math.pi);
  }

  final List<double> va, vb;
  final double om, lift;

  bool get valid => om > 1e-3 && om < math.pi - 0.05;

  (double, double, double) at(double t) {
    final so = math.sin(om);
    final ka = math.sin((1 - t) * om) / so;
    final kb = math.sin(t * om) / so;
    final k = 1 + lift * math.sin(math.pi * t);
    return (
      (va[0] * ka + vb[0] * kb) * k,
      (va[1] * ka + vb[1] * kb) * k,
      (va[2] * ka + vb[2] * kb) * k,
    );
  }

  /// The visible part of the arc (the far side of the Earth is skipped).
  Path path(_Cam cam) {
    final p = Path();
    final steps = math.max(8, (om * 16).ceil());
    var pen = false;
    for (var i = 0; i <= steps; i++) {
      final (x, y, z) = at(i / steps);
      final (o, z2) = cam.p3(x, y, z);
      if (z2 < 0.03) {
        pen = false;
        continue;
      }
      if (pen) {
        p.lineTo(o.dx, o.dy);
      } else {
        p.moveTo(o.dx, o.dy);
        pen = true;
      }
    }
    return p;
  }
}

// ---------------------------------------------------------------------------
// The renderer. Plain Dart, one canvas pass: it owns drawing AND hit-testing,
// so what the user sees is exactly what the user can tap.
// ---------------------------------------------------------------------------

class GlobeRenderer {
  GlobeRenderer() {
    // 4 light levels per continent (+1 "other land"), one draw call each.
    for (var c = 0; c <= kOtherLand; c++) {
      final cap = _model.continentCounts[c] * 2;
      for (var l = 0; l < _levels; l++) {
        _landBuf.add(Float32List(cap));
      }
    }
  }

  static const int _levels = 4;
  static const double _pinR = 15;
  static const double _pinHitPx = 30;
  static const double _nodeHitPx = 28;
  static const double _hitSlackPx = 24;

  // Dim amber -> gold -> bright gold -> hot champagne (the lit dots).
  static const List<Color> _levelColor = [
    Color(0xFFB8860B),
    Color(0xFFD4AF37),
    Color(0xFFFFC94D),
    Color(0xFFFFF0B8),
  ];
  static const List<double> _levelAlpha = [0.30, 0.55, 0.82, 1.0];
  static const List<double> _levelWidth = [0.80, 0.92, 1.0, 1.1];

  // x, y (fraction of the screen), radius, alpha, drift loops (whole numbers).
  static const List<List<double>> _bokeh = [
    [0.10, 0.22, 22, 0.050, 3],
    [0.86, 0.16, 30, 0.045, 2],
    [0.72, 0.34, 14, 0.070, 5],
    [0.20, 0.52, 36, 0.040, 2],
    [0.93, 0.50, 18, 0.060, 4],
    [0.40, 0.12, 12, 0.060, 3],
    [0.62, 0.62, 26, 0.035, 2],
    [0.06, 0.74, 16, 0.055, 4],
    [0.80, 0.80, 24, 0.040, 3],
  ];

  final EarthModel _model = EarthModel.instance;
  final StarField _stars = StarField();
  final Map<String, TextPainter> _tp = {};
  final List<Float32List> _landBuf = [];
  late final Float32List _oceanBuf = Float32List(_model.oceanCount * 2);
  final Paint _dot = Paint()..strokeCap = StrokeCap.round;

  // ------------------------------------------------------------ live state

  /// One hub per section (see [buildGlobeHubs]).
  List<GlobeHub> hubs = const [];

  /// Camera. [zoom] multiplies the base radius; [cxFrac] / [cyFrac] place the
  /// center of the Earth on the screen (as a fraction of width / height).
  double yaw = -0.35, pitch = 0.32, zoom = 1.0, cxFrac = 0.5, cyFrac = 0.40, roll = 0.0;

  /// 0 = whole Earth, 1 = zoomed into a continent.
  double focus = 0.0;

  /// Hub (index in [hubs]) that is selected or open, if any.
  int? openHub;

  /// Screen node (index in the open hub's nodes) that is highlighted.
  int? selectedNode;
  String? selectedNodeLabel;

  /// 0..1: how visible the screen nodes of the open hub are.
  double nodesAlpha = 0.0;

  /// Light beam from the info card (screen rectangle) to the selected hub.
  Rect? beamFrom;
  double beamAlpha = 0.0;

  /// Whether taps may select a hub (off while a continent is fully open).
  bool hubHitEnabled = true;

  /// Ambient loop position 0..1 (one loop = 120 s).
  double u = 0.083;

  // ------------------------------------------------------------------ layout

  /// Radius of the whole Earth: a little wider than the screen, like the design.
  double baseRadius(Size s) => math.min(s.width * 0.56, s.height * 0.34);

  double radius(Size s) => baseRadius(s) * zoom;

  Offset center(Size s) => Offset(s.width * cxFrac, s.height * cyFrac);

  EarthProjection projection(Size s) =>
      EarthProjection(yaw: yaw, pitch: pitch, center: center(s), radius: radius(s));

  // --------------------------------------------------------------- hit tests

  /// Which hub (index in [hubs]) is under [p]? The pin itself or the land of
  /// its continent both count.
  int? hitHub(Offset p, Size s) {
    if (!hubHitEnabled || hubs.isEmpty) return null;
    final proj = projection(s);

    int? best;
    var bestZ = -9.0;
    for (var i = 0; i < hubs.length; i++) {
      final info = hubs[i].info;
      final pt = proj.project(info.lat, info.lon);
      if (pt.z < 0.2) continue;
      if ((p - pt.offset).distance <= _pinHitPx && pt.z > bestZ) {
        best = i;
        bestZ = pt.z;
      }
    }
    if (best != null) return best;

    // Land: look under the finger, then in growing rings around it.
    final ll = proj.unproject(p, slackPx: _hitSlackPx);
    if (ll == null) return null;
    final tol = _hitSlackPx / proj.radius * 180 / math.pi; // finger radius in degrees
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
        for (var i = 0; i < hubs.length; i++) {
          if (hubs[i].continent == c) return i;
        }
      }
    }
    return null;
  }

  /// Which screen node of the open hub is under [p]?
  int? hitNode(Offset p, Size s) {
    final h = openHub;
    if (h == null || h >= hubs.length || nodesAlpha < 0.5) return null;
    final proj = projection(s);
    final nodes = hubs[h].nodes;
    int? best;
    var bestD = _nodeHitPx;
    for (var i = 0; i < nodes.length; i++) {
      final pt = proj.project(nodes[i].lat, nodes[i].lon);
      if (pt.z < 0.2) continue;
      final d = (p - pt.offset).distance;
      if (d <= bestD) {
        best = i;
        bestD = d;
      }
    }
    return best;
  }

  // ------------------------------------------------------------------- paint

  void paint(Canvas canvas, Size s) {
    if (s.isEmpty) return;
    canvas.drawRect(Offset.zero & s, Paint()..color = OrbitPalette.space);
    final c = center(s);
    final r = radius(s);
    if (r <= 0) return;
    final f = focus.clamp(0.0, 1.0).toDouble();

    _backdrop(canvas, s, c, r);

    canvas.save();
    if (roll != 0) {
      // A touch of camera roll while flying in/out: it makes the move feel 3D.
      canvas.translate(c.dx, c.dy);
      canvas.rotate(roll);
      canvas.translate(-c.dx, -c.dy);
    }

    _globe(canvas, s, c, r, f);
    final cam = _Cam(c, r, yaw, pitch);
    _network(canvas, cam, f);
    _flare(canvas, c, r, f);

    final oi = openHub;
    final open = (oi != null && oi < hubs.length) ? oi : null;
    if (open != null) {
      _beam(canvas, cam, open);
      _nodes(canvas, s, cam, open);
    }
    _hubPins(canvas, s, cam, f, open);
    canvas.restore();
  }

  // ---------------------------------------------------------------- backdrop

  void _backdrop(Canvas canvas, Size s, Offset c, double r) {
    // A warm glow behind the Earth.
    final glowR = r * 1.7;
    canvas.drawCircle(
      c,
      glowR,
      Paint()
        ..shader = ui.Gradient.radial(c, glowR, [
          OrbitPalette.amber.withValues(alpha: 0.20),
          OrbitPalette.amber.withValues(alpha: 0.0),
        ]),
    );
    paintStars(canvas, s, _stars, u);

    // Slow out-of-focus lights, like the design.
    final bp = Paint();
    for (final b in _bokeh) {
      final ph = u * 2 * math.pi * b[4];
      final x = (b[0] + 0.015 * math.sin(ph + b[0] * 9)) * s.width;
      final y = (b[1] + 0.012 * math.cos(ph + b[1] * 7)) * s.height;
      bp
        ..style = PaintingStyle.fill
        ..strokeWidth = 1
        ..color = OrbitPalette.gold.withValues(alpha: b[3]);
      canvas.drawCircle(Offset(x, y), b[2], bp);
      bp
        ..style = PaintingStyle.stroke
        ..color = OrbitPalette.champagne.withValues(alpha: b[3] * 1.6);
      canvas.drawCircle(Offset(x, y), b[2], bp);
    }
  }

  // ------------------------------------------------------------------- globe

  int? _focusContinent() {
    final h = openHub;
    if (h == null || h >= hubs.length) return null;
    return hubs[h].continent.index;
  }

  void _globe(Canvas canvas, Size s, Offset c, double r, double f) {
    final rect = Rect.fromCircle(center: c, radius: r);
    final focusIdx = _focusContinent();

    // Atmosphere: a thin warm glow just outside the rim.
    canvas.drawCircle(
      c,
      r * 1.3,
      Paint()
        ..shader = ui.Gradient.radial(
          c,
          r * 1.3,
          [
            OrbitPalette.gold.withValues(alpha: 0.0),
            OrbitPalette.gold.withValues(alpha: 0.0),
            OrbitPalette.gold.withValues(alpha: 0.30 - 0.12 * f),
            OrbitPalette.gold.withValues(alpha: 0.0),
          ],
          const [0.0, 0.765, 0.80, 1.0],
        ),
    );

    // Ocean body: black with a warm light from the left.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.55, -0.15),
          radius: 1.05,
          colors: [Color(0xFF2B2010), Color(0xFF0D0A04), Color(0xFF020201)],
          stops: [0.0, 0.55, 1.0],
        ).createShader(rect),
    );

    // Projection constants for this frame.
    final cyw = math.cos(yaw), syw = math.sin(yaw);
    final cp = math.cos(pitch), sp = math.sin(pitch);
    final w = s.width, h = s.height;
    final pad = 40.0 + r * 0.02;
    final dotW = (r * 0.0105).clamp(1.8, 3.4).toDouble();

    // Light from the left (unit vector): the flare sits on that side.
    const lxv = -0.78, lyv = 0.30, lzv = 0.55;
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
        ..strokeWidth = math.max(1.1, dotW * 0.42)
        ..color = OrbitPalette.gold.withValues(alpha: 0.11 * (1 - 0.4 * f));
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
      final shade = 0.25 * z2 + 0.75 * (lit > 0 ? lit : 0.0);
      final level = shade < 0.26 ? 0 : (shade < 0.48 ? 1 : (shade < 0.72 ? 2 : 3));
      final bin = lcs[i] * _levels + level;
      final buf = _landBuf[bin];
      final n = counts[bin]++;
      buf[n * 2] = sx;
      buf[n * 2 + 1] = sy;
    }

    final active = List<bool>.filled(kOtherLand + 1, false);
    for (final hub in hubs) {
      active[hub.continent.index] = true;
    }
    // Other continents first, the open one last (drawn on top).
    final order = <int>[
      for (var k = 0; k <= kOtherLand; k++)
        if (k != focusIdx) k,
      if (focusIdx != null) focusIdx,
    ];
    for (final k in order) {
      final isFocus = k == focusIdx;
      // Continents that are not open dim down while zoomed in; land without a
      // section is always a little quieter.
      var mult = isFocus ? 1.0 : 1.0 - 0.62 * f;
      if (k == kOtherLand || !active[k]) mult *= 0.55;

      // Soft glow under the brightest dots.
      for (final l in const [3, 2]) {
        final n = counts[k * _levels + l];
        if (n == 0) continue;
        _dot
          ..strokeWidth = dotW * 3.0
          ..color = _levelColor[l].withValues(alpha: (l == 3 ? 0.10 : 0.05) * mult);
        canvas.drawRawPoints(
            ui.PointMode.points, Float32List.sublistView(_landBuf[k * _levels + l], 0, n * 2), _dot);
      }
      for (var l = 0; l < _levels; l++) {
        final bin = k * _levels + l;
        final n = counts[bin];
        if (n == 0) continue;
        _dot
          ..strokeWidth = dotW * _levelWidth[l] * (isFocus ? 1.0 + 0.15 * f : 1.0)
          ..color = _levelColor[l].withValues(alpha: (_levelAlpha[l] * mult).clamp(0.0, 1.0).toDouble());
        canvas.drawRawPoints(ui.PointMode.points, Float32List.sublistView(_landBuf[bin], 0, n * 2), _dot);
      }
    }

    // Terminator + limb darkening, then a rim light on the lit side.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.55, -0.15),
          radius: 1.3,
          colors: [Color(0x00000000), Color(0x30000000), Color(0xC8000000)],
          stops: [0.45, 0.80, 1.0],
        ).createShader(rect),
    );
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, r * 0.012)
        ..shader = SweepGradient(
          colors: [
            OrbitPalette.champagne.withValues(alpha: 0.12),
            OrbitPalette.champagne.withValues(alpha: 0.90 * (1 - 0.5 * f)),
            OrbitPalette.champagne.withValues(alpha: 0.12),
          ],
          stops: const [0.0, 0.5, 1.0],
          transform: const GradientRotation(0.15),
        ).createShader(rect),
    );
  }

  // ------------------------------------------------------------------ flare

  /// The sun flare on the lit edge of the Earth (fades out as the camera dives).
  void _flare(Canvas canvas, Offset c, double r, double f) {
    final k = 1.0 - 0.85 * f;
    if (k <= 0.02) return;
    const phi = math.pi + 0.15;
    final p = c + Offset(math.cos(phi), math.sin(phi)) * (r * 0.985);
    final pulse = 1 + 0.05 * math.sin(u * 2 * math.pi * 30);
    final add = Paint()..blendMode = BlendMode.plus;

    final g1 = r * 0.62 * pulse;
    canvas.drawCircle(
      p,
      g1,
      add
        ..shader = ui.Gradient.radial(p, g1, [
          const Color(0xFFFFB347).withValues(alpha: 0.30 * k),
          const Color(0x00FFB347),
        ]),
    );
    final g2 = r * 0.17 * pulse;
    canvas.drawCircle(
      p,
      g2,
      add
        ..shader = ui.Gradient.radial(
          p,
          g2,
          [
            Colors.white.withValues(alpha: 0.95 * k),
            const Color(0xFFFFE08A).withValues(alpha: 0.55 * k),
            const Color(0x00FFB347),
          ],
          const [0.0, 0.35, 1.0],
        ),
    );
    // Horizontal streak.
    final sw = r * 0.78;
    canvas.drawOval(
      Rect.fromCenter(center: p, width: sw * 2, height: math.max(1.6, r * 0.016)),
      add
        ..shader = ui.Gradient.linear(
          Offset(p.dx - sw, p.dy),
          Offset(p.dx + sw, p.dy),
          [
            const Color(0x00FFE9B0),
            const Color(0xFFFFE9B0).withValues(alpha: 0.85 * k),
            const Color(0x00FFE9B0),
          ],
          const [0.0, 0.5, 1.0],
        ),
    );
    // Faint ghosts along the line towards the center of the Earth.
    final ghost = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..blendMode = BlendMode.plus;
    for (final t in const [0.35, 0.62, 0.9]) {
      final q = Offset.lerp(p, c, t)!;
      ghost.color = const Color(0xFFFFD27A).withValues(alpha: 0.12 * k);
      canvas.drawCircle(q, r * (0.05 + 0.03 * t), ghost);
    }
  }

  // ----------------------------------------------------------------- network

  /// Glowing arcs between the hubs, with a small light travelling along each.
  void _network(Canvas canvas, _Cam cam, double f) {
    final n = hubs.length;
    if (n < 2) return;
    final vis = 1.0 - 0.7 * f;

    final edges = <(int, int)>[];
    for (var i = 0; i < n; i++) {
      final j = (i + 1) % n;
      if (n == 2 && i == 1) break;
      edges.add((i, j));
    }
    if (n >= 6) {
      for (var i = 0; i < n ~/ 2; i++) {
        edges.add((i, i + n ~/ 2));
      }
    }

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = OrbitPalette.gold.withValues(alpha: 0.42 * vis);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4
      ..color = OrbitPalette.gold.withValues(alpha: 0.07 * vis);
    final halo = Paint()..color = OrbitPalette.gold.withValues(alpha: 0.22 * vis);
    final core = Paint()..color = OrbitPalette.champagne.withValues(alpha: 0.95 * vis);

    for (var e = 0; e < edges.length; e++) {
      final a = hubs[edges[e].$1].info, b = hubs[edges[e].$2].info;
      final arc = _Arc(LatLon(a.lat, a.lon), LatLon(b.lat, b.lon));
      if (!arc.valid) continue;
      final path = arc.path(cam);
      canvas.drawPath(path, glow);
      canvas.drawPath(path, line);

      final t = (u * 30 + e * 0.37) % 1.0;
      final (px, py, pz) = arc.at(t);
      final (o, z) = cam.p3(px, py, pz);
      if (z > 0.1) {
        canvas.drawCircle(o, 7, halo);
        canvas.drawCircle(o, 2.3, core);
      }
    }
  }

  // -------------------------------------------------------------------- beam

  /// The translucent cone of light from the info card to the selected hub.
  void _beam(Canvas canvas, _Cam cam, int hi) {
    final from = beamFrom;
    final a = beamAlpha.clamp(0.0, 1.0).toDouble();
    if (from == null || a < 0.02) return;
    final info = hubs[hi].info;
    final v = _unit(info.lat, info.lon);
    final (apex, z) = cam.p3(v[0], v[1], v[2]);
    if (z < 0.1) return;

    final p0 = Offset(from.right - 6, from.top + from.height * 0.10);
    final p1 = Offset(from.right - 6, from.top + from.height * 0.80);
    final cone = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(apex.dx, apex.dy)
      ..lineTo(p1.dx, p1.dy)
      ..close();
    canvas.drawPath(
      cone,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(from.right, apex.dy),
          apex,
          [
            const Color(0xFFFFF1BD).withValues(alpha: 0.26 * a),
            const Color(0xFFFFD36B).withValues(alpha: 0.03 * a),
          ],
        ),
    );
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = OrbitPalette.champagne.withValues(alpha: 0.35 * a);
    canvas.drawLine(p0, apex, edge);
    canvas.drawLine(p1, apex, edge);
  }

  // ------------------------------------------------------------- screen nodes

  /// The open hub's screen nodes, joined to the hub and to each other.
  void _nodes(Canvas canvas, Size s, _Cam cam, int hi) {
    final hub = hubs[hi];
    final na = nodesAlpha.clamp(0.0, 1.0).toDouble();
    if (na < 0.02 || hub.nodes.isEmpty) return;
    final from = LatLon(hub.info.lat, hub.info.lon);

    final line = Paint()..style = PaintingStyle.stroke;
    for (var i = 0; i < hub.nodes.length; i++) {
      final sel = selectedNode == i;
      line
        ..strokeWidth = sel ? 1.7 : 1.0
        ..color = OrbitPalette.gold.withValues(alpha: (sel ? 0.9 : 0.40) * na);
      final spoke = _Arc(from, hub.nodes[i], base: 0.01, span: 0.04);
      if (spoke.valid) canvas.drawPath(spoke.path(cam), line);
      if (i + 1 < hub.nodes.length) {
        line
          ..strokeWidth = 0.8
          ..color = OrbitPalette.gold.withValues(alpha: 0.22 * na);
        final link = _Arc(hub.nodes[i], hub.nodes[i + 1], base: 0.01, span: 0.04);
        if (link.valid) canvas.drawPath(link.path(cam), line);
      }
    }
    for (var i = 0; i < hub.nodes.length; i++) {
      _nodeDot(canvas, s, cam, hub.nodes[i], selectedNode == i, na);
    }
  }

  void _nodeDot(Canvas canvas, Size s, _Cam cam, LatLon p, bool sel, double na) {
    final v = _unit(p.lat, p.lon);
    final (o, z) = cam.p3(v[0], v[1], v[2]);
    if (z < 0.12) return;
    if (o.dx < -40 || o.dx > s.width + 40 || o.dy < -40 || o.dy > s.height + 40) return;
    final k = ((z - 0.12) / 0.3).clamp(0.0, 1.0).toDouble();
    final a = k * na;
    final pulse = 1 + 0.12 * math.sin(u * 2 * math.pi * 50 + p.lon);

    canvas.drawCircle(
      o,
      17,
      Paint()
        ..shader = ui.Gradient.radial(o, 17, [
          OrbitPalette.gold.withValues(alpha: 0.42 * a),
          OrbitPalette.gold.withValues(alpha: 0.0),
        ]),
    );
    canvas.drawCircle(
      o,
      (sel ? 11.5 : 8.0) * pulse,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = sel ? 1.8 : 1.2
        ..color = OrbitPalette.champagne.withValues(alpha: (sel ? 0.95 : 0.55) * a),
    );
    canvas.drawCircle(
      o,
      sel ? 4.6 : 3.4,
      Paint()..color = (sel ? Colors.white : OrbitPalette.champagne).withValues(alpha: a),
    );

    final text = selectedNodeLabel;
    if (sel && text != null) {
      final label = _labelPainter(text, 11.5, OrbitPalette.text);
      label.paint(canvas, Offset(o.dx - label.width / 2, o.dy - 24 - label.height));
    }
  }

  // --------------------------------------------------------------- hub pins

  void _hubPins(Canvas canvas, Size s, _Cam cam, double f, int? open) {
    // Far side first.
    final order = <int>[for (var i = 0; i < hubs.length; i++) i]..sort((a, b) {
        final ia = hubs[a].info, ib = hubs[b].info;
        final va = _unit(ia.lat, ia.lon), vb = _unit(ib.lat, ib.lon);
        final za = cam.p3(va[0], va[1], va[2]).$2;
        final zb = cam.p3(vb[0], vb[1], vb[2]).$2;
        return za.compareTo(zb);
      });
    // 1 on the whole-Earth view and while selected, 0 once fully dived in.
    final big = 1.0 - ((f - 0.5) / 0.4).clamp(0.0, 1.0).toDouble();
    for (final i in order) {
      if (i == open) continue;
      // Other hubs fade as the camera dives into a continent.
      _hubPin(canvas, s, cam, i, 1.0 - 0.9 * f, isOpen: false, big: 0);
    }
    if (open != null) {
      _hubPin(canvas, s, cam, open, 1.0, isOpen: true, big: big);
    }
  }

  void _hubPin(Canvas canvas, Size s, _Cam cam, int i, double visible,
      {required bool isOpen, required double big}) {
    final hub = hubs[i];
    final info = hub.info;
    final v = _unit(info.lat, info.lon);
    final (o, z) = cam.p3(v[0], v[1], v[2]);
    if (z < 0.12) return;
    if (o.dx < -70 || o.dx > s.width + 70 || o.dy < -70 || o.dy > s.height + 70) return;
    final k = ((z - 0.12) / 0.35).clamp(0.0, 1.0).toDouble();
    final alpha = (k * visible).clamp(0.0, 1.0).toDouble();
    if (alpha < 0.02) return;

    final scale = isOpen ? 1.0 : 0.88 + 0.24 * z;
    final pulse = 1 + 0.10 * math.sin(u * 2 * math.pi * 40 + i * 1.3);
    final ringR = _pinR + (34 - _pinR) * big; // the selected hub grows a big halo
    final coreR = _pinR - 3 * big;

    // An offscreen layer only to fade the pin; a fully visible pin (the usual
    // case) skips it, which saves one GPU layer per pin per frame.
    if (alpha >= 0.995) {
      canvas.save();
    } else {
      canvas.saveLayer(
        Rect.fromCircle(center: o, radius: ringR * scale * 3 + 40),
        Paint()..color = Color.fromRGBO(0, 0, 0, alpha),
      );
    }
    canvas.translate(o.dx, o.dy);
    canvas.scale(scale);

    // Soft halo.
    canvas.drawCircle(
      Offset.zero,
      ringR * 2.3,
      Paint()
        ..shader = ui.Gradient.radial(Offset.zero, ringR * 2.3, [
          OrbitPalette.gold.withValues(alpha: 0.40),
          OrbitPalette.gold.withValues(alpha: 0.0),
        ]),
    );

    if (big > 0.02) {
      // Selected: a glass disc with a slowly turning ring of dots (like the design).
      canvas.drawCircle(Offset.zero, ringR, Paint()..color = const Color(0xFFFFF1BD).withValues(alpha: 0.10 * big));
      canvas.drawCircle(
        Offset.zero,
        ringR,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = OrbitPalette.champagne.withValues(alpha: 0.8 * big),
      );
      final turn = u * 2 * math.pi * 12;
      final dots = Paint()..color = OrbitPalette.champagne.withValues(alpha: 0.85 * big);
      for (var d = 0; d < 28; d++) {
        final a = turn + d * 2 * math.pi / 28;
        canvas.drawCircle(Offset(math.cos(a), math.sin(a)) * (ringR * 0.76), 1.3, dots);
      }
      canvas.drawCircle(
        Offset.zero,
        ringR * 0.52,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9
          ..color = OrbitPalette.gold.withValues(alpha: 0.6 * big),
      );
    } else {
      canvas.drawCircle(
        Offset.zero,
        _pinR * 1.28 * pulse,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = OrbitPalette.gold.withValues(alpha: 0.55),
      );
    }

    // Disc with the section icon.
    final disc = Rect.fromCircle(center: Offset.zero, radius: coreR);
    canvas.drawCircle(
      Offset.zero,
      coreR,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.4, -0.45),
          radius: 1.05,
          colors: [Color(0xFFFFF1BD), Color(0xFFE6B93C), Color(0xFF6E5216)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(disc),
    );
    canvas.drawCircle(
      Offset.zero,
      coreR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = OrbitPalette.champagne.withValues(alpha: 0.75),
    );
    final glyph = _iconPainter(hub.pin.icon, coreR * 1.2, OrbitPalette.deep);
    glyph.paint(canvas, Offset(-glyph.width / 2, -glyph.height / 2));

    // The selected hub has the info card as its label.
    if (!isOpen) {
      final label = _labelPainter(hub.pin.label, 11, OrbitPalette.text);
      label.paint(canvas, Offset(-label.width / 2, _pinR + 6));
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
      )..layout(maxWidth: 140);
    });
  }
}
