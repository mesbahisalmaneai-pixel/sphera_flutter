import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/data/dashboard.dart';
import 'package:sphera_flutter/data/database.dart';

GameAccount acc(
  String id,
  double purchase,
  double sale,
  DateTime created, {
  GameAccountStatus status = GameAccountStatus.active,
}) =>
    GameAccount(
      id: id,
      ownerId: 'u1',
      gameId: 'efootball',
      idCompte: id,
      name: id,
      purchasePrice: purchase,
      salePrice: sale,
      status: status,
      playerPhotoIds: '[]',
      createdAt: created,
      updatedAt: created,
    );

void main() {
  // Thursday 15 Oct 2026, noon.
  final now = DateTime(2026, 10, 15, 12);

  group('computeKpis', () {
    test('counts by status and sums profit', () {
      final k = computeKpis([
        acc('a', 100, 150, DateTime(2026, 10, 2)), // +50, this month
        acc('b', 300, 250, DateTime(2026, 9, 20), status: GameAccountStatus.sell), // -50, last month
        acc('c', 10, 40, DateTime(2026, 9, 1), status: GameAccountStatus.sell), // +30, last month
        acc('d', 0, 0, DateTime(2025, 1, 1)), // old
      ], now: now);
      expect(k.total, 4);
      expect(k.active, 2);
      expect(k.sold, 2);
      expect(k.forSale, 0);
      expect(k.netProfit, 30);
      expect(k.addedThisMonth, 1);
      expect(k.profitThisMonth, 50);
      expect(k.profitLastMonth, -20);
    });

    test('FOR SALE accounts have no price: counted, but never in profit', () {
      final k = computeKpis([
        acc('a', 100, 150, DateTime(2026, 10, 2), status: GameAccountStatus.sell), // +50
        acc('b', 500, 0, DateTime(2026, 10, 3), status: GameAccountStatus.forSale), // would be -500
      ], now: now);
      expect(k.total, 2);
      expect(k.forSale, 1);
      expect(k.sold, 1);
      expect(k.addedThisMonth, 2);
      expect(k.netProfit, 50);
      expect(k.profitThisMonth, 50);
    });

    test('percentage change is null when last month has no base', () {
      final k = computeKpis([acc('a', 0, 50, DateTime(2026, 10, 1))], now: now);
      expect(k.profitLastMonth, 0);
      expect(k.profitChangePct, isNull);
    });

    test('percentage change vs last month', () {
      final k = computeKpis([
        acc('a', 0, 100, DateTime(2026, 9, 10)), // last month +100
        acc('b', 0, 112, DateTime(2026, 10, 10)), // this month +112
      ], now: now);
      expect(k.profitChangePct, closeTo(12, 1e-9));
    });

    test('January looks back to December of the previous year', () {
      final jan = DateTime(2026, 1, 10);
      final k = computeKpis([
        acc('a', 0, 40, DateTime(2025, 12, 31)),
        acc('b', 0, 60, DateTime(2026, 1, 2)),
      ], now: jan);
      expect(k.profitLastMonth, 40);
      expect(k.profitThisMonth, 60);
    });

    test('empty list', () {
      final k = computeKpis(const [], now: now);
      expect(k.total, 0);
      expect(k.netProfit, 0);
      expect(k.profitChangePct, isNull);
    });
  });

  group('buildPerformance', () {
    test('daily: 30 buckets ending today, accounts land in the right day', () {
      final pts = buildPerformance([
        acc('a', 0, 100, DateTime(2026, 10, 15, 9)), // today
        acc('b', 0, 20, DateTime(2026, 10, 15, 23)), // today
        acc('c', 50, 0, DateTime(2026, 10, 14, 8)), // yesterday, -50
        acc('d', 0, 999, DateTime(2026, 9, 15)), // 30 days ago: outside window
      ], PerfRange.daily, now: now);
      expect(pts.length, 30);
      expect(pts.last.start, DateTime(2026, 10, 15));
      expect(pts.last.profit, 120);
      expect(pts.last.count, 2);
      expect(pts[28].profit, -50);
      expect(pts.fold<int>(0, (s, p) => s + p.count), 3);
    });

    test('weekly: 12 buckets, weeks start on Monday', () {
      final pts = buildPerformance([
        acc('a', 0, 10, DateTime(2026, 10, 12, 8)), // Monday of this week
        acc('b', 0, 5, DateTime(2026, 10, 11, 8)), // Sunday -> previous week
      ], PerfRange.weekly, now: now);
      expect(pts.length, 12);
      expect(pts.last.start, DateTime(2026, 10, 12));
      expect(pts.last.profit, 10);
      expect(pts[10].profit, 5);
    });

    test('monthly: 12 buckets crossing a year boundary', () {
      final pts = buildPerformance([
        acc('a', 0, 7, DateTime(2026, 10, 3)),
        acc('b', 0, 3, DateTime(2025, 11, 30)),
        acc('c', 0, 99, DateTime(2025, 10, 31)), // 12+ months ago: outside window
      ], PerfRange.monthly, now: now);
      expect(pts.length, 12);
      expect(pts.first.start, DateTime(2025, 11));
      expect(pts.last.start, DateTime(2026, 10));
      expect(pts.last.profit, 7);
      expect(pts.first.profit, 3);
    });

    test('performance ignores FOR SALE accounts', () {
      final pts = buildPerformance([
        acc('a', 500, 0, DateTime(2026, 10, 15, 9), status: GameAccountStatus.forSale),
        acc('b', 0, 30, DateTime(2026, 10, 15, 10)),
      ], PerfRange.daily, now: now);
      expect(pts.last.count, 1);
      expect(pts.last.profit, 30);
    });

    test('no accounts -> all zero buckets', () {
      final pts = buildPerformance(const [], PerfRange.daily, now: now);
      expect(pts.every((p) => p.profit == 0 && p.count == 0), isTrue);
    });
  });
}
