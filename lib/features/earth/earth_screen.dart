import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart' show Game;
import '../../data/providers.dart';
import '../notifications/notifications_screen.dart';
import '../orbit/models/orbit_destination.dart';
import '../orbit/orbit_sections.dart';
import '../orbit/widgets/planet_painters.dart' show OrbitPalette;
import '../settings/settings_screen.dart';
import 'earth_scene.dart';
import 'earth_sections.dart';

/// SPHERA EARTH: a giant Earth fills the screen. Every app section lives on
/// its own continent. Drag to turn the Earth, tap a continent (or one of the
/// shortcut chips) and the camera dives into it: the continent lights up and
/// a panel shows everything that is inside that section.
class EarthScreen extends ConsumerStatefulWidget {
  const EarthScreen({super.key});

  @override
  ConsumerState<EarthScreen> createState() => _EarthScreenState();
}

class _EarthScreenState extends ConsumerState<EarthScreen> with TickerProviderStateMixin {
  // Ambient loop (stars, pin pulses): one loop = 120 s.
  late final AnimationController _ambient =
      AnimationController(vsync: this, duration: const Duration(seconds: 120));
  // Camera move (whole Earth <-> continent). One run = one move, 0..1.
  late final AnimationController _cam =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  // The panel with the content of the open continent (comes in after the camera).
  late final AnimationController _panel = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    reverseDuration: const Duration(milliseconds: 320),
  );

  final EarthRenderer _renderer = EarthRenderer();

  // ---- spin: slow auto-rotation + drag with inertia ----
  /// Resting speed: one full turn every 90 seconds. Change this to spin faster.
  static const double _autoSpin = 2 * math.pi / 90;
  static const double _maxSpin = 8.0; // rad/s, cap after a hard fling
  static const double _inertiaTau = 2.2; // seconds: higher = heavier Earth
  static const double _overviewPitch = 0.32;
  static const double _overviewCy = 0.46;

  late final Ticker _spinTicker = createTicker(_onSpinTick);
  final ValueNotifier<int> _spinRepaint = ValueNotifier<int>(0);
  double _spinVel = _autoSpin;
  bool _dragging = false;
  Duration _lastTick = Duration.zero;

  // ---- live camera (what the renderer draws) ----
  double _yaw = -0.35; // starts with Europe / Africa facing the viewer
  double _pitch = _overviewPitch;
  double _zoom = 1.0;
  double _cyFrac = _overviewCy;
  double _roll = 0.0;

  // ---- camera move: from -> to ----
  double _fYaw = 0, _fPitch = 0, _fZoom = 1, _fCy = 0;
  double _tYaw = 0, _tPitch = 0, _tZoom = 1, _tCy = 0;
  double _rollDir = 1;
  bool _returning = false;

  List<OrbitSection> _sections = const [];
  List<EarthPin> _pins = const [];
  Size _size = Size.zero;

  int? _pin; // open pin (index in _pins), kept until the return move ends
  bool _opening = false;
  bool _reduce = false;
  bool _hintVisible = true;
  Timer? _hintTimer;

  @override
  void initState() {
    super.initState();
    _cam.addListener(_onCam);
    _cam.addStatusListener((status) {
      if (status == AnimationStatus.completed && _returning && mounted) {
        _spinVel = _autoSpin;
        setState(() {
          _pin = null;
          _returning = false;
        });
      }
    });
    _hintTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) setState(() => _hintVisible = false);
    });
    _spinTicker.start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (reduce != _reduce || !_ambient.isAnimating) {
      _reduce = reduce;
      _cam.duration = Duration(milliseconds: reduce ? 150 : 1200);
      _panel.duration = Duration(milliseconds: reduce ? 150 : 900);
      if (reduce) {
        _ambient.stop();
      } else if (!_ambient.isAnimating) {
        _ambient.repeat();
      }
    }
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _spinTicker.dispose();
    _spinRepaint.dispose();
    _ambient.dispose();
    _cam.dispose();
    _panel.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------ spin

  void _onSpinTick(Duration elapsed) {
    final dt = ((elapsed - _lastTick).inMicroseconds / 1e6).clamp(0.0, 0.05).toDouble();
    _lastTick = elapsed;
    if (dt == 0 || _dragging || _pin != null || _cam.isAnimating) return;
    final target = _reduce ? 0.0 : _autoSpin;
    // Ease back to the resting speed (also brakes a fast fling smoothly).
    _spinVel += (target - _spinVel) * (1 - math.exp(-dt / _inertiaTau));
    if (_reduce && _spinVel.abs() < 0.001) return;
    _yaw = (_yaw + _spinVel * dt) % (2 * math.pi);
    _spinRepaint.value++;
  }

  bool get _canInteract => _pin == null && !_cam.isAnimating;

  double get _baseR => _renderer.baseRadius(_size);

  void _onDragStart(DragStartDetails d) {
    if (!_canInteract) return;
    _dragging = true;
    _spinVel = 0;
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (!_dragging) return;
    final r = _baseR;
    if (r <= 0) return;
    // The surface follows the finger: right/down moves the Earth right/down.
    _yaw = (_yaw + d.delta.dx / r) % (2 * math.pi);
    _pitch = (_pitch + d.delta.dy / r).clamp(-0.9, 0.9).toDouble();
    _spinRepaint.value++;
  }

  void _onDragEnd(DragEndDetails d) {
    if (!_dragging) return;
    final r = _baseR;
    _spinVel = r <= 0 ? _autoSpin : (d.velocity.pixelsPerSecond.dx / r).clamp(-_maxSpin, _maxSpin).toDouble();
    _dragging = false;
  }

  void _onDragCancel() => _dragging = false;

  // ---------------------------------------------------------------- camera

  static double _angDelta(double from, double to) {
    var d = (to - from) % (2 * math.pi);
    if (d > math.pi) d -= 2 * math.pi;
    return d;
  }

  void _onCam() {
    final t = Curves.easeInOutCubic.transform(_cam.value);
    _yaw = _fYaw + _angDelta(_fYaw, _tYaw) * t;
    _pitch = _fPitch + (_tPitch - _fPitch) * t;
    // Zoom geometrically: the dive feels even from start to end.
    _zoom = _fZoom * math.pow(_tZoom / _fZoom, t).toDouble();
    _cyFrac = _fCy + (_tCy - _fCy) * t;
    // A little camera roll in the middle of the move gives it a 3D feel.
    _roll = math.sin(t * math.pi) * 0.06 * _rollDir;
  }

  void _beginMove({
    required double yaw,
    required double pitch,
    required double zoom,
    required double cy,
  }) {
    _fYaw = _yaw;
    _fPitch = _pitch;
    _fZoom = _zoom;
    _fCy = _cyFrac;
    _tYaw = yaw;
    _tPitch = pitch;
    _tZoom = zoom;
    _tCy = cy;
    _rollDir = _angDelta(_fYaw, _tYaw) >= 0 ? 1.0 : -1.0;
    _cam.forward(from: 0);
  }

  double get _panelHeight => (_size.height * 0.47).clamp(300.0, 470.0).toDouble();

  /// Where the open continent sits on screen: centered in the free space
  /// between the top bar + title and the content panel.
  double get _stageCenterFrac {
    if (_size.height <= 0) return 0.3;
    final top = MediaQuery.paddingOf(context).top + 48 + 52;
    final bottom = _size.height - _panelHeight;
    return ((top + bottom) / 2 / _size.height).clamp(0.2, 0.5).toDouble();
  }

  void _sync() {
    _renderer
      ..pins = _pins
      ..yaw = _yaw
      ..pitch = _pitch
      ..zoom = _zoom
      ..cyFrac = _cyFrac
      ..roll = _roll
      // 0 on the whole Earth, 1 once the camera is deep inside a continent.
      ..focus = (_zoom - 1.0).clamp(0.0, 1.0).toDouble()
      ..focusPin = _pin
      ..u = _reduce ? 0.083 : _ambient.value;
  }

  // ---------------------------------------------------------- interactions

  void _openPin(int pi) {
    if (_cam.isAnimating || _pin != null || pi < 0 || pi >= _pins.length) return;
    final info = _pins[pi].info;
    HapticFeedback.selectionClick();
    _beginMove(
      // yaw = -longitude and pitch = latitude put that point right at the center.
      yaw: -info.lon * math.pi / 180,
      pitch: info.lat * math.pi / 180,
      zoom: info.zoom,
      cy: _stageCenterFrac,
    );
    setState(() {
      _pin = pi;
      _returning = false;
      _hintVisible = false;
    });
    _panel.forward(from: 0);
  }

  void _back() {
    if (_pin == null || _returning || _cam.isAnimating) return;
    HapticFeedback.selectionClick();
    _returning = true;
    _beginMove(yaw: _yaw, pitch: _overviewPitch, zoom: 1.0, cy: _overviewCy);
    _panel.reverse();
    setState(() {});
  }

  void _onTap(Offset p) {
    if (!_canInteract) return;
    _sync();
    final hit = _renderer.hitTest(p, _size);
    if (hit != null) _openPin(hit);
  }

  Future<void> _openDest(OrbitDestination dest) async {
    if (_opening) return;
    _opening = true; // prevents a double tap from pushing the screen twice
    try {
      await Navigator.of(context).push(MaterialPageRoute<void>(builder: dest.builder));
    } finally {
      _opening = false;
    }
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(activeGamesProvider).value ?? const <Game>[];
    _sections = buildOrbitSections(games);
    _pins = buildEarthPins(_sections);
    if (_pin != null && _pin! >= _pins.length) {
      _pin = null;
      _returning = false;
    }
    _sync();

    // Only intercept the system back button while the Earth tab is the visible one.
    final tabActive = TickerMode.valuesOf(context).enabled;

    return PopScope(
      canPop: !(tabActive && _pin != null),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _back();
      },
      child: Scaffold(
        backgroundColor: OrbitPalette.space,
        body: Stack(children: [
          Positioned.fill(
            child: LayoutBuilder(builder: (context, c) {
              _size = Size(c.maxWidth, c.maxHeight);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (d) => _onTap(d.localPosition),
                onPanStart: _onDragStart,
                onPanUpdate: _onDragUpdate,
                onPanEnd: _onDragEnd,
                onPanCancel: _onDragCancel,
                child: RepaintBoundary(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _EarthPainter(
                      _renderer,
                      _sync,
                      Listenable.merge([_ambient, _cam, _spinRepaint]),
                    ),
                  ),
                ),
              );
            }),
          ),
          SafeArea(
            bottom: false,
            child: Column(children: [
              _topBar(),
              _focusTitle(),
              const Spacer(),
              SizedBox(width: double.infinity, child: _bottom()),
            ]),
          ),
        ]),
      ),
    );
  }

  // ----------------------------------------------------------------- top UI

  Widget _headerButton(IconData icon, String tooltip, VoidCallback onTap) => IconButton(
        tooltip: tooltip,
        icon: Icon(icon, color: OrbitPalette.muted),
        onPressed: onTap,
      );

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Row(children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _pin == null
              ? const Padding(
                  key: ValueKey('title'),
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'SPHERA EARTH',
                    style: TextStyle(
                      color: OrbitPalette.gold,
                      fontSize: 13,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : TextButton.icon(
                  key: const ValueKey('back'),
                  onPressed: _back,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18, color: OrbitPalette.champagne),
                  label: const Text('Earth', style: TextStyle(color: OrbitPalette.champagne)),
                ),
        ),
        const Spacer(),
        _headerButton(
          Icons.notifications_none_rounded,
          'Notifications',
          () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const NotificationsScreen())),
        ),
        _headerButton(
          Icons.settings_outlined,
          'Settings',
          () => Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen())),
        ),
      ]),
    );
  }

  /// Name of the open section, floating over the continent.
  Widget _focusTitle() {
    return AnimatedBuilder(
      animation: _panel,
      builder: (context, _) {
        final pi = _pin;
        if (pi == null || pi >= _pins.length) return const SizedBox(height: 0);
        final pin = _pins[pi];
        final sec = _sections[pin.sectionIndex];
        final o = const Interval(0.35, 0.8).transform(_panel.value);
        return Opacity(
          opacity: o,
          child: IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
              child: Row(children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pin.info.color.withValues(alpha: 0.18),
                    border: Border.all(color: pin.info.color.withValues(alpha: 0.8)),
                  ),
                  child: Icon(sec.icon, color: pin.info.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      sec.label.toUpperCase(),
                      style: const TextStyle(
                        color: OrbitPalette.text,
                        fontSize: 16,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${pin.info.name} · ${sec.tagline}',
                      style: const TextStyle(color: OrbitPalette.muted, fontSize: 12),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------- bottom UI

  Widget _bottom() {
    return AnimatedBuilder(
      animation: _panel,
      builder: (context, _) {
        final pv = _panel.value;
        final pi = _pin;
        final overview = 1 - const Interval(0.0, 0.3).transform(pv);
        return Stack(alignment: Alignment.bottomCenter, children: [
          if (overview > 0.01)
            IgnorePointer(
              ignoring: pi != null,
              child: Opacity(opacity: overview, child: _overviewControls()),
            ),
          if (pi != null && pi < _pins.length) _contentPanel(pi, pv),
        ]);
      },
    );
  }

  /// Whole-Earth view: a hint and one shortcut chip per section. The chips are
  /// the easy way on a phone to reach a continent that is on the far side.
  Widget _overviewControls() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      AnimatedOpacity(
        opacity: _hintVisible ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        child: const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Drag to rotate · Tap a continent',
            style: TextStyle(color: OrbitPalette.muted, fontSize: 12, letterSpacing: 1.2),
          ),
        ),
      ),
      SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _pins.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, i) => _chip(i),
        ),
      ),
      const SizedBox(height: 12),
    ]);
  }

  Widget _chip(int i) {
    final pin = _pins[i];
    final color = pin.info.color;
    return Align(
      child: Semantics(
        button: true,
        label: 'Open ${pin.label}',
        child: ExcludeSemantics(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Material(
              color: Colors.black.withValues(alpha: 0.6),
              shape: StadiumBorder(side: BorderSide(color: color.withValues(alpha: 0.65))),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: () => _openPin(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(pin.icon, size: 18, color: color),
                    const SizedBox(width: 8),
                    Text(
                      pin.label,
                      style: const TextStyle(
                        color: OrbitPalette.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Everything inside the open continent, one tile per screen of that section.
  Widget _contentPanel(int pi, double pv) {
    final pin = _pins[pi];
    final sec = _sections[pin.sectionIndex];
    final color = pin.info.color;
    final h = _panelHeight;
    final slide = Curves.easeOutCubic.transform(const Interval(0.30, 0.85).transform(pv));

    return Transform.translate(
      offset: Offset(0, (1 - slide) * h),
      child: Container(
        height: h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xEE0B0B0B), Color(0xFA030303)],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          // Uniform on purpose: Flutter does not allow a borderRadius together
          // with a border that only has one side.
          border: Border.all(color: color.withValues(alpha: 0.55), width: 1.2),
        ),
        child: Column(children: [
          const SizedBox(height: 10),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: OrbitPalette.muted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
            child: Row(children: [
              const Expanded(
                child: Text(
                  'INSIDE',
                  style: TextStyle(
                    color: OrbitPalette.muted,
                    fontSize: 11,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color.withValues(alpha: 0.16),
                ),
                child: Text(
                  '${sec.destinations.length} ${sec.destinations.length == 1 ? 'screen' : 'screens'}',
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              itemCount: sec.destinations.length,
              itemBuilder: (context, i) {
                // Tiles come in one after the other.
                final a = (0.40 + 0.04 * i).clamp(0.0, 0.62).toDouble();
                final t = Curves.easeOutCubic.transform(Interval(a, math.min(1.0, a + 0.38)).transform(pv));
                return _tile(sec.destinations[i], color, t);
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _tile(OrbitDestination d, Color color, double t) {
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, 18 * (1 - t)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Semantics(
            button: true,
            label: '${d.title}. ${d.description}',
            child: ExcludeSemantics(
              child: Material(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openDest(d),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
                    child: Row(children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.16),
                          border: Border.all(color: color.withValues(alpha: 0.5)),
                        ),
                        child: Icon(d.icon, color: color, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            d.title,
                            style: const TextStyle(
                              color: OrbitPalette.text,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            d.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: OrbitPalette.muted, fontSize: 12),
                          ),
                        ]),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: OrbitPalette.muted),
                    ]),
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

class _EarthPainter extends CustomPainter {
  _EarthPainter(this.renderer, this.sync, Listenable repaint) : super(repaint: repaint);

  final EarthRenderer renderer;
  final VoidCallback sync;

  @override
  void paint(Canvas canvas, Size size) {
    sync();
    renderer.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant _EarthPainter old) => true;
}
