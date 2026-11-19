import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/features/earth/earth_continents.dart';
import 'package:sphera_flutter/features/orbit/models/orbit_destination.dart';
import 'package:sphera_flutter/features/orbit/widgets/globe_scene.dart';

OrbitSection _section(String id, {int screens = 0}) => OrbitSection(
      id: id,
      label: id,
      tagline: '',
      icon: Icons.circle,
      destinations: [
        for (var i = 0; i < screens; i++)
          OrbitDestination(
            id: '$id-$i',
            title: '$id $i',
            description: '',
            icon: Icons.circle,
            pattern: 0,
            builder: (_) => const SizedBox(),
          ),
      ],
    );

const _ids = ['stats', 'cards', 'games', 'google', 'profile', 'settings'];

void main() {
  group('screen nodes', () {
    test('every node sits on land of its own continent, for 1 to 7 screens', () {
      for (final c in Continent.values) {
        for (var n = 1; n <= 7; n++) {
          final pts = placeNodes(c, n);
          expect(pts.length, n, reason: '${c.name} x$n');
          for (final p in pts) {
            expect(earthIsLand(p.lat, p.lon), isTrue, reason: '${c.name} x$n at ${p.lat},${p.lon}');
            expect(continentAt(p.lat, p.lon), c, reason: '${c.name} x$n at ${p.lat},${p.lon}');
          }
        }
      }
    });

    test('nodes are spread out: no two within 2 degrees of each other', () {
      for (final c in Continent.values) {
        final pts = placeNodes(c, 7);
        for (var i = 0; i < pts.length; i++) {
          for (var j = i + 1; j < pts.length; j++) {
            final dLat = pts[i].lat - pts[j].lat;
            final dLon = (pts[i].lon - pts[j].lon) * math.cos(pts[i].lat * math.pi / 180);
            expect(math.sqrt(dLat * dLat + dLon * dLon), greaterThan(2.0), reason: '${c.name} $i/$j');
          }
        }
      }
    });

    test('placement is stable between calls', () {
      final a = placeNodes(Continent.africa, 5);
      final b = placeNodes(Continent.africa, 5);
      expect(identical(a, b), isTrue);
    });

    test('zero screens gives no nodes', () {
      expect(placeNodes(Continent.asia, 0), isEmpty);
    });
  });

  group('hubs', () {
    test('every section gets its own continent, from the mapping', () {
      final hubs = buildGlobeHubs([for (final id in _ids) _section(id)]);
      expect(hubs.length, _ids.length);
      expect(hubs.map((h) => h.continent).toSet().length, _ids.length);
      for (final h in hubs) {
        expect(h.continent, kOrbitContinent[_ids[h.sectionIndex]]);
      }
    });

    test('Stats and Settings are on continents that face the camera at start', () {
      // The Earth opens centered on longitude +20 degrees.
      expect(kContinentInfo[kOrbitContinent['stats']!.index].lon, inInclusiveRange(-70, 110));
      expect(kContinentInfo[kOrbitContinent['settings']!.index].lon, inInclusiveRange(-70, 110));
    });

    test('a section with no mapping takes a free continent', () {
      final hubs = buildGlobeHubs([_section('stats'), _section('brand-new')]);
      expect(hubs.length, 2);
      expect(hubs[0].continent != hubs[1].continent, isTrue);
    });

    test('a hub has one node per screen of its section', () {
      final hubs = buildGlobeHubs([_section('stats', screens: 5), _section('settings', screens: 4)]);
      expect(hubs[0].nodes.length, 5);
      expect(hubs[1].nodes.length, 4);
    });
  });
}
