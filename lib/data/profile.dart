import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local profile (the app has no sign-in yet, everything is stored on the device).
class ProfileData {
  const ProfileData({this.name = '', this.email = '', this.photoPath, required this.sessionStart});
  final String name;
  final String email;
  final String? photoPath;
  final DateTime sessionStart;

  ProfileData copyWith({String? name, String? email, String? photoPath, bool clearPhoto = false}) =>
      ProfileData(
        name: name ?? this.name,
        email: email ?? this.email,
        photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
        sessionStart: sessionStart,
      );
}

class ProfileNotifier extends Notifier<ProfileData> {
  @override
  ProfileData build() {
    _load();
    return ProfileData(sessionStart: DateTime.now());
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = state.copyWith(
      name: p.getString('profile_name') ?? '',
      email: p.getString('profile_email') ?? '',
      photoPath: p.getString('profile_photo'),
    );
  }

  Future<void> setInfo(String name, String email) async {
    state = state.copyWith(name: name, email: email);
    final p = await SharedPreferences.getInstance();
    await p.setString('profile_name', name);
    await p.setString('profile_email', email);
  }

  /// Returns null on success (or if cancelled), or an error message.
  Future<String?> pickPhoto() async {
    if (kIsWeb) return 'Profile photos work in the phone app, not in the browser.';
    try {
      final x = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 85);
      if (x == null) return null;
      final dir = await getApplicationDocumentsDirectory();
      final dest = File('${dir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await File(x.path).copy(dest.path);
      await _deleteOld();
      state = state.copyWith(photoPath: dest.path);
      (await SharedPreferences.getInstance()).setString('profile_photo', dest.path);
      return null;
    } catch (e) {
      return 'Could not set photo: $e';
    }
  }

  Future<void> removePhoto() async {
    await _deleteOld();
    state = state.copyWith(clearPhoto: true);
    (await SharedPreferences.getInstance()).remove('profile_photo');
  }

  Future<void> _deleteOld() async {
    final old = state.photoPath;
    if (old == null) return;
    try {
      final f = File(old);
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }

  /// Clears the profile only (name, email, photo). Accounts and games are kept.
  Future<void> clear() async {
    await _deleteOld();
    state = ProfileData(sessionStart: DateTime.now());
    final p = await SharedPreferences.getInstance();
    await p.remove('profile_name');
    await p.remove('profile_email');
    await p.remove('profile_photo');
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileData>(ProfileNotifier.new);
