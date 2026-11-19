import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/features/earth/earth_continents.dart';
import 'package:sphera_flutter/features/earth/earth_scene.dart';
import 'package:sphera_flutter/features/earth/earth_sections.dart';
import 'package:sphera_flutter/features/orbit/models/orbit_destination.dart';

OrbitSection _section(String id) => OrbitSection(
      id: id,
      label: id,
      tagline: '',
      icon: Icons.circle,
      destinations: const [],
    );

const _defaultIds = ['stats', 'cards', 'profile', 'games', 'google', 'settings'];

void main() {
  group('continents', () {
    test('every anchor is on land and belongs to its own continent', () {
      for (final c in Continent.values) {
        final i = kContinentInfo[c.index];
        expect(earthIsLand(i.lat, i.lon), isTrue, reason: i.name);
        expect(continentAt(i.lat, i.lon), c, reason: i.name);
      }
    });

    test('well-known places land on the right continent', () {
      final cases = <List<Object>>[
        ['Kenitra', 34.26, -6.58, Continent.africa],
        ['Casablanca', 33.57, -7.59, Continent.africa],
        ['Cairo', 30.04, 31.24, Continent.africa],
        ['Nairobi', -1.3, 36.8, Continent.africa],
        ['Cape Town', -33.9, 18.4, Continent.africa],
        ['Madrid', 40.4, -3.7, Continent.europe],
        ['London', 51.5, -0.1, Continent.europe],
        ['Moscow', 55.75, 37.6, Continent.europe],
        ['Reykjavik', 64.1, -21.9, Continent.europe],
        ['Riyadh', 24.7, 46.7, Continent.asia],
        ['Delhi', 28.6, 77.2, Continent.asia],
        ['Tokyo', 35.7, 139.7, Continent.asia],
        ['Sydney', -33.9, 151.2, Continent.oceania],
        ['New York', 40.7, -74.0, Continent.northAmerica],
        ['Mexico City', 19.4, -99.1, Continent.northAmerica],
        ['Sao Paulo', -23.5, -46.6, Continent.southAmerica],
      ];
      for (final c in cases) {
        expect(continentAt(c[1] as double, c[2] as double), c[3], reason: c[0] as String);
      }
    });

    test('Antarctica belongs to no continent', () {
      expect(continentAt(-80, 0), isNull);
    });

    test('the dotted Earth has dots on every continent', () {
      final m = EarthModel.instance;
      expect(m.landCount, inInclusiveRange(6000, 12000));
      for (final c in Continent.values) {
        expect(m.continentCounts[c.index], greaterThan(100), reason: c.name);
      }
    });
  });

  group('projection', () {
    test('yaw = -lon and pitch = lat put a point exactly at the center', () {
      const center = Offset(200, 300);
      for (final c in Continent.values) {
        final i = kContinentInfo[c.index];
        final p = EarthProjection(
          yaw: -i.lon * math.pi / 180,
          pitch: i.lat * math.pi / 180,
          center: center,
          radius: 150,
        );
        final pt = p.project(i.lat, i.lon);
        expect((pt.offset - center).distance, lessThan(1e-6), reason: i.name);
        expect(pt.z, closeTo(1, 1e-9), reason: i.name);
      }
    });

    test('unproject undoes project', () {
      final p = EarthProjection(yaw: 0.7, pitch: -0.4, center: const Offset(200, 300), radius: 180);
      var checked = 0;
      for (final ll in const [LatLon(10, -30), LatLon(-35, -60), LatLon(55, -45), LatLon(0, -40)]) {
        final pt = p.project(ll.lat, ll.lon);
        if (pt.z <= 0.05) continue; // behind the Earth
        final back = p.unproject(pt.offset)!;
        expect(back.lat, closeTo(ll.lat, 1e-6));
        expect(back.lon, closeTo(ll.lon, 1e-6));
        checked++;
      }
      expect(checked, greaterThan(0));
    });

    test('a position well outside the disc has no point', () {
      final p = EarthProjection(yaw: 0, pitch: 0, center: const Offset(200, 300), radius: 100);
      expect(p.unproject(const Offset(0, 0)), isNull);
    });
  });

  group('sections on the Earth', () {
    test('the default sections get six different continents', () {
      final pins = buildEarthPins([for (final id in _defaultIds) _section(id)]);
      expect(pins.length, 6);
      expect(pins.map((p) => p.continent).toSet().length, 6);
      expect(pins.firstWhere((p) => p.label == 'stats').continent, Continent.africa);
      expect(pins.firstWhere((p) => p.label == 'profile').continent, Continent.europe);
    });

    test('a new section takes a free continent instead of disappearing', () {
      final pins = buildEarthPins([_section('stats'), _section('something-new')]);
      expect(pins.length, 2);
      expect(pins[0].continent, Continent.africa);
      expect(pins[1].continent, isNot(Continent.africa));
    });

    test('tapping a continent (or just beside its coast) finds its section', () {
      final pins = buildEarthPins([for (final id in _defaultIds) _section(id)]);
      final r = EarthRenderer()..pins = pins;
      const size = Size(390, 700);

      // Face Africa.
      final af = kContinentInfo[Continent.africa.index];
      r
        ..yaw = -af.lon * math.pi / 180
        ..pitch = af.lat * math.pi / 180;
      final proj = r.projection(size);
      final africa = pins.indexWhere((p) => p.continent == Continent.africa);

      expect(r.hitTest(proj.center, size), africa); // on the pin
      expect(r.hitTest(proj.project(22, 10).offset, size), africa); // Sahara, far from the pin
      expect(r.hitTest(proj.project(-20, 24).offset, size), africa); // Southern Africa
      expect(r.hitTest(const Offset(2, 2), size), isNull); // empty space

      // Once the camera has dived in, taps on the Earth do nothing.
      r.focus = 1;
      expect(r.hitTest(proj.center, size), isNull);
    });
  });
}
