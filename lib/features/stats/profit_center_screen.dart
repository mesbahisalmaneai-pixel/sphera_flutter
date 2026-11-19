import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/format.dart';
import '../../core/game_logo.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/game_account_repository.dart' show profitOf;
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../games/game_account_detail_screen.dart';
import 'stats_drilldown.dart';

/// Profit Center: Sales (sale price), Expenses (purchase price), Net Profit.
/// Expenses = the purchase price of the accounts (no separate expenses).
class ProfitCenterScreen extends ConsumerStatefulWidget {
  const ProfitCenterScreen({super.key});

  @override
  ConsumerState<ProfitCenterScreen> createState() => _ProfitCenterScreenState();
}

class _ProfitCenterScreenState extends ConsumerState<ProfitCenterScreen> {
  String _filter = 'all'; // all | active | sell

  Widget _section(String t) => Padding(
        padding: EdgeInsets.fromLTRB(0, 22, 0, 10),
        child: Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
      );

  Color _c(double v) => v >= 0 ? SpheraColors.done : SpheraColors.danger;

  Widget _stat(String label, String value, Color color) => Card(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(label, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final cur = ref.watch(currencyProvider);
    final games = ref.watch(activeGamesProvider).value ?? <Game>[];
    final gameIds = {for (final g in games) g.id};
    final all = (ref.watch(allGameAccountsProvider).value ?? <GameAccount>[])
        .where((a) => gameIds.contains(a.gameId))
        .where((a) {
      if (_filter == 'active') return a.status == GameAccountStatus.active;
      if (_filter == 'sell') return a.status == GameAccountStatus.sell;
      return true;
    }).toList();

    final sales = all.fold<double>(0, (t, a) => t + a.salePrice);
    final expenses = all.fold<double>(0, (t, a) => t + a.purchasePrice);
    final net = sales - expenses;
    final margin = expenses > 0 ? net / expenses * 100 : 0.0;

    final sorted = [...all]..sort((a, b) => profitOf(b).compareTo(profitOf(a)));
    final top = sorted.where((a) => profitOf(a) > 0).take(5).toList();
    final losses = sorted.reversed.where((a) => profitOf(a) < 0).take(5).toList();
    final gameById = {for (final g in games) g.id: g};

    Widget accountTile(GameAccount a) => Card(
          child: ListTile(
            title: Text(a.name, overflow: TextOverflow.ellipsis),
            subtitle: Text(gameById[a.gameId]?.name ?? '',
                style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            trailing: Text(signedMoney(profitOf(a), currency: cur),
                style: TextStyle(fontWeight: FontWeight.w700, color: _c(profitOf(a)))),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => GameAccountDetailScreen(accountId: a.id))),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profitCenter)),
      body: ListView(padding: EdgeInsets.all(16), children: [
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'all', label: Text('All')),
            ButtonSegment(value: 'active', label: Text('Active')),
            ButtonSegment(value: 'sell', label: Text('Sold')),
          ],
          selected: {_filter},
          onSelectionChanged: (s) => setState(() => _filter = s.first),
        ),
        SizedBox(height: 14),
        Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.l10n.netProfit, style: TextStyle(color: SpheraColors.muted)),
                SizedBox(height: 2),
                Text(context.l10n.accountsCount(all.length),
                    style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(signedMoney(net, currency: cur),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _c(net))),
                Text(context.l10n.marginPct('${margin >= 0 ? '+' : ''}${margin.toStringAsFixed(1)}'),
                    style: TextStyle(color: _c(net), fontSize: 12)),
              ]),
            ]),
          ),
        ),
        SizedBox(height: 10),
        // A Row (not a fixed-ratio grid): the cards grow with their text, so a long
        // label or a big system font size can never overflow. IntrinsicHeight keeps
        // both cards the same height.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _stat(context.l10n.salesSalePrice, money(sales, currency: cur), SpheraColors.gold)),
              SizedBox(width: 10),
              Expanded(child: _stat(context.l10n.expensesPurchasePrice, money(expenses, currency: cur), SpheraColors.muted)),
            ],
          ),
        ),
        _section(context.l10n.perGame),
        if (games.isEmpty)
          Text(context.l10n.noGamesYet, style: TextStyle(color: SpheraColors.muted))
        else
          for (final g in games)
            () {
              final mine = all.where((a) => a.gameId == g.id).toList();
              final s = mine.fold<double>(0, (t, a) => t + a.salePrice);
              final e = mine.fold<double>(0, (t, a) => t + a.purchasePrice);
              return Card(
                child: ListTile(
                  leading: GameLogo(g, size: 40),
                  title: Text(g.name),
                  subtitle: Text(
                      context.l10n.salesAndExpenses(money(s, currency: cur), money(e, currency: cur)),
                      style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                  trailing: Text(signedMoney(s - e, currency: cur),
                      style: TextStyle(fontWeight: FontWeight.w700, color: _c(s - e))),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => GameStatusAccountsScreen(game: g))),
                ),
              );
            }(),
        if (top.isNotEmpty) ...[
          _section(context.l10n.topProfit),
          for (final a in top) accountTile(a),
        ],
        if (losses.isNotEmpty) ...[
          _section(context.l10n.losses),
          for (final a in losses) accountTile(a),
        ],
      ]),
    );
  }
}
