import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/activity_providers.dart';
import '../../data/dashboard.dart';
import '../../data/database.dart';
import '../../data/settings.dart';
import '../../core/sphera_logo.dart';
import '../games/game_account_form.dart';
import '../sale/for_sale_screen.dart';
import '../stats/activity_center_screen.dart';
import '../stats/status_lists.dart';
import 'account_search.dart';

// ============================ shared bits ============================

/// Grey placeholder shown while data loads.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 14});
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: SpheraColors.surfaceHigh,
          borderRadius: BorderRadius.circular(6),
        ),
      );
}

Widget _cardTitle(String t) =>
    Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15));

// ============================ KPI cards ============================

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.loading,
    this.subtitle,
    this.subtitleColor,
    this.valueColor,
    this.onTap,
  });
  final VoidCallback? onTap;
  final String label;
  final String value;
  final IconData icon;
  final bool loading;
  final String? subtitle;
  final Color? subtitleColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 18, color: SpheraColors.gold),
            SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            ),
          ]),
          SizedBox(height: 10),
          if (loading) ...[
            SkeletonBox(width: 80, height: 26),
            SizedBox(height: 8),
            SkeletonBox(width: 100, height: 11),
          ] else ...[
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: valueColor ?? SpheraColors.ivory)),
            ),
            SizedBox(height: 4),
            Text(subtitle ?? ' ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: subtitleColor ?? SpheraColors.muted)),
          ],
        ]),
      ),
      ),
    );
  }
}

/// Net Profit + Total / Active / For Sale / Sold (cards open their lists).
class KpiGrid extends ConsumerWidget {
  const KpiGrid({super.key});

  String _pctOfTotal(int part, int total) =>
      total == 0 ? 'No accounts yet' : '${(part / total * 100).round()}% of total';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(dashboardLoadingProvider);
    final k = ref.watch(dashboardKpisProvider);
    final cur = ref.watch(currencyProvider);

    // Net profit subtitle: real month-over-month change when there is a base.
    final pct = k.profitChangePct;
    String profitSub;
    Color profitSubColor;
    if (pct != null) {
      final up = pct >= 0;
      profitSub = '${up ? '▲' : '▼'} ${pct.abs().toStringAsFixed(1)}% vs last month';
      profitSubColor = up ? SpheraColors.done : SpheraColors.danger;
    } else {
      profitSub = 'This month ${signedMoney(k.profitThisMonth, currency: cur)}';
      profitSubColor = SpheraColors.muted;
    }

    void openStatus(GameAccountStatus st) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => GameAccountsByStatusScreen(status: st)));

    return Column(children: [
      KpiCard(
        label: 'Net Profit',
        value: signedMoney(k.netProfit, currency: cur),
        icon: Icons.account_balance_wallet_outlined,
        loading: loading,
        valueColor: k.netProfit >= 0 ? SpheraColors.done : SpheraColors.danger,
        subtitle: profitSub,
        subtitleColor: profitSubColor,
      ),
      SizedBox(height: 12),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: KpiCard(
            label: 'Total Accounts',
            value: '${k.total}',
            icon: Icons.layers_outlined,
            loading: loading,
            subtitle: k.addedThisMonth == 0 ? 'None added this month' : '+${k.addedThisMonth} this month',
            subtitleColor: k.addedThisMonth == 0 ? null : SpheraColors.done,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: KpiCard(
            label: 'Active Accounts',
            value: '${k.active}',
            icon: Icons.bolt_outlined,
            loading: loading,
            subtitle: _pctOfTotal(k.active, k.total),
            onTap: () => openStatus(GameAccountStatus.active),
          ),
        ),
      ]),
      SizedBox(height: 12),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: KpiCard(
            label: 'For Sale',
            value: '${k.forSale}',
            icon: Icons.sell_outlined,
            loading: loading,
            subtitle: k.forSale == 0 ? 'Nothing listed' : 'Listed, no price',
            valueColor: SpheraColors.coming,
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ForSaleScreen())),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: KpiCard(
            label: 'Sold',
            value: '${k.sold}',
            icon: Icons.check_circle_outline,
            loading: loading,
            subtitle: _pctOfTotal(k.sold, k.total),
            onTap: () => openStatus(GameAccountStatus.sell),
          ),
        ),
      ]),
    ]);
  }
}

// ============================ Performance graph ============================

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
String _two(int n) => n.toString().padLeft(2, '0');

String _bucketLabel(PerfRange r, DateTime d, {bool long = false}) => switch (r) {
      PerfRange.daily => '${_two(d.day)} ${_months[d.month - 1]}',
      PerfRange.weekly => long ? 'Week of ${_two(d.day)} ${_months[d.month - 1]}' : '${_two(d.day)} ${_months[d.month - 1]}',
      PerfRange.monthly => long ? '${_months[d.month - 1]} ${d.year}' : _months[d.month - 1],
    };

class PerformanceCard extends ConsumerStatefulWidget {
  const PerformanceCard({super.key});
  @override
  ConsumerState<PerformanceCard> createState() => _PerformanceCardState();
}

class _PerformanceCardState extends ConsumerState<PerformanceCard> {
  PerfRange _range = PerfRange.daily;
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(dashboardLoadingProvider);
    final points = ref.watch(performanceProvider(_range));
    final cur = ref.watch(currencyProvider);

    final totalProfit = points.fold<double>(0, (s, p) => s + p.profit);
    final totalCount = points.fold<int>(0, (s, p) => s + p.count);
    final sel = (_selected != null && _selected! < points.length) ? points[_selected!] : null;

    final summary = sel == null
        ? '${signedMoney(totalProfit, currency: cur)} · $totalCount account${totalCount == 1 ? '' : 's'}'
        : '${_bucketLabel(_range, sel.start, long: true)}: ${signedMoney(sel.profit, currency: cur)} · ${sel.count} account${sel.count == 1 ? '' : 's'}';
    final summaryColor = (sel?.profit ?? totalProfit) >= 0 ? SpheraColors.done : SpheraColors.danger;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _cardTitle('Performance'),
          SizedBox(height: 2),
          Text('Profit by date added', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<PerfRange>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: PerfRange.daily, label: Text('Daily')),
                ButtonSegment(value: PerfRange.weekly, label: Text('Weekly')),
                ButtonSegment(value: PerfRange.monthly, label: Text('Monthly')),
              ],
              selected: {_range},
              onSelectionChanged: (s) => setState(() {
                _range = s.first;
                _selected = null;
              }),
            ),
          ),
          SizedBox(height: 14),
          if (loading)
            SkeletonBox(height: 170)
          else ...[
            Text(summary,
                style: TextStyle(color: summaryColor, fontWeight: FontWeight.w600, fontSize: 13)),
            SizedBox(height: 10),
            if (totalCount == 0)
              SizedBox(
                height: 150,
                child: Center(
                  child: Text('No accounts added in this period',
                      style: TextStyle(color: SpheraColors.muted)),
                ),
              )
            else
              LayoutBuilder(builder: (context, c) {
                final w = c.maxWidth;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (d) {
                    final i = (d.localPosition.dx / (w / points.length)).floor().clamp(0, points.length - 1);
                    setState(() => _selected = _selected == i ? null : i);
                  },
                  child: SizedBox(
                    width: w,
                    height: 150,
                    child: CustomPaint(
                      painter: _BarsPainter(
                        values: [for (final p in points) p.profit],
                        selected: _selected,
                        positive: SpheraColors.done,
                        negative: SpheraColors.danger,
                        baseline: SpheraColors.border,
                        highlight: SpheraColors.gold,
                      ),
                    ),
                  ),
                );
              }),
            SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              for (final i in {0, points.length ~/ 2, points.length - 1})
                Text(_bucketLabel(_range, points[i].start),
                    style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
            ]),
          ],
        ]),
      ),
    );
  }
}

/// Bars above the baseline for profit, below it for loss. The baseline sits
/// where positive and negative extremes balance, so mixed data fits in 150px.
class _BarsPainter extends CustomPainter {
  _BarsPainter({
    required this.values,
    required this.selected,
    required this.positive,
    required this.negative,
    required this.baseline,
    required this.highlight,
  });
  final List<double> values;
  final int? selected;
  final Color positive, negative, baseline, highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;
    final maxPos = values.fold<double>(0, math.max);
    final maxNeg = values.fold<double>(0, math.min).abs();
    final span = maxPos + maxNeg;
    final baseY = span == 0 ? size.height : size.height * (maxPos / span);

    canvas.drawLine(Offset(0, baseY), Offset(size.width, baseY),
        Paint()..color = baseline..strokeWidth = 1);

    final slot = size.width / n;
    final barW = slot * 0.62;
    for (var i = 0; i < n; i++) {
      final v = values[i];
      if (v == 0 || span == 0) continue;
      final h = math.max(2.0, v.abs() / span * size.height);
      final x = slot * i + (slot - barW) / 2;
      final rect = v > 0 ? Rect.fromLTWH(x, baseY - h, barW, h) : Rect.fromLTWH(x, baseY, barW, h);
      final isSel = selected == i;
      final base = v > 0 ? positive : negative;
      final paint = Paint()
        ..color = selected == null || isSel ? base : base.withValues(alpha: 0.45);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(3)), paint);
      if (isSel) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(3)),
          Paint()
            ..color = highlight
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter old) =>
      old.selected != selected ||
      old.values.length != values.length ||
      !_sameValues(old.values, values) ||
      old.positive != positive ||
      old.negative != negative ||
      old.baseline != baseline ||
      old.highlight != highlight;

  static bool _sameValues(List<double> a, List<double> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// ============================ Recent activity ============================

(IconData, Color, String) _actionMeta(ActivityAction a) => switch (a) {
      ActivityAction.created => (Icons.add_circle_outline, SpheraColors.done, 'Added'),
      ActivityAction.updated => (Icons.edit_outlined, SpheraColors.gold, 'Updated'),
      ActivityAction.statusChanged => (Icons.swap_horiz_rounded, SpheraColors.coming, 'Status changed'),
      ActivityAction.trashed => (Icons.delete_outline, SpheraColors.danger, 'Moved to trash'),
      ActivityAction.restored => (Icons.restore_rounded, SpheraColors.done, 'Restored'),
      ActivityAction.deleted => (Icons.delete_forever_outlined, SpheraColors.danger, 'Deleted'),
    };

String _ago(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'Just now';
  if (d.inMinutes < 60) return '${d.inMinutes} min ago';
  if (d.inHours < 24) return '${d.inHours} h ago';
  if (d.inDays == 1) return 'Yesterday';
  if (d.inDays < 7) return '${d.inDays} days ago';
  return '${_two(t.day)}/${_two(t.month)}/${t.year}';
}

class RecentActivityCard extends ConsumerWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(activityLogProvider);

    Widget body;
    if (!async.hasValue) {
      body = Column(children: [
        for (var i = 0; i < 4; i++)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [
              SkeletonBox(width: 36, height: 36),
              SizedBox(width: 12),
              Expanded(child: SkeletonBox(height: 14)),
            ]),
          ),
      ]);
    } else {
      // Accounts only (Google + gaming), newest first.
      final items = async.value!
          .where((e) => e.type == ActivityType.googleAccount || e.type == ActivityType.gameAccount)
          .take(6)
          .toList();
      body = items.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No activity yet.\nNew actions will appear here.',
                    textAlign: TextAlign.center, style: TextStyle(color: SpheraColors.muted)),
              ),
            )
          : Column(children: [
              for (final e in items)
                () {
                  final (icon, color, label) = _actionMeta(e.action);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: color.withValues(alpha: 0.14),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    title: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(e.detail == null ? label : '$label · ${e.detail}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                    trailing: Text(_ago(e.createdAt),
                        style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
                  );
                }(),
            ]);
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            _cardTitle('Recent Activity'),
            Spacer(),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const ActivityCenterScreen())),
              child: Text('View all'),
            ),
          ]),
          body,
        ]),
      ),
    );
  }
}

// ============================ Quick actions ============================

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  Widget _btn(BuildContext context, IconData icon, String label, VoidCallback onTap) => Expanded(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 6),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, color: SpheraColors.gold, size: 26),
                SizedBox(height: 6),
                Text(label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _btn(context, Icons.add_circle_outline, 'Add Account', () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => GameAccountForm()));
      }),
      SizedBox(width: 10),
      _btn(context, Icons.search_rounded, 'Search Account', () {
        showSearch<void>(context: context, delegate: AccountSearchDelegate());
      }),
      SizedBox(width: 10),
      _btn(context, Icons.sports_esports_outlined, 'Manage Games', () {
        Navigator.of(context).pushNamed('/games');
      }),
    ]);
  }
}

// ============================ Logo = For Sale ============================

/// The SPHERA logo. Tapping it opens the For Sale list (no prices);
/// a small badge shows how many accounts are listed.
class LogoForSaleButton extends ConsumerWidget {
  const LogoForSaleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(forSaleAccountsProvider).length;
    return Tooltip(
      message: 'For Sale',
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const ForSaleScreen())),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Stack(clipBehavior: Clip.none, children: [
            SpheraLogo(height: 44),
            if (n > 0)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                      color: SpheraColors.coming, borderRadius: BorderRadius.circular(10)),
                  child: Text('$n',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black)),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
