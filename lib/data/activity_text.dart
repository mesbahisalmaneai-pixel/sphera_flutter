import 'package:drift/drift.dart' show Value;

import '../l10n/app_localizations.dart';
import 'database.dart';

/// Activity log details are stored as language-independent tokens and turned
/// into words when they are shown, so the log follows the app language.
///
/// A detail is tokens joined by [kDetailSeparator]. A token starting with
/// [kCodeMark] is a code (`§key=value`); any other token is plain text the
/// user typed (a game name), shown as is.
///
///   §grade=diamond           Google account grade
///   §boxes=3                 number of boxes changed
///   §status=sell             gaming account status
///   §statusChange=active>sell
///   §boxTo=coming            new box status (follows the game name)
const kDetailSeparator = ' · ';
const kCodeMark = '§';

String codeGrade(Grade g) => '${kCodeMark}grade=${g.name}';
String codeBoxes(int n) => '${kCodeMark}boxes=$n';
String codeStatus(GameAccountStatus s) => '${kCodeMark}status=${s.name}';
String codeStatusChange(GameAccountStatus from, GameAccountStatus to) =>
    '${kCodeMark}statusChange=${from.name}>${to.name}';
String codeBoxTo(BoxStatus s) => '${kCodeMark}boxTo=${s.name}';

String joinDetail(Iterable<String> tokens) => tokens.join(kDetailSeparator);

T? _byName<T extends Enum>(List<T> values, String name) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return null;
}

String _grade(AppLocalizations l, Grade g) => switch (g) {
      Grade.bronze => l.gradeBronze,
      Grade.silver => l.gradeSilver,
      Grade.gold => l.gradeGold,
      Grade.platinum => l.gradePlatinum,
      Grade.diamond => l.gradeDiamond,
      Grade.interdit => l.gradeInterdit,
    };

String _status(AppLocalizations l, GameAccountStatus s) => switch (s) {
      GameAccountStatus.active => l.statusActive,
      GameAccountStatus.sell => l.statusSold,
      GameAccountStatus.forSale => l.statusForSale,
    };

String _box(AppLocalizations l, BoxStatus s) => switch (s) {
      BoxStatus.empty => l.boxEmpty,
      BoxStatus.done => l.boxDone,
      BoxStatus.notYet => l.boxNotYet,
      BoxStatus.coming => l.boxComing,
    };

/// One code token in words, or null when it is not a known code (then the
/// raw token is shown, so nothing is ever lost).
String? _describeCode(String token, AppLocalizations l) {
  final eq = token.indexOf('=');
  if (!token.startsWith(kCodeMark) || eq < 0) return null;
  final key = token.substring(1, eq);
  final value = token.substring(eq + 1);
  switch (key) {
    case 'grade':
      final g = _byName(Grade.values, value);
      return g == null ? null : l.activityGrade(_grade(l, g));
    case 'boxes':
      final n = int.tryParse(value);
      return n == null ? null : l.activityBoxes(n);
    case 'status':
      final s = _byName(GameAccountStatus.values, value);
      return s == null ? null : _status(l, s);
    case 'statusChange':
      final parts = value.split('>');
      if (parts.length != 2) return null;
      final a = _byName(GameAccountStatus.values, parts[0]);
      final b = _byName(GameAccountStatus.values, parts[1]);
      return a == null || b == null ? null : '${_status(l, a)} → ${_status(l, b)}';
    case 'boxTo':
      final s = _byName(BoxStatus.values, value);
      return s == null ? null : '→ ${_box(l, s)}';
  }
  return null;
}

/// The stored [detail] in [l]'s language. Old entries written before codes
/// existed (and not converted) are shown unchanged.
String? describeActivityDetail(String? detail, AppLocalizations l) {
  if (detail == null || detail.isEmpty) return detail;
  final out = StringBuffer();
  for (final token in detail.split(kDetailSeparator)) {
    final text = _describeCode(token, l) ?? token;
    if (out.isNotEmpty) out.write(text.startsWith('→') ? ' ' : kDetailSeparator);
    out.write(text);
  }
  return out.toString();
}

// ---------------------------------------------------------------- legacy

final _legacyGrade = RegExp(r'^Grade (\w+)$');
final _legacyBoxes = RegExp(r'^(\d+) box(es)?$');
const _legacyStatus = {'Active': GameAccountStatus.active, 'Sold': GameAccountStatus.sell, 'For sale': GameAccountStatus.forSale};
final _legacyStatusChange = RegExp(r'^(Active|Sold|For sale) → (Active|Sold|For sale)$');
final _legacyBoxTo = RegExp(r'^(.+) → (empty|done|notYet|coming)$');

/// Converts a detail written in English by an older version into codes.
/// Returns null when nothing in it is recognized for sure (it is then kept
/// as it is). Only the exact formats older versions wrote are converted.
String? legacyDetailToCodes(String detail) {
  if (detail.contains(kCodeMark)) return null; // already converted
  var changed = false;
  final tokens = <String>[];
  for (final token in detail.split(kDetailSeparator)) {
    final g = _legacyGrade.firstMatch(token);
    final grade = g == null ? null : _byName(Grade.values, g.group(1)!);
    final b = _legacyBoxes.firstMatch(token);
    final sc = _legacyStatusChange.firstMatch(token);
    final bt = _legacyBoxTo.firstMatch(token);
    if (grade != null) {
      tokens.add(codeGrade(grade));
    } else if (b != null) {
      tokens.add(codeBoxes(int.parse(b.group(1)!)));
    } else if (sc != null) {
      tokens.add(codeStatusChange(_legacyStatus[sc.group(1)]!, _legacyStatus[sc.group(2)]!));
    } else if (_legacyStatus.containsKey(token) && tokens.isNotEmpty) {
      // "eFootball · Sold": a status after the game name.
      tokens.add(codeStatus(_legacyStatus[token]!));
    } else if (bt != null) {
      tokens
        ..add(bt.group(1)!)
        ..add(codeBoxTo(_byName(BoxStatus.values, bt.group(2)!)!));
    } else {
      tokens.add(token);
      continue;
    }
    changed = true;
  }
  return changed ? joinDetail(tokens) : null;
}

/// One-time upgrade of the activity log (database version 5): rewrites the
/// English details of older entries as codes. Unrecognized details are left
/// untouched; nothing is deleted. Returns how many entries were converted.
Future<int> migrateLegacyActivityDetails(AppDatabase db) async {
  final rows = await (db.select(db.activityLogs)..where((a) => a.detail.isNotNull())).get();
  var n = 0;
  for (final r in rows) {
    final converted = legacyDetailToCodes(r.detail!);
    if (converted == null) continue;
    await (db.update(db.activityLogs)..where((a) => a.id.equals(r.id)))
        .write(ActivityLogsCompanion(detail: Value(converted)));
    n++;
  }
  return n;
}
