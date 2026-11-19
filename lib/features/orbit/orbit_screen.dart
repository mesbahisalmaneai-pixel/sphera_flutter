import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../core/l10n.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart' show Game;
import '../../data/providers.dart';
import '../settings/settings_screen.dart';
import 'models/orbit_destination.dart';
import 'orbit_insights.dart';
import 'orbit_sections.dart';
import 'widgets/globe_scene.dart';
import 'widgets/orbit_glass.dart';
import 'widgets/orbit_sheets.dart';
import 'widgets/planet_painters.dart' show OrbitPalette;

/// Where the user is: the whole Earth, one continent selected (info card +
/// Explore), or one continent open (camera dived in, bottom sheet up).
enum _Phase { overview, selected, open }

/// The Orbit tab: a glowing gold Earth. Every section of the app lives on a
/// continent. Tap a node -> info card with live stats -> Explore -> the
/// screens of that section.
class OrbitScreen extends ConsumerStatefulWidget {
  const OrbitScreen({super.key});

  @override
  ConsumerState<OrbitScreen> createState() => _OrbitScreenState();
}

class _OrbitScreenState extends ConsumerState<OrbitScreen> with TickerProviderStateMixin {
  // Camera presets.
  static const double _overviewPitch = 0.32;
  static const double _overviewCy = 0.40;
  static const double _selectedZoom = 1.5;
  static const double _autoSpin = 2 * math.pi / 90; // one turn in 90 s
  static const double _cardH = 226;

  late final AnimationController _ambient =
      AnimationController(vsync: this, duration: const Duration(seconds: 120));
  late final AnimationController _cam =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  late final AnimationController _card = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 220));
  late final AnimationController _panel = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      reverseDuration: const Duration(milliseconds: 320));
  late final Ticker _spin = createTicker(_onSpinTick);
  final ValueNotifier<int> _spinTick = ValueNotifier<int>(0);
  final ScrollController _cards = ScrollController();
  final GlobeRenderer _renderer = GlobeRenderer();

  // Data for the current build.
  List<OrbitSection> _sections = const [];
  List<GlobeHub> _hubs = const [];

  // Live camera.
  double _yaw = -0.35, _pitch = _overviewPitch, _zoom = 1.0, _cx = 0.5, _cy = _overviewCy, _roll = 0.0;
  double _fYaw = 0, _fPitch = 0, _fZoom = 1, _fCx = 0.5, _fCy = 0.4;
  double _tYaw = 0, _tPitch = 0, _tZoom = 1, _tCx = 0.5, _tCy = 0.4;
  double _rollAmp = 0;

  // UI state.
  _Phase _phase = _Phase.overview;
  int? _hub; // index in _hubs
  int? _node; // highlighted screen node of the open hub
  int _tab = 0; // 0 = screens, 1 = stats
  bool _expanded = false;
  bool _returning = false;
  bool _dragging = false;
  bool _reduce = false;
  bool _started = false;
  double _spinVel = _autoSpin;
  Duration _lastTick = Duration.zero;
  Size _size = const Size(390, 700);
  double _safeTop = 0;

  @override
  void initState() {
    super.initState();
    _cam.addListener(_onCam);
    _cam.addStatusListener((status) {
      if (status == AnimationStatus.completed && _returning && mounted) {
        _spinVel = _autoSpin;
        setState(() {
          _hub = null;
          _node = null;
          _returning = false;
          _expanded = false;
          _tab = 0;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (!_started || reduce != _reduce) {
      _started = true;
      _reduce = reduce;
      if (reduce) {
        _ambient.stop();
        if (_spin.isActive) _spin.stop();
      } else {
        if (!_ambient.isAnimating) _ambient.repeat();
        if (!_spin.isActive) _spin.start();
      }
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    _ambient.dispose();
    _cam.dispose();
    _card.dispose();
    _panel.dispose();
    _spinTick.dispose();
    _cards.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------ spin

  void _onSpinTick(Duration elapsed) {
    final dt = ((elapsed - _lastTick).inMicroseconds / 1e6).clamp(0.0, 0.05).toDouble();
    _lastTick = elapsed;
    if (_reduce || _phase != _Phase.overview || _hub != null || _dragging || _cam.isAnimating) return;
    _yaw += _spinVel * dt;
    _spinVel += (_autoSpin - _spinVel) * math.min(1.0, dt * 1.5);
    _spinTick.value++;
  }

  // ---------------------------------------------------------------- camera

  double _angDelta(double from, double to) {
    var d = (to - from) % (2 * math.pi);
    if (d > math.pi) d -= 2 * math.pi;
    return d;
  }

  void _beginMove({double? yaw, required double pitch, required double zoom, required double cx, required double cy}) {
    _fYaw = _yaw;
    _fPitch = _pitch;
    _fZoom = _zoom;
    _fCx = _cx;
    _fCy = _cy;
    _tYaw = yaw == null ? _yaw : _yaw + _angDelta(_yaw, yaw);
    _tPitch = pitch;
    _tZoom = zoom;
    _tCx = cx;
    _tCy = cy;
    _rollAmp = _reduce ? 0 : 0.05 * (_tYaw >= _fYaw ? 1 : -1);
    _cam.duration = Duration(milliseconds: _reduce ? 1 : 1200);
    _cam.forward(from: 0);
  }

  void _onCam() {
    final t = Curves.easeInOutCubic.transform(_cam.value);
    double lerp(double a, double b) => a + (b - a) * t;
    _yaw = lerp(_fYaw, _tYaw);
    _pitch = lerp(_fPitch, _tPitch);
    _zoom = lerp(_fZoom, _tZoom);
    _cx = lerp(_fCx, _tCx);
    _cy = lerp(_fCy, _tCy);
    _roll = _rollAmp * math.sin(math.pi * t);
  }

  /// Copies the live state into the renderer. Called right before each paint.
  void _sync(Size size) {
    _size = size;
    final live = _hub != null && _hub! < _hubs.length;
    final node = _node;
    String? nodeLabel;
    if (live && node != null && _phase == _Phase.open) {
      final sec = _sections[_hubs[_hub!].sectionIndex];
      if (node < sec.destinations.length) nodeLabel = sec.destinations[node].title;
    }
    _renderer
      ..hubs = _hubs
      ..yaw = _yaw
      ..pitch = _pitch
      ..zoom = _zoom
      ..cxFrac = _cx
      ..cyFrac = _cy
      ..roll = _roll
      ..focus = (_zoom - 1.0).clamp(0.0, 1.0).toDouble()
      ..openHub = live ? _hub : null
      ..selectedNode = _phase == _Phase.open ? node : null
      ..selectedNodeLabel = nodeLabel
      ..nodesAlpha = ((_zoom - 1.6) / 0.45).clamp(0.0, 1.0).toDouble()
      ..hubHitEnabled = _phase != _Phase.open
      ..beamFrom = (live && _card.value > 0.001) ? _cardRect() : null
      ..beamAlpha = _card.value
      ..u = _reduce ? 0.083 : _ambient.value;
  }

  // ---------------------------------------------------------------- layout

  double get _cardW => (_size.width * 0.43).clamp(150.0, 190.0).toDouble();

  Rect _cardRect() => Rect.fromLTWH(16, _safeTop + 68, _cardW, _cardH);

  /// Horizontal center of the Earth while a hub is selected: puts the hub
  /// between the card and the right edge, like the reference.
  double get _selectedCx {
    final right = 16 + _cardW;
    return ((right + (_size.width - right) * 0.42) / _size.width).clamp(0.5, 0.85).toDouble();
  }

  double get _selectedCy => (_cardRect().center.dy / _size.height).clamp(0.25, 0.46).toDouble();

  double get _sheetH => (_size.height * 0.52).clamp(350.0, 430.0).toDouble();
  double get _sheetHExpanded => math.max(_sheetH, _size.height - _safeTop - 76);

  /// Vertical center of the visible stage above the compact sheet.
  double get _stageCy =>
      (((_safeTop + 60) + (_size.height - _sheetH)) / 2 / _size.height).clamp(0.2, 0.5).toDouble();

  double get _cardWidthInSheet => math.min(_size.width * 0.86, 330.0);

  // ---------------------------------------------------------- phase changes

  void _select(int hi) {
    if (hi < 0 || hi >= _hubs.length) return;
    HapticFeedback.selectionClick();
    final info = _hubs[hi].info;
    if (_phase == _Phase.open) _panel.reverse();
    _returning = false;
    _beginMove(
      yaw: -info.lon * math.pi / 180,
      pitch: info.lat * math.pi / 180,
      zoom: _selectedZoom,
      cx: _selectedCx,
      cy: _selectedCy,
    );
    setState(() {
      _hub = hi;
      _node = null;
      _phase = _Phase.selected;
      _expanded = false;
      _tab = 0;
    });
    _card.forward(from: 0);
  }

  void _explore() {
    final hi = _hub;
    if (hi == null || _phase != _Phase.selected) return;
    HapticFeedback.mediumImpact();
    final info = _hubs[hi].info;
    _beginMove(
      yaw: -info.lon * math.pi / 180,
      pitch: info.lat * math.pi / 180,
      zoom: info.zoom,
      cx: 0.5,
      cy: _stageCy,
    );
    setState(() => _phase = _Phase.open);
    _card.reverse();
    _panel.forward(from: 0);
  }

  /// Back to the whole Earth (from the card or from the open sheet).
  void _close() {
    if (_phase == _Phase.overview) return;
    HapticFeedback.selectionClick();
    _returning = true;
    _beginMove(pitch: _overviewPitch, zoom: 1.0, cx: 0.5, cy: _overviewCy);
    setState(() => _phase = _Phase.overview);
    _card.reverse();
    _panel.reverse();
  }

  // ---------------------------------------------------------------- gestures

  bool get _canDrag => _phase == _Phase.overview && _hub == null && !_cam.isAnimating;

  void _onTap(Offset p) {
    _sync(_size);
    if (_cam.isAnimating && _phase != _Phase.open) return;
    switch (_phase) {
      case _Phase.overview:
        final h = _renderer.hitHub(p, _size);
        if (h != null) _select(h);
      case _Phase.selected:
        final h = _renderer.hitHub(p, _size);
        if (h == null) return;
        if (h == _hub) {
          _explore();
        } else {
          _select(h);
        }
      case _Phase.open:
        final n = _renderer.hitNode(p, _size);
        if (n != null) _onNodeTap(n);
    }
  }

  void _onNodeTap(int i) {
    final hi = _hub;
    if (hi == null) return;
    final sec = _sections[_hubs[hi].sectionIndex];
    if (i >= sec.destinations.length) return;
    if (_node == i) {
      _openDest(sec.destinations[i]);
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _node = i;
      _tab = 0;
    });
    if (_cards.hasClients && !_expanded) {
      _cards.animateTo(
        (i * (_cardWidthInSheet + 10)).clamp(0.0, _cards.position.maxScrollExtent).toDouble(),
        duration: Duration(milliseconds: _reduce ? 1 : 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onPanStart(DragStartDetails d) {
    if (!_canDrag) return;
    _dragging = true;
    _spinVel = 0;
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (!_dragging) return;
    final r = _renderer.radius(_size);
    _yaw += d.delta.dx / r;
    _pitch = (_pitch + d.delta.dy / r).clamp(-0.9, 0.9).toDouble();
    _spinVel = d.delta.dx / r * 40;
    _spinTick.value++;
  }

  void _onPanEnd(DragEndDetails d) {
    _dragging = false;
    final r = _renderer.radius(_size);
    _spinVel = (d.velocity.pixelsPerSecond.dx / r).clamp(-4.0, 4.0).toDouble();
  }

  // -------------------------------------------------------------- navigation

  void _openDest(OrbitDestination d) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(MaterialPageRoute<void>(builder: d.builder));
  }

  void _openDestId(String id) {
    final d = findDestination(_sections, id);
    if (d != null) _openDest(d);
  }

  Future<void> _openSearch() async {
    final d = await showOrbitSearch(context, _sections);
    if (d != null && mounted) _openDest(d);
  }

  Future<void> _openMenu() async {
    final si = await showOrbitMenu(context, sections: _sections, hubs: _hubs);
    if (si == null || !mounted) return;
    final hi = _hubs.indexWhere((h) => h.sectionIndex == si);
    if (hi >= 0) _select(hi);
  }

  Future<void> _openInsights(OrbitData data) async {
    final id = await showOrbitInsights(context, data.insights);
    if (id != null && mounted) _openDestId(id);
  }

  void _openSettings() => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));

  void _openNotifications() => _openDestId('notifications');

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(activeGamesProvider).value ?? const <Game>[];
    final data = ref.watch(orbitDataProvider);
    _sections = buildOrbitSections(games);
    _hubs = buildGlobeHubs(_sections);
    if (_hub != null && _hub! >= _hubs.length) _hub = null;
    _safeTop = MediaQuery.paddingOf(context).top;

    final tabActive = TickerMode.valuesOf(context).enabled;
    final mq = MediaQuery.of(context);

    return MediaQuery(
      data: mq.copyWith(textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2)),
      child: PopScope(
        canPop: !(tabActive && _phase != _Phase.overview),
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _close();
        },
        child: Scaffold(
          backgroundColor: OrbitPalette.space,
          body: LayoutBuilder(
            builder: (context, box) {
              _size = Size(box.maxWidth, box.maxHeight);
              // All the glass panels over the globe share one backdrop read
              // (OrbitGlass uses BackdropFilter.grouped): far cheaper than one
              // full-screen read per panel on every frame of the spinning globe.
              return BackdropGroup(
                child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: Semantics(
                      label: context.l10n.globeSemantics,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapUp: (d) => _onTap(d.localPosition),
                        onPanStart: _onPanStart,
                        onPanUpdate: _onPanUpdate,
                        onPanEnd: _onPanEnd,
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: _GlobePainter(
                              renderer: _renderer,
                              before: _sync,
                              repaint: Listenable.merge([_ambient, _cam, _card, _panel, _spinTick]),
                            ),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(top: _safeTop + 6, left: 0, right: 0, child: _topBar()),
                  _infoCard(data),
                  Positioned(left: 0, right: 0, bottom: 0, child: _bottom(data)),
                ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- top bar

  Widget _topBar() {
    final inSection = _phase != _Phase.overview;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GlassIconButton(
            icon: inSection ? Icons.arrow_back_rounded : Icons.menu_rounded,
            tooltip: inSection ? context.l10n.backToGlobe : context.l10n.allSections,
            onTap: inSection ? _close : _openMenu,
          ),
          const SizedBox(width: 52), // balances the two buttons on the right
          Expanded(
            child: Center(
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) => const LinearGradient(
                  colors: [OrbitPalette.champagne, OrbitPalette.gold, OrbitPalette.champagne],
                ).createShader(rect),
                child: Text(
                  'SPHERA',
                  style: OrbitText.value(size: 20, color: Colors.white).copyWith(letterSpacing: 7),
                ),
              ),
            ),
          ),
          GlassIconButton(icon: Icons.settings_outlined, tooltip: context.l10n.settings, onTap: _openSettings),
          const SizedBox(width: 8),
          GlassIconButton(icon: Icons.notifications_none_rounded, tooltip: context.l10n.notifications, onTap: _openNotifications),
        ],
      ),
    );
  }

  // -------------------------------------------------------------- info card

  Widget _infoCard(OrbitData data) {
    return AnimatedBuilder(
      animation: _card,
      builder: (context, _) {
        final hi = _hub;
        final v = _card.value;
        if (hi == null || hi >= _hubs.length || v < 0.01) return const SizedBox.shrink();
        final hub = _hubs[hi];
        final sec = _sections[hub.sectionIndex];
        final info = data.infoFor(sec);
        final rect = _cardRect();
        final a = Curves.easeOut.transform(v);
        return Positioned(
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height,
          child: IgnorePointer(
            ignoring: _phase != _Phase.selected,
            child: Opacity(
              opacity: a,
              child: Transform.translate(
                offset: Offset(-14 * (1 - a), 0),
                child: OrbitGlass(
                  radius: 22,
                  blur: 18,
                  padding: const EdgeInsets.fromLTRB(14, 10, 10, 12),
                  fill: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0x47FFF1BD), Color(0x1AFFFFFF)],
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(hub.info.localName,
                                  maxLines: 1, overflow: TextOverflow.ellipsis, style: OrbitText.label(size: 11)),
                            ),
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                tooltip: context.l10n.close,
                                onPressed: _close,
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0x26FFFFFF),
                                  minimumSize: const Size(32, 32),
                                ),
                                icon: const Icon(Icons.close_rounded, size: 18, color: OrbitPalette.text),
                              ),
                            ),
                          ],
                        ),
                        Text(sec.label, style: OrbitText.value(size: 21)),
                        const SizedBox(height: 10),
                        for (var i = 0; i < info.cells.length; i += 2)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(child: _cell(info.cells[i])),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: i + 1 < info.cells.length ? _cell(info.cells[i + 1]) : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(context.l10n.purpose, style: OrbitText.label(size: 10)),
                        const SizedBox(height: 1),
                        Text(sec.tagline,
                            maxLines: 2, overflow: TextOverflow.ellipsis, style: OrbitText.value(size: 12.5, weight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cell(OrbitMetric m) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(m.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: OrbitText.label(size: 10)),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(m.value, style: OrbitText.value(size: 15)),
        ),
      ],
    );
  }

  // ----------------------------------------------------------------- bottom

  Widget _bottom(OrbitData data) {
    return AnimatedBuilder(
      animation: _panel,
      builder: (context, _) {
        final pv = _panel.value;
        final overview = 1 - const Interval(0.0, 0.3).transform(pv);
        final hi = _hub;
        final showSheet = hi != null && hi < _hubs.length && (_phase == _Phase.open || pv > 0.001);
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (overview > 0.01)
              IgnorePointer(
                ignoring: _phase == _Phase.open,
                child: Opacity(opacity: overview, child: _overviewBottom(data)),
              ),
            if (showSheet) _sheet(pv, data, hi),
          ],
        );
      },
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OrbitSearchBar(
        hint: context.l10n.tellWhereToGo,
        onTap: _openSearch,
        onHelp: () => showOrbitHelp(context),
        onMenu: _openMenu,
      ),
    );
  }

  Widget _overviewBottom(OrbitData data) {
    final showInsights = _size.height >= (_phase == _Phase.selected ? 720 : 660);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_phase == _Phase.selected)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: GlowButton(label: context.l10n.explore, onTap: _explore),
          ),
        _searchBar(),
        if (showInsights) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, size: 17, color: OrbitPalette.champagne),
                const SizedBox(width: 8),
                Text(context.l10n.insights, style: OrbitText.value(size: 14)),
                const Spacer(),
                TextButton(
                  onPressed: () => _openInsights(data),
                  style: TextButton.styleFrom(
                    foregroundColor: OrbitPalette.gold,
                    minimumSize: const Size(56, 40),
                  ),
                  child: Text(context.l10n.seeAll, style: OrbitText.label(size: 12, color: OrbitPalette.gold)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: data.insights.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) => InsightCard(
                insight: data.insights[i],
                onTap: () => _openDestId(data.insights[i].destId),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  // ------------------------------------------------------------------ sheet

  Widget _sheet(double pv, OrbitData data, int hi) {
    final hub = _hubs[hi];
    final sec = _sections[hub.sectionIndex];
    final info = data.infoFor(sec);
    final h = _expanded ? _sheetHExpanded : _sheetH;
    final slide = Curves.easeOutCubic.transform(const Interval(0.30, 0.85).transform(pv));
    final first = sec.destinations.isEmpty ? null : sec.destinations.first;

    return Transform.translate(
      offset: Offset(0, (1 - slide) * h),
      child: AnimatedContainer(
        duration: Duration(milliseconds: _reduce ? 1 : 280),
        curve: Curves.easeOutCubic,
        height: h,
        width: double.infinity,
        child: OrbitGlass(
          topOnly: true,
          radius: 28,
          blur: 18,
          fill: kOrbitSheetFill,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(color: const Color(0x44FFFFFF), borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: _searchBar(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OrbitDial(
                      icon: sec.icon,
                      tooltip: first == null ? sec.label : context.l10n.openScreen(first.title),
                      onTap: first == null ? () {} : () => _openDest(first),
                    ),
                    const SizedBox(width: 6),
                    RingGauge(fraction: info.gaugeA, label: info.gaugeALabel),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(info.bigLabel,
                                maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: OrbitText.label(size: 11)),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(info.bigValue, style: OrbitText.value(size: 22)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RingGauge(fraction: info.gaugeB, label: info.gaugeBLabel),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [
                    GlassChip(label: context.l10n.screens, selected: _tab == 0, onTap: () => setState(() => _tab = 0)),
                    const SizedBox(width: 8),
                    GlassChip(label: context.l10n.navStats, selected: _tab == 1, onTap: () => setState(() => _tab = 1)),
                    const Spacer(),
                    GlassIconButton(
                      icon: _expanded ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                      tooltip: _expanded ? context.l10n.smallerPanel : context.l10n.biggerPanel,
                      size: 40,
                      onTap: () => setState(() => _expanded = !_expanded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _tab == 0 ? _screensList(sec) : _statsList(info)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _screensList(OrbitSection sec) {
    final dests = sec.destinations;
    if (dests.isEmpty) {
      return Center(child: Text(context.l10n.nothingHereYetDot, style: OrbitText.label(size: 13)));
    }
    if (_expanded) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: dests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) =>
            DestinationCard(dest: dests[i], selected: _node == i, onTap: () => _openDest(dests[i])),
      );
    }
    final w = _cardWidthInSheet;
    return ListView.builder(
      controller: _cards,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 6, 16),
      itemExtent: w + 10,
      itemCount: dests.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(right: 10),
        child: DestinationCard(dest: dests[i], selected: _node == i, onTap: () => _openDest(dests[i])),
      ),
    );
  }

  Widget _statsList(OrbitSectionInfo info) {
    if (info.bars.isEmpty) {
      return Center(child: Text(context.l10n.noStatsForSection, style: OrbitText.label(size: 13)));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      children: [for (final b in info.bars) MetricBar(bar: b)],
    );
  }
}

/// Paints the globe. [before] copies the screen's live state into the renderer
/// on every frame, so the renderer never shows stale data.
class _GlobePainter extends CustomPainter {
  _GlobePainter({required this.renderer, required this.before, required Listenable repaint})
      : super(repaint: repaint);

  final GlobeRenderer renderer;
  final void Function(Size) before;

  @override
  void paint(Canvas canvas, Size size) {
    before(size);
    renderer.paint(canvas, size);
  }

  @override
  bool shouldRepaint(_GlobePainter old) => true;
}
