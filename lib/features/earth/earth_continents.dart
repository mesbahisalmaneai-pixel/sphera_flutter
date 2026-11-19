import 'dart:ui' show Color;

// The land mask lives in its own file; it is re-exported here so everything that
// imports the continents also gets `earthIsLand`.
export 'earth_land.dart';

/// The six continents the Earth hub can use as app sections.
enum Continent { northAmerica, southAmerica, europe, africa, asia, oceania }

/// Index used for land that belongs to no section (Antarctica, remote islands).
const int kOtherLand = 6;

/// Static facts about one continent. The list [kContinentInfo] follows the
/// order of the [Continent] enum, so `kContinentInfo[c.index]` always works.
class ContinentInfo {
  const ContinentInfo({
    required this.name,
    required this.lat,
    required this.lon,
    required this.zoom,
    required this.color,
  });

  final String name;

  /// Anchor in degrees: where the pin sits and where the camera looks when the
  /// continent is opened. Always a point that is really on land.
  final double lat, lon;

  /// Camera zoom when the continent is opened (1 = whole Earth).
  /// Small continents zoom in more than huge ones.
  final double zoom;

  /// Accent of the continent (land dots, pin, glow). No green: black + gold brand.
  final Color color;
}

const List<ContinentInfo> kContinentInfo = [
  ContinentInfo(name: 'North America', lat: 40, lon: -100, zoom: 2.2, color: Color(0xFF5BC0EB)),
  ContinentInfo(name: 'South America', lat: -12, lon: -58, zoom: 2.5, color: Color(0xFFF2789F)),
  ContinentInfo(name: 'Europe', lat: 49, lon: 15, zoom: 3.2, color: Color(0xFFB388EB)),
  ContinentInfo(name: 'Africa', lat: 3, lon: 20, zoom: 2.4, color: Color(0xFFD4AF37)),
  ContinentInfo(name: 'Asia', lat: 40, lon: 90, zoom: 2.0, color: Color(0xFFE4572E)),
  ContinentInfo(name: 'Oceania', lat: -25, lon: 134, zoom: 2.8, color: Color(0xFFB8C0CC)),
];

// ---------------------------------------------------------------------------
// Classification: which continent does a (lat, lon) point belong to?
// Only meaningful for LAND points (the caller checks the land mask first).
// Borders that touch the sea are simple lines through the water; the borders
// that matter (Europe/Asia at the Urals and Caucasus, Africa/Asia at Suez and
// the Red Sea, North/South America at Panama) are polygons.
// ---------------------------------------------------------------------------

// Polygon vertices are flat lists: lon, lat, lon, lat, ...
const List<double> _europe = [
  -25.0, 62.0, -25.0, 67.5, -9.0, 67.5, -9.0, 90.0,
  69.0, 90.0, 69.0, 70.0, 66.5, 69.0, 65.5, 66.5,
  61.5, 64.0, 60.0, 60.0, 59.5, 57.0, 58.5, 54.0,
  58.5, 51.3, 56.0, 50.8, 51.4, 51.2, 51.9, 47.2,
  51.0, 46.2, 50.0, 44.5, 49.5, 41.8, 47.0, 41.8,
  44.0, 42.4, 41.5, 43.2, 40.2, 43.5, 39.0, 43.0,
  37.0, 42.0, 31.0, 42.0, 29.2, 41.3, 29.0, 41.0,
  28.5, 40.65, 27.0, 40.5, 26.1, 40.0, 26.0, 38.0,
  28.7, 36.0, 28.7, 34.5, 14.5, 34.5, 11.8, 36.0,
  10.5, 37.9, 9.0, 38.0, 3.0, 37.9, -1.0, 36.3,
  -5.5, 35.95, -10.0, 35.9,
];

const List<double> _africa = [
  -19.0, 38.0, 11.5, 38.0, 11.5, 34.0, 32.55, 34.0,
  32.55, 31.4, 32.58, 30.0, 32.9, 29.2, 33.3, 28.5,
  33.7, 27.8, 34.6, 27.2, 35.8, 24.5, 38.0, 20.5,
  40.0, 17.5, 41.9, 14.5, 43.2, 12.9, 46.0, 12.3,
  52.2, 12.3, 52.2, -3.0, 58.5, -3.0, 58.5, -26.0,
  30.0, -36.0, -26.0, -36.0, -26.0, 18.0, -19.0, 18.0,
];

bool _inPoly(double x, double y, List<double> p) {
  var inside = false;
  for (var i = 0, j = p.length - 2; i < p.length; j = i, i += 2) {
    final xi = p[i], yi = p[i + 1], xj = p[j], yj = p[j + 1];
    if ((yi > y) != (yj > y) && x < (xj - xi) * (y - yi) / (yj - yi) + xi) {
      inside = !inside;
    }
  }
  return inside;
}

/// Continent of a land point, or null (Antarctica and far-off islands).
/// The order of the checks matters: the first match wins.
Continent? continentAt(double lat, double lon) {
  if (lat < -60) return null; // Antarctica

  // Oceania: Australia, New Zealand, Melanesia, Micronesia, Polynesia.
  if (lon >= 112 && lat < -8.5) return Continent.oceania;
  if (lon >= 131 && lat > -12 && lat < 2) return Continent.oceania;
  if (lon >= 131 && lon <= 180 && lat >= 2 && lat <= 20) return Continent.oceania;
  if (lon <= -130 && lat > -50 && lat < 0) return Continent.oceania;
  if (lon >= -161 && lon <= -154 && lat >= 18 && lat <= 23) return Continent.oceania; // Hawaii

  // South America (Panama is North America).
  if (lon > -93 && lon < -33 && lat >= -57 && lat <= 12.8 && (lon > -77.4 || lat < 7.4)) {
    return Continent.southAmerica;
  }

  // The Azores belong to Europe.
  if (lon >= -32 && lon <= -24 && lat >= 36 && lat <= 40) return Continent.europe;
  if (_inPoly(lon, lat, _europe)) return Continent.europe;
  if (_inPoly(lon, lat, _africa)) return Continent.africa;

  // The far east of Russia crosses the date line.
  if (lon < -169 && lat >= 62) return Continent.asia;
  if (lon < -10 && lat >= 7) return Continent.northAmerica; // incl. Greenland
  if (lon > 25 && lat > -11) return Continent.asia;
  return null;
}
