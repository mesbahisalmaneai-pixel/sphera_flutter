import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/features/earth/earth_continents.dart';

void main() {
  group('land mask', () {
    test('big land areas are land', () {
      expect(earthIsLand(22, 10), isTrue); // Sahara
      expect(earthIsLand(-20, 24), isTrue); // Southern Africa
      expect(earthIsLand(55.75, 37.6), isTrue); // Moscow
      expect(earthIsLand(-33.9, 151.2), isTrue); // Sydney
      expect(earthIsLand(72, -40), isTrue); // Greenland
      expect(earthIsLand(-80, 0), isTrue); // Antarctica
    });

    test('oceans and inland seas are not land', () {
      expect(earthIsLand(0, -30), isFalse); // Atlantic
      expect(earthIsLand(0, -150), isFalse); // Pacific
      expect(earthIsLand(-20, 80), isFalse); // Indian Ocean
      expect(earthIsLand(35, 18), isFalse); // Mediterranean
      expect(earthIsLand(43.5, 34), isFalse); // Black Sea
      expect(earthIsLand(42, 51), isFalse); // Caspian Sea
      expect(earthIsLand(60, -85), isFalse); // Hudson Bay
    });

    test('longitudes wrap around the date line', () {
      expect(earthIsLand(66, 190), earthIsLand(66, -170));
      expect(earthIsLand(40, 90), earthIsLand(40, 450));
    });
  });
}
