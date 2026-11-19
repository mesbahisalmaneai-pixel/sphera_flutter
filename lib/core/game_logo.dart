import 'dart:io';

import 'package:flutter/material.dart';

import '../data/database.dart';
import 'theme.dart';

enum GameImageKind { card, account }

String slugOf(String name) => name
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
    .replaceAll(RegExp(r'^_+|_+$'), '');

/// Local game image. Lookup order: game id, then game-name slug; jpg then png.
/// kind == account tries `key_account' first, then falls back to the card image,
/// then to a placeholder icon. A user-picked image (file path, not an asset) wins.
class GameImage extends StatelessWidget {
  const GameImage(
    this.game, {
    super.key,
    this.kind = GameImageKind.card,
    this.photoPath,
    this.width,
    this.height,
    this.radius = 12,
    this.fit = BoxFit.cover,
  });

  final Game game;
  final GameImageKind kind;

  /// A photo picked for one single account; wins over the game's own images.
  final String? photoPath;
  final double? width;
  final double? height;
  final double? radius;
  final BoxFit fit;

  List<String> _paths() {
    final keys = {game.id, slugOf(game.name)}.toList();
    final suffixes =
        kind == GameImageKind.account ? ['_account', ''] : [''];

    return [
      for (final suffix in suffixes)
        for (final key in keys)
          for (final extension in ['jpg', 'png'])
            'assets/images/games/$key$suffix.$extension',
    ];
  }

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: SpheraColors.surfaceHigh,
        child: Center(
          child: Icon(
            Icons.sports_esports_outlined,
            color: SpheraColors.goldSoft,
            size: 32,
          ),
        ),
      );

  Widget _chain(List<String> paths, int i) {
    if (i >= paths.length) return _placeholder();

    return Image.asset(
      paths[i],
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _chain(paths, i + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final custom = photoPath ??
        (kind == GameImageKind.account
            ? game.accountImagePath
            : game.logoAssetPath);

    final Widget child;
    if (custom != null && !custom.startsWith('assets/')) {
      child = Image.file(
        File(custom),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _chain(_paths(), 0),
      );
    } else {
      child = _chain(_paths(), 0);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 12),
      child: child,
    );
  }
}

/// Small square game image (app bars, lists).
class GameLogo extends StatelessWidget {
  const GameLogo(
    this.game, {
    super.key,
    this.size = 56,
  });

  final Game game;
  final double size;

  @override
  Widget build(BuildContext context) => GameImage(
        game,
        width: size,
        height: size,
        radius: size * 0.2,
      );
}
