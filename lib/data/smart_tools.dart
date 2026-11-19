import '../core/l10n.dart';
import 'dart:convert';
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';
import 'providers.dart';

/// Shared logic for the Smart Tools (Duplicate Scanner, Smart Organizer,
/// Inventory Vault, Security Center). Everything here only READS the accounts:
/// nothing is deleted or merged automatically.

String fmtDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

// ======================= Per-account info =======================

class AccountMeta {
  const AccountMeta(this.statuses, this.last);
  final Map<String, BoxStatus> statuses; // gameId -> status
  final DateTime? last; // last time a (non-empty) box was updated
  int get boxesSet => statuses.values.where((s) => s != BoxStatus.empty).length;
}

final accountMetaProvider = Provider<Map<String, AccountMeta>>((ref) {
  final boxes = ref.watch(googleBoxesProvider).value ?? <GoogleGameBox>[];
  final statuses = <String, Map<String, BoxStatus>>{};
  final last = <String, DateTime>{};
  for (final b in boxes) {
    (statuses[b.googleAccountId] ??= {})[b.gameId] = b.status;
    final cur = last[b.googleAccountId];
    if (b.status != BoxStatus.empty && (cur == null || b.updatedAt.isAfter(cur))) {
      last[b.googleAccountId] = b.updatedAt;
    }
  }
  return {for (final e in statuses.entries) e.key: AccountMeta(e.value, last[e.key])};
});

// ======================= Duplicate Scanner =======================

/// Lower-case, trim, and for Gmail ignore dots and "+tags".
String normalizeEmail(String e) {
  final s = e.trim().toLowerCase();
  final at = s.indexOf('@');
  if (at < 1) return s;
  var local = s.substring(0, at);
  var domain = s.substring(at + 1);
  if (domain == 'gmail.com' || domain == 'googlemail.com') {
    local = local.split('+').first.replaceAll('.', '');
    domain = 'gmail.com';
  }
  return '$local@$domain';
}

class DuplicateGroup {
  const DuplicateGroup(this.key, this.accounts);
  final String key;
  final List<GoogleAccount> accounts;
}

class DismissedDuplicatesNotifier extends Notifier<Set<String>> {
  static const _k = 'dup_dismissed';

  @override
  Set<String> build() {
    _load();
    return <String>{};
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = (p.getStringList(_k) ?? <String>[]).toSet();
  }

  Future<void> _save() async =>
      (await SharedPreferences.getInstance()).setStringList(_k, state.toList());

  Future<void> dismiss(String key) async {
    state = {...state, key};
    await _save();
  }

  Future<void> restore(String key) async {
    state = state.where((k) => k != key).toSet();
    await _save();
  }

  Future<void> clear() async {
    state = <String>{};
    await _save();
  }
}

final dismissedDuplicatesProvider =
    NotifierProvider<DismissedDuplicatesNotifier, Set<String>>(DismissedDuplicatesNotifier.new);

final duplicateGroupsProvider = Provider<List<DuplicateGroup>>((ref) {
  final accounts = ref.watch(googleAccountsProvider).value ?? <GoogleAccount>[];
  final dismissed = ref.watch(dismissedDuplicatesProvider);
  final map = <String, List<GoogleAccount>>{};
  for (final a in accounts) {
    (map[normalizeEmail(a.email)] ??= []).add(a);
  }
  return [
    for (final e in map.entries)
      if (e.value.length > 1 && !dismissed.contains(e.key)) DuplicateGroup(e.key, e.value),
  ];
});

/// Gaming accounts that share the same Account ID inside the same game.
String normalizeAccountId(String s) => s.trim().toLowerCase();

class GameDuplicateGroup {
  const GameDuplicateGroup(this.key, this.gameId, this.idCompte, this.accounts);
  final String key; // 'a|gameId|id'
  final String gameId;
  final String idCompte;
  final List<GameAccount> accounts;
}

final gameDuplicateGroupsProvider = Provider<List<GameDuplicateGroup>>((ref) {
  final accounts = ref.watch(allGameAccountsProvider).value ?? <GameAccount>[];
  final dismissed = ref.watch(dismissedDuplicatesProvider);
  final map = <String, List<GameAccount>>{};
  for (final a in accounts) {
    final id = normalizeAccountId(a.idCompte);
    if (id.isEmpty) continue;
    (map['a|${a.gameId}|$id'] ??= []).add(a);
  }
  return [
    for (final e in map.entries)
      if (e.value.length > 1 && !dismissed.contains(e.key))
        GameDuplicateGroup(e.key, e.value.first.gameId, e.value.first.idCompte.trim(), e.value),
  ];
});

// ======================= Inventory Vault =======================

/// Vault keys: 'g:<googleAccountId>' or 'a:<gameAccountId>'.
String vaultKeyGoogle(String id) => 'g:$id';
String vaultKeyGame(String id) => 'a:$id';

enum VaultTag {
  favorite(Icons.star_outline_rounded),
  rare(Icons.diamond_outlined),
  high(Icons.paid_outlined);

  const VaultTag(this.icon);
  final IconData icon;

  /// In the app language.
  String get label => switch (this) {
        VaultTag.favorite => appL10n.tagFavorite,
        VaultTag.rare => appL10n.tagRare,
        VaultTag.high => appL10n.tagHighValue,
      };
}

class VaultNotifier extends Notifier<Map<String, Set<VaultTag>>> {
  static const _k = 'vault_tags';

  @override
  Map<String, Set<VaultTag>> build() {
    _load();
    return <String, Set<VaultTag>>{};
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_k);
    if (raw == null) return;
    try {
      final m = (jsonDecode(raw) as Map).cast<String, dynamic>();
      final out = <String, Set<VaultTag>>{};
      for (final e in m.entries) {
        final tags = <VaultTag>{};
        for (final n in (e.value as List)) {
          for (final t in VaultTag.values) {
            if (t.name == n) tags.add(t);
          }
        }
        if (tags.isNotEmpty) out[e.key.contains(':') ? e.key : 'g:${e.key}'] = tags;
      }
      state = out;
    } catch (_) {}
  }

  Future<void> toggle(String accountId, VaultTag tag) async {
    final next = {for (final e in state.entries) e.key: Set<VaultTag>.of(e.value)};
    final s = next.putIfAbsent(accountId, () => <VaultTag>{});
    if (!s.add(tag)) s.remove(tag);
    if (s.isEmpty) next.remove(accountId);
    state = next;
    final enc = jsonEncode({
      for (final e in next.entries) e.key: [for (final t in e.value) t.name],
    });
    (await SharedPreferences.getInstance()).setString(_k, enc);
  }
}

final vaultProvider = NotifierProvider<VaultNotifier, Map<String, Set<VaultTag>>>(VaultNotifier.new);

// ======================= Security / data health =======================

class DataHealth {
  const DataHealth({
    required this.duplicates,
    required this.gameDuplicates,
    required this.invalidEmails,
    required this.missingIds,
    required this.noBoxes,
    required this.trashed,
  });
  final int duplicates; // Google duplicate groups
  final int gameDuplicates; // gaming duplicate groups (same Account ID)
  final int invalidEmails;
  final int missingIds; // gaming accounts without an Account ID
  final int noBoxes;
  final int trashed;
  int get issues => duplicates + gameDuplicates + invalidEmails + missingIds;
}

final dataHealthProvider = Provider<DataHealth>((ref) {
  final accounts = ref.watch(googleAccountsProvider).value ?? <GoogleAccount>[];
  final gameAccounts = ref.watch(allGameAccountsProvider).value ?? <GameAccount>[];
  final meta = ref.watch(accountMetaProvider);
  final emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  final trashed = (ref.watch(trashedGoogleAccountsProvider).value?.length ?? 0) +
      (ref.watch(trashedGameAccountsProvider).value?.length ?? 0);
  return DataHealth(
    duplicates: ref.watch(duplicateGroupsProvider).length,
    gameDuplicates: ref.watch(gameDuplicateGroupsProvider).length,
    invalidEmails: accounts.where((a) => !emailRe.hasMatch(a.email.trim())).length,
    missingIds: gameAccounts.where((a) => a.idCompte.trim().isEmpty).length,
    noBoxes: accounts.where((a) => (meta[a.id]?.boxesSet ?? 0) == 0).length,
    trashed: trashed,
  );
});
