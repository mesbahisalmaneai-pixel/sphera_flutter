import 'package:flutter/widgets.dart';

/// One real destination of the app, shown as a feature planet.
class OrbitDestination {
  const OrbitDestination({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.pattern,
    required this.builder,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;

  /// Surface pattern of the planet (0..4), so planets are recognisable.
  final int pattern;

  /// Builds the existing screen this planet opens.
  final WidgetBuilder builder;
}

/// A main section of the app, shown as a small indicator around the main planet.
class OrbitSection {
  const OrbitSection({
    required this.id,
    required this.label,
    required this.tagline,
    required this.icon,
    required this.destinations,
  });

  final String id;
  final String label;
  final String tagline;
  final IconData icon;
  final List<OrbitDestination> destinations;
}
