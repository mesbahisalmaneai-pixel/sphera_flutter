import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/dashboard.dart';
import '../../data/performance.dart';
import '../../data/settings.dart';
import '../home/dashboard_widgets.dart' show PerformanceCard;

/// Performance Center: today / this week / this month vs the period before,
/// monthly goals, best periods and the add streak.
class PerformanceCenterScreen extends ConsumerWidget {
  const PerformanceCenterScreen({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static String _day(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 22, 0, 10),
        child: Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
      );

  Color _c(double v) => v >= 0 ? SpheraColors.done : SpheraColors.danger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(currencyProvider);
    final loading = ref.watch(dashboardLoadingProvider);
    final goals = ref.watch(goalsProvider);
    final profitGoal = ref.watch(profitGoalProvider);
    final accountsGoal = ref.watch(accountsGoalProvider);
    final streak = ref.watch(addStreakProvider);

    Widget periodCard(PerfPeriod p, String label, String prevLabel) {
      final s = ref.watch(periodSummaryProvider(p));
      final pct = s.profitChangePct;
      final delta = s.profitDelta;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Stacked lines (not side-by-side columns) so long amounts and big
          // system fonts wrap instead of overflowing on narrow phones.
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(signedMoney(s.profit, currency: cur),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _c(s.profit))),
                ),
              ),
            ]),
            const SizedBox(height: 4),
            Text('${s.added} added · ${s.prevAdded} $prevLabel',
                style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            const SizedBox(height: 2),
            Text(
              delta == 0
                  ? 'Same profit as $prevLabel'
                  : '${signedMoney(delta, currency: cur)} vs $prevLabel'
                      '${pct == null ? '' : ' (${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(0)}%)'}',
              style: TextStyle(color: delta == 0 ? SpheraColors.muted : _c(delta), fontSize: 12),
            ),
          ]),
        ),
      );
    }

    Widget goalRow(String label, GoalProgress g, String Function(double) fmt) {
      final color = g.reached
          ? SpheraColors.done
          : g.onTrack
              ? SpheraColors.gold
              : SpheraColors.coming;
      final status = g.reached
          ? 'Reached'
          : g.onTrack
              ? 'On track'
              : 'Behind pace';
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
            Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, c) {
            return Stack(children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                    color: SpheraColors.surfaceHigh, borderRadius: BorderRadius.circular(4)),
              ),
              Container(
                height: 8,
                width: c.maxWidth * g.fraction,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
              ),
              // Where you should be by today.
              Positioned(
                left: (c.maxWidth * g.expectedFraction - 1).clamp(0.0, c.maxWidth - 2).toDouble(),
                child: Container(width: 2, height: 8, color: SpheraColors.ivory.withValues(alpha: 0.6)),
              ),
            ]);
          }),
          const SizedBox(height: 6),
          Text('${fmt(g.current)} of ${fmt(g.target)} · ${(g.fraction * 100).toStringAsFixed(0)}%',
              style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        ]),
      );
    }

    final daily = ref.watch(performanceProvider(PerfRange.daily));
    final weekly = ref.watch(performanceProvider(PerfRange.weekly));
    final monthly = ref.watch(performanceProvider(PerfRange.monthly));
    final bestDay = bestBucket(daily);
    final bestWeek = bestBucket(weekly);
    final bestMonth = bestBucket(monthly);

    Widget highlight(IconData icon, String title, String value, String? sub) => Card(
          child: ListTile(
            leading: Icon(icon, color: SpheraColors.gold),
            title: Text(title),
            subtitle: sub == null ? null : Text(sub, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Performance Center')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.all(16), children: [
              periodCard(PerfPeriod.today, 'Today', 'yesterday'),
              periodCard(PerfPeriod.week, 'This week', 'last week'),
              periodCard(PerfPeriod.month, 'This month', 'last month'),
              Row(children: [
                Expanded(child: _section('Monthly goals')),
                TextButton.icon(
                  onPressed: () => _editGoals(context, ref, goals, cur),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(goals.any ? 'Edit' : 'Set goals'),
                ),
              ]),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: profitGoal == null && accountsGoal == null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                              'No goals yet. Set a monthly profit or accounts goal to track your pace.',
                              style: TextStyle(color: SpheraColors.muted)),
                        )
                      : Column(children: [
                          if (profitGoal != null)
                            goalRow('Profit', profitGoal, (v) => money(v, currency: cur)),
                          if (accountsGoal != null)
                            goalRow('Accounts added', accountsGoal, (v) => v.toStringAsFixed(0)),
                        ]),
                ),
              ),
              const SizedBox(height: 14),
              const PerformanceCard(),
              _section('Highlights'),
              highlight(Icons.local_fire_department_outlined, 'Add streak',
                  streak == 0 ? '-' : '$streak day${streak == 1 ? '' : 's'}',
                  'Days in a row with a new account'),
              highlight(Icons.today_outlined, 'Best day (30 days)',
                  bestDay == null ? '-' : signedMoney(bestDay.profit, currency: cur),
                  bestDay == null ? null : _day(bestDay.start)),
              highlight(Icons.date_range_outlined, 'Best week (12 weeks)',
                  bestWeek == null ? '-' : signedMoney(bestWeek.profit, currency: cur),
                  bestWeek == null ? null : 'Week of ${_day(bestWeek.start)}'),
              highlight(Icons.calendar_month_outlined, 'Best month (12 months)',
                  bestMonth == null ? '-' : signedMoney(bestMonth.profit, currency: cur),
                  bestMonth == null ? null : '${_months[bestMonth.start.month - 1]} ${bestMonth.start.year}'),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                child: Text('Accounts count in the period they were added. FOR SALE accounts have no profit yet.',
                    style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
              ),
            ]),
    );
  }

  Future<void> _editGoals(
      BuildContext context, WidgetRef ref, PerformanceGoals goals, CurrencySettings cur) async {
    final profitCtl = TextEditingController(
        text: goals.monthlyProfit > 0 ? amountText(cur.toDisplay(goals.monthlyProfit)) : '');
    final accountsCtl =
        TextEditingController(text: goals.monthlyAccounts > 0 ? '${goals.monthlyAccounts}' : '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Monthly goals'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: profitCtl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            decoration: InputDecoration(labelText: 'Profit goal (${cur.code})', hintText: 'Empty = no goal'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: accountsCtl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Accounts to add', hintText: 'Empty = no goal'),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (saved == true) {
      final shown = double.tryParse(profitCtl.text.replaceAll(',', '.')) ?? 0;
      await ref.read(goalsProvider.notifier).set(
            monthlyProfit: cur.toBase(shown),
            monthlyAccounts: int.tryParse(accountsCtl.text) ?? 0,
          );
    }
    // Controllers are not disposed here: the dialog's fields still use them
    // during its closing animation. They hold no listeners, so GC frees them.
  }
}
