import '../../core/l10n.dart';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'arena_models.dart';

const _kKey = 'arena_tournaments_v1';

class ArenaState {
  const ArenaState({this.loaded = false, this.tournaments = const [], this.error});
  final bool loaded;
  final List<Tournament> tournaments;

  /// Set when stored data could not be read (a backup copy is kept).
  final String? error;

  Tournament? byId(String id) {
    for (final t in tournaments) {
      if (t.id == id) return t;
    }
    return null;
  }
}

/// Local-first storage for tournaments. Data lives on this device only until a
/// backend (e.g. Firebase) is connected.
class ArenaNotifier extends Notifier<ArenaState> {
  @override
  ArenaState build() {
    _load();
    return const ArenaState();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_kKey);
    if (raw == null) {
      state = const ArenaState(loaded: true);
      return;
    }
    try {
      final list = (jsonDecode(raw) as List)
          .map((e) => Tournament.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      state = ArenaState(loaded: true, tournaments: list);
    } catch (e) {
      // Never overwrite unreadable data: keep a backup copy first.
      await p.setString('${_kKey}_corrupt', raw);
      state = ArenaState(loaded: true, error: appL10n.arenaLoadError('$e'));
    }
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kKey, jsonEncode(state.tournaments.map((t) => t.toJson()).toList()));
  }

  Future<void> add(Tournament t) async {
    state = ArenaState(loaded: true, tournaments: [t, ...state.tournaments]);
    await _save();
  }

  Future<void> update(Tournament t) async {
    state = ArenaState(
      loaded: true,
      tournaments: [for (final x in state.tournaments) x.id == t.id ? t : x],
    );
    await _save();
  }

  Future<void> remove(String id) async {
    state = ArenaState(
      loaded: true,
      tournaments: state.tournaments.where((t) => t.id != id).toList(),
    );
    await _save();
  }
}

final arenaProvider = NotifierProvider<ArenaNotifier, ArenaState>(ArenaNotifier.new);
