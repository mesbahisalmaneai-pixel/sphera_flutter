import 'dart:math' show max;
import 'package:flutter/material.dart' show IconData, Icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/l10n.dart';
import 'database.dart';
import 'providers.dart';
import 'settings.dart' show languageProvider;

/// Achievements are independent from rank (points) and from the
/// Google Play grades: they have their own conditions and their own points.

enum AchievementCategory {
  accounts(Icons.mail_outline),
  games(Icons.sports_esports_outlined),
  sales(Icons.sell_outlined),
  profits(Icons.trending_up_rounded),
  organization(Icons.checklist_rounded);

  const AchievementCategory(this.icon);
  final IconData icon;

  /// In the app language.
  String get label => switch (this) {
        AchievementCategory.accounts => appL10n.catAccounts,
        AchievementCategory.games => appL10n.catGames,
        AchievementCategory.sales => appL10n.catSales,
        AchievementCategory.profits => appL10n.catProfits,
        AchievementCategory.organization => appL10n.catOrganization,
      };
}

enum AchievementStatus { locked, inProgress, unlocked }

class Achievement {
  const Achievement({
    required this.id,
    required this.category,
    required this.icon,
    required this.title,
    required this.description,
    required this.target,
    required int current,
    required this.points,
    this.unlockedAt,
  }) : _current = current;

  final String id;
  final AchievementCategory category;
  final IconData icon;
  final String title;

  /// The unlock condition, shown to the user.
  final String description;
  final int target;
  final int points;
  final DateTime? unlockedAt;
  final int _current;

  /// Once unlocked, an achievement stays unlocked even if the numbers drop later.
  bool get done => unlockedAt != null || _current >= target;
  int get current => done ? target : _current.clamp(0, target);
  double get fraction => done ? 1.0 : (_current / target).clamp(0.0, 1.0).toDouble();

  AchievementStatus get status => done
      ? AchievementStatus.unlocked
      : (_current > 0 ? AchievementStatus.inProgress : AchievementStatus.locked);
}

// ======================= Unlock dates =======================

class AchievementDates {
  const AchievementDates({required this.loaded, required this.map});
  final bool loaded;
  final Map<String, DateTime> map;
}

class AchievementDatesNotifier extends Notifier<AchievementDates> {
  static const _prefix = 'ach_date_';

  @override
  AchievementDates build() {
    _load();
    return const AchievementDates(loaded: false, map: {});
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final m = <String, DateTime>{};
    for (final k in p.getKeys()) {
      if (!k.startsWith(_prefix)) continue;
      final d = DateTime.tryParse(p.getString(k) ?? '');
      if (d != null) m[k.substring(_prefix.length)] = d;
    }
    state = AchievementDates(loaded: true, map: m);
  }

  /// Saves today as the unlock date of each id (only the first time).
  Future<void> record(List<String> ids) async {
    final now = DateTime.now();
    final m = Map<String, DateTime>.of(state.map);
    for (final id in ids) {
      m.putIfAbsent(id, () => now);
    }
    state = AchievementDates(loaded: true, map: m);
    final p = await SharedPreferences.getInstance();
    for (final id in ids) {
      await p.setString('$_prefix$id', now.toIso8601String());
    }
  }
}

final achievementDatesProvider =
    NotifierProvider<AchievementDatesNotifier, AchievementDates>(AchievementDatesNotifier.new);

// ======================= The list =======================

final achievementsProvider = Provider<List<Achievement>>((ref) {
  final google = ref.watch(googleAccountCountProvider).value ?? 0;
  final games = ref.watch(gameCountProvider).value ?? 0;
  final gameAccounts = ref.watch(gameAccountCountProvider).value ?? 0;
  final profit = ref.watch(totalProfitProvider).value ?? 0.0;
  final stats = ref.watch(gameStatsProvider);
  final boxes = ref.watch(googleBoxesProvider).value ?? <GoogleGameBox>[];
  final dates = ref.watch(achievementDatesProvider);
  // Titles and conditions in the app language (rebuilt when it changes).
  final l = l10nFor(ref.watch(languageProvider));

  final sell = stats.fold<int>(0, (t, s) => t + s.sell);
  final profitableGames = stats.where((s) => s.profit > 0).length;
  final gamesWithAccounts = stats.where((s) => s.count > 0).length;
  final boxesSet = boxes.where((b) => b.status != BoxStatus.empty).length;
  final profitDh = profit > 0 ? profit.floor() : 0; // amounts are stored in DH

  Achievement a(String id, AchievementCategory cat, IconData icon, String title, String desc,
          int target, int current, int points) =>
      Achievement(
        id: id,
        category: cat,
        icon: icon,
        title: title,
        description: desc,
        target: target,
        current: current,
        points: points,
        unlockedAt: dates.map[id],
      );

  const acc = AchievementCategory.accounts;
  const gam = AchievementCategory.games;
  const sal = AchievementCategory.sales;
  const pro = AchievementCategory.profits;
  const org = AchievementCategory.organization;

  final list = <Achievement>[
    // Accounts
    a('acc_1', acc, Icons.mail_outline, l.achAcc1, l.achAcc1Desc, 1, google, 10),
    a('acc_10', acc, Icons.collections_bookmark_outlined, l.achAcc10, l.achAcc10Desc, 10, google, 25),
    a('acc_25', acc, Icons.library_books_outlined, l.achAcc25, l.achAcc25Desc, 25, google, 50),
    a('gacc_10', acc, Icons.person_add_alt_outlined, l.achGacc10, l.achGacc10Desc, 10, gameAccounts, 25),
    a('gacc_50', acc, Icons.groups_outlined, l.achGacc50, l.achGacc50Desc, 50, gameAccounts, 75),
    a('gacc_100', acc, Icons.diversity_3_outlined, l.achGacc100, l.achGacc100Desc, 100, gameAccounts, 150),
    // Games
    a('game_1', gam, Icons.sports_esports_outlined, l.achGame1, l.achGame1Desc, 1, games, 10),
    a('game_5', gam, Icons.videogame_asset_outlined, l.achGame5, l.achGame5Desc, 5, games, 25),
    a('game_10', gam, Icons.stadium_outlined, l.achGame10, l.achGame10Desc, 10, games, 50),
    // Sales
    a('sell_1', sal, Icons.sell_outlined, l.achSell1, l.achSell1Desc, 1, sell, 15),
    a('sell_10', sal, Icons.storefront_outlined, l.achSell10, l.achSell10Desc, 10, sell, 40),
    a('sell_50', sal, Icons.local_mall_outlined, l.achSell50, l.achSell50Desc, 50, sell, 100),
    // Profits
    a('profit_1', pro, Icons.trending_up_rounded, l.achProfit1, l.achProfit1Desc, 1, profit > 0 ? 1 : 0, 20),
    a('profit_1k', pro, Icons.savings_outlined, l.achProfit1k, l.achProfit1kDesc, 1000, profitDh, 50),
    a('profit_10k', pro, Icons.account_balance_outlined, l.achProfit10k, l.achProfit10kDesc, 10000, profitDh, 150),
    a('profit_games_3', pro, Icons.workspace_premium_outlined, l.achProfitGames3, l.achProfitGames3Desc, 3, profitableGames, 40),
    // Organization
    a('org_boxes_10', org, Icons.inventory_outlined, l.achBoxes10, l.achBoxes10Desc, 10, boxesSet, 20),
    a('org_boxes_50', org, Icons.inventory_2_outlined, l.achBoxes50, l.achBoxes50Desc, 50, boxesSet, 60),
    a('org_full', org, Icons.fact_check_outlined, l.achFull,
        l.achFullDesc,
        max(3, stats.length), gamesWithAccounts, 60),
  ];

  // Record the unlock date the first time an achievement is detected as done.
  if (dates.loaded) {
    final fresh = [for (final x in list) if (x.done && !dates.map.containsKey(x.id)) x.id];
    if (fresh.isNotEmpty) {
      Future.microtask(() => ref.read(achievementDatesProvider.notifier).record(fresh));
    }
  }
  return list;
});
