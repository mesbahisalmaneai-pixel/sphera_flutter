import '../orbit/models/orbit_destination.dart';
import 'earth_continents.dart';
import 'earth_scene.dart';

/// Which continent hosts which section. Change a line here to move a section
/// to another continent. The content of every section (its list of screens)
/// still comes from `buildOrbitSections`, so there is ONE place to add or
/// remove a screen of the app.
///
/// The Earth starts facing Europe/Africa/Asia, so the sections used most sit
/// there; the others appear as the Earth turns (or from the shortcut chips).
const Map<String, Continent> kSectionContinent = {
  'stats': Continent.africa,
  'cards': Continent.asia,
  'profile': Continent.europe,
  'games': Continent.northAmerica,
  'google': Continent.southAmerica,
  'settings': Continent.oceania,
};

/// One pin per section, one continent per pin. A section without a preset
/// takes the first free continent, so a new section never disappears.
/// With more than six sections the extra ones have no continent (and no pin).
List<EarthPin> buildEarthPins(List<OrbitSection> sections) {
  final used = <Continent>{};
  final pins = <EarthPin>[];
  final unplaced = <int>[];

  EarthPin pinFor(int i, Continent c) => EarthPin(
        sectionIndex: i,
        continent: c,
        label: sections[i].label,
        icon: sections[i].icon,
      );

  for (var i = 0; i < sections.length; i++) {
    final c = kSectionContinent[sections[i].id];
    if (c != null && used.add(c)) {
      pins.add(pinFor(i, c));
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
    pins.add(pinFor(i, free));
  }
  return pins;
}
