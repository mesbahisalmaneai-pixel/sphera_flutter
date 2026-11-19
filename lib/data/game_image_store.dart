import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

enum GameImageSlot { card, account }

/// Lets the user pick an image from the gallery and keeps a private copy inside
/// the app's own storage (so it still works offline and after the original is deleted).
class GameImageStore {
  final _picker = ImagePicker();

  /// Photo for one single gaming account.
  Future<String?> pickAndSaveForAccount(String accountId) => _pickAndSave('account_$accountId');

  /// Returns the saved file path, or null if the user cancelled.
  Future<String?> pickAndSave(String gameId, GameImageSlot slot) => _pickAndSave('${gameId}_${slot.name}');

  Future<String?> _pickAndSave(String name) async {
    if (kIsWeb) return null; // photos are saved as files: phone app only
    final picked = await _picker.pickImage(
        source: ImageSource.gallery, maxWidth: 1280, maxHeight: 1280, imageQuality: 85);
    if (picked == null) return null;
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}${Platform.pathSeparator}game_images');
    await dir.create(recursive: true);
    final dest =
        '${dir.path}${Platform.pathSeparator}${name}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(picked.path).copy(dest);
    return dest;
  }

  /// Deletes an old picked image (never touches bundled assets).
  Future<void> deleteIfOurs(String? path) async {
    if (path == null || path.startsWith('assets/') || !path.contains('game_images')) return;
    final f = File(path);
    if (await f.exists()) await f.delete();
  }
}
