import 'package:flutter/material.dart';

/// Tiles in rows of [columns], each row as tall as its tallest tile.
///
/// Use it instead of `GridView.count(childAspectRatio: …)` for stat tiles: a
/// fixed ratio cuts the number off when the text is bigger than planned
/// (large system font, a longer translation, another phone font).
class TileGrid extends StatelessWidget {
  const TileGrid({super.key, required this.columns, required this.children, this.spacing = 10});

  final int columns;
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var start = 0; start < children.length; start += columns) {
      final cells = <Widget>[];
      for (var i = 0; i < columns; i++) {
        if (i > 0) cells.add(SizedBox(width: spacing));
        final index = start + i;
        cells.add(Expanded(child: index < children.length ? children[index] : const SizedBox.shrink()));
      }
      if (rows.isNotEmpty) rows.add(SizedBox(height: spacing));
      rows.add(IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: cells),
      ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}
