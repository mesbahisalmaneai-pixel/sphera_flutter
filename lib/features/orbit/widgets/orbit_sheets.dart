import 'package:flutter/material.dart';

import '../models/orbit_destination.dart';
import '../orbit_insights.dart';
import 'globe_scene.dart';
import 'orbit_glass.dart';
import 'planet_painters.dart' show OrbitPalette;

Future<T?> _show<T>(BuildContext context, WidgetBuilder builder) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0xB3000000),
    builder: builder,
  );
}

/// Dark glass frame shared by the sheets: handle, title, scrolling content.
class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.sizeOf(context).height * 0.88;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxH),
      child: OrbitGlass(
        topOnly: true,
        radius: 28,
        blur: 18,
        fill: kOrbitSheetFill,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0x44FFFFFF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: OrbitText.value(size: 18)),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- search

/// Search over every screen of the app. Returns the chosen destination.
Future<OrbitDestination?> showOrbitSearch(BuildContext context, List<OrbitSection> sections) {
  return _show<OrbitDestination>(context, (_) => _SearchSheet(sections: sections));
}

class _SearchSheet extends StatefulWidget {
  const _SearchSheet({required this.sections});
  final List<OrbitSection> sections;

  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  String _q = '';

  List<(OrbitSection, OrbitDestination)> _results() {
    final tokens = _q.trim().toLowerCase().split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
    final out = <(OrbitSection, OrbitDestination)>[];
    for (final s in widget.sections) {
      for (final d in s.destinations) {
        final hay = '${d.title} ${d.description} ${s.label} ${s.tagline}'.toLowerCase();
        if (tokens.every((t) => hay.contains(t))) out.add((s, d));
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final results = _results();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: _SheetFrame(
        title: 'Where do you want to go?',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _q = v),
                style: OrbitText.value(size: 14, weight: FontWeight.w400),
                cursorColor: OrbitPalette.gold,
                decoration: InputDecoration(
                  hintText: 'Search a screen, like profit or vault',
                  hintStyle: OrbitText.label(size: 13),
                  prefixIcon: const Icon(Icons.search_rounded, color: OrbitPalette.champagne),
                  filled: true,
                  fillColor: const Color(0x1FFFFFFF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0x33F1DFA6)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0x33F1DFA6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: OrbitPalette.gold),
                  ),
                ),
              ),
            ),
            Flexible(
              child: results.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(28),
                      child: Text('No screen matches that.', style: OrbitText.label(size: 13)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      itemCount: results.length,
                      itemBuilder: (context, i) {
                        final (s, d) = results[i];
                        return ListTile(
                          leading: GoldTile(icon: d.icon, size: 40),
                          title: Text(d.title, style: OrbitText.value(size: 14)),
                          subtitle: Text(s.label, style: OrbitText.label(size: 11)),
                          trailing: const Icon(Icons.north_east_rounded, size: 18, color: OrbitPalette.gold),
                          onTap: () => Navigator.of(context).pop(d),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ menu

/// Every section with its continent. Returns the chosen section index.
Future<int?> showOrbitMenu(
  BuildContext context, {
  required List<OrbitSection> sections,
  required List<GlobeHub> hubs,
}) {
  return _show<int>(
    context,
    (_) => _SheetFrame(
      title: 'All sections',
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 84,
        ),
        itemCount: hubs.length,
        itemBuilder: (context, i) {
          final hub = hubs[i];
          final s = sections[hub.sectionIndex];
          final n = s.destinations.length;
          return Semantics(
            button: true,
            label: '${s.label}, ${hub.info.name}, $n screens',
            child: ExcludeSemantics(
              child: OrbitGlass(
                radius: 18,
                blur: 8,
                padding: const EdgeInsets.all(10),
                onTap: () => Navigator.of(context).pop(hub.sectionIndex),
                child: Row(
                  children: [
                    GoldTile(icon: s.icon, size: 46),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: OrbitText.value(size: 14)),
                          Text(hub.info.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: OrbitText.label(size: 11, color: OrbitPalette.gold)),
                          Text('$n ${n == 1 ? 'screen' : 'screens'}', style: OrbitText.label(size: 10.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

// -------------------------------------------------------------- insights

/// All insight cards. Returns the id of the destination to open.
Future<String?> showOrbitInsights(BuildContext context, List<OrbitInsight> insights) {
  return _show<String>(
    context,
    (_) => _SheetFrame(
      title: 'Insights',
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        itemCount: insights.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => InsightCard(
          insight: insights[i],
          width: null,
          height: 112,
          onTap: () => Navigator.of(context).pop(insights[i].destId),
        ),
      ),
    ),
  );
}

// ------------------------------------------------------------------ help

Future<void> showOrbitHelp(BuildContext context) {
  const lines = <(IconData, String)>[
    (Icons.swipe_rounded, 'Drag the globe to turn it.'),
    (Icons.touch_app_rounded, 'Tap a glowing node to see what is inside that continent.'),
    (Icons.explore_outlined, 'Press Explore to dive in, then tap a card to open the screen.'),
    (Icons.search_rounded, 'The bar at the bottom finds any screen by name.'),
  ];
  return _show<void>(
    context,
    (_) => _SheetFrame(
      title: 'How the globe works',
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          for (final (icon, text) in lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(icon, size: 22, color: OrbitPalette.gold),
                  const SizedBox(width: 14),
                  Expanded(child: Text(text, style: OrbitText.value(size: 14, weight: FontWeight.w400))),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
