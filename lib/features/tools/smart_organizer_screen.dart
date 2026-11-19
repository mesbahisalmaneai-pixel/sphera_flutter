import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../../data/smart_tools.dart';
import '../games/game_accounts_screen.dart';
import '../google/google_account_form.dart';

enum _Mode { google, game }

enum _GSort {
  recent('Recent activity'),
  oldest('Oldest activity'),
  newestAdded('Newest added'),
  oldestAdded('Oldest added'),
  emailAz('Email A–Z'),
  emailZa('Email Z–A'),
  grade('Grade');

  const _GSort(this.label);
  final String label;
}

enum _ASort {
  newest('Newest'),
  oldest('Oldest'),
  saleHigh('Highest sale price'),
  saleLow('Lowest sale price'),
  buyHigh('Highest purchase price'),
  nameAz('Name A–Z');

  const _ASort(this.label);
  final String label;
}

/// Search, filter and sort accounts by game, status, price and date.
/// Read-only: it never changes or merges accounts.
class SmartOrganizerScreen extends ConsumerStatefulWidget {
  const SmartOrganizerScreen({super.key});

  @override
  ConsumerState<SmartOrganizerScreen> createState() => _SmartOrganizerScreenState();
}

class _SmartOrganizerScreenState extends ConsumerState<SmartOrganizerScreen> {
  _Mode _mode = _Mode.google;
  String _query = '';
  Game? _game;
  // Google
  Grade? _grade;
  BoxStatus? _status;
  _GSort _gSort = _GSort.recent;
  // Game accounts
  GameAccountStatus? _aStatus;
  _ASort _aSort = _ASort.newest;

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: EdgeInsets.only(right: 8),
        child: FilterChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
      );

  Widget _row(List<Widget> chips) => SizedBox(
        height: 44,
        child: ListView(scrollDirection: Axis.horizontal, children: chips),
      );

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(activeGamesProvider).value ?? <Game>[];
    final isGoogle = _mode == _Mode.google;

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Organizer'),
        actions: [
          if (isGoogle)
            PopupMenuButton<_GSort>(
              tooltip: 'Sort',
              icon: Icon(Icons.sort),
              initialValue: _gSort,
              onSelected: (v) => setState(() => _gSort = v),
              itemBuilder: (_) => [for (final s in _GSort.values) PopupMenuItem(value: s, child: Text(s.label))],
            )
          else
            PopupMenuButton<_ASort>(
              tooltip: 'Sort',
              icon: Icon(Icons.sort),
              initialValue: _aSort,
              onSelected: (v) => setState(() => _aSort = v),
              itemBuilder: (_) => [for (final s in _ASort.values) PopupMenuItem(value: s, child: Text(s.label))],
            ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<_Mode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: _Mode.google, icon: Icon(Icons.mail_outline, size: 18), label: Text('Google')),
                ButtonSegment(
                    value: _Mode.game, icon: Icon(Icons.sports_esports_outlined, size: 18), label: Text('Game accounts')),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() {
                _mode = s.first;
                _query = '';
              }),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: TextField(
            key: ValueKey(_mode),
            decoration: InputDecoration(
                hintText: isGoogle ? 'Search by email' : 'Search by name or Account ID',
                prefixIcon: Icon(Icons.search)),
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, top: 4),
          child: Column(children: [
            _row([
              _chip('All games', _game == null, () => setState(() => _game = null)),
              for (final g in games) _chip(g.name, _game?.id == g.id, () => setState(() => _game = g)),
            ]),
            if (isGoogle) ...[
              _row([
                _chip('Any status', _status == null, () => setState(() => _status = null)),
                for (final s in BoxStatus.values) _chip(boxLabel(s), _status == s, () => setState(() => _status = s)),
              ]),
              _row([
                _chip('All grades', _grade == null, () => setState(() => _grade = null)),
                for (final g in Grade.values) _chip(gradeLabel(g), _grade == g, () => setState(() => _grade = g)),
              ]),
            ] else
              _row([
                _chip('Any status', _aStatus == null, () => setState(() => _aStatus = null)),
                for (final s in GameAccountStatus.values)
                  _chip(s.name.toUpperCase(), _aStatus == s, () => setState(() => _aStatus = s)),
              ]),
          ]),
        ),
        Expanded(child: isGoogle ? _googleList() : _gameList()),
      ]),
    );
  }

  Widget _counter(int shown, int total, String sort) => Padding(
        padding: EdgeInsets.fromLTRB(20, 4, 20, 4),
        child: Row(children: [
          Text('$shown of $total accounts', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          Spacer(),
          Text('Sorted: $sort', style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        ]),
      );

  // ---------------- Google accounts ----------------
  Widget _googleList() {
    final all = ref.watch(googleAccountsProvider).value ?? <GoogleAccount>[];
    final meta = ref.watch(accountMetaProvider);

    final list = all.where((a) {
      if (_query.isNotEmpty && !a.email.contains(_query)) return false;
      if (_grade != null && a.grade != _grade) return false;
      final st = meta[a.id]?.statuses ?? const <String, BoxStatus>{};
      if (_game != null && _status != null) {
        if ((st[_game!.id] ?? BoxStatus.empty) != _status) return false;
      } else if (_game != null) {
        if ((st[_game!.id] ?? BoxStatus.empty) == BoxStatus.empty) return false;
      } else if (_status != null) {
        if (!st.values.contains(_status)) return false;
      }
      return true;
    }).toList();

    DateTime last(GoogleAccount a) => meta[a.id]?.last ?? DateTime(0);
    list.sort((a, b) => switch (_gSort) {
          _GSort.recent => last(b).compareTo(last(a)),
          _GSort.oldest => last(a).compareTo(last(b)),
          _GSort.newestAdded => b.createdAt.compareTo(a.createdAt),
          _GSort.oldestAdded => a.createdAt.compareTo(b.createdAt),
          _GSort.emailAz => a.email.compareTo(b.email),
          _GSort.emailZa => b.email.compareTo(a.email),
          _GSort.grade => a.grade.index.compareTo(b.grade.index),
        });

    return Column(children: [
      _counter(list.length, all.length, _gSort.label),
      Expanded(
        child: list.isEmpty
            ? Center(child: Text('No account matches', style: TextStyle(color: SpheraColors.muted)))
            : ListView.builder(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final a = list[i];
                  final m = meta[a.id];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: GradeMedal(a.grade, size: 38),
                      title: Text(a.email, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        '${gradeLabel(a.grade)} · ${m?.boxesSet ?? 0} boxes set · '
                        '${m?.last == null ? 'no activity' : fmtDate(m!.last!)} · added ${fmtDate(a.createdAt)}',
                        style: TextStyle(color: SpheraColors.muted, fontSize: 12),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => GoogleAccountForm(account: a, initialStatuses: m?.statuses ?? const {}))),
                    ),
                  );
                },
              ),
      ),
    ]);
  }

  // ---------------- Game accounts ----------------
  Widget _gameList() {
    final all = ref.watch(allGameAccountsProvider).value ?? <GameAccount>[];
    final allGames = {for (final g in ref.watch(allGamesProvider).value ?? <Game>[]) g.id: g};
    final cur = ref.watch(currencyProvider);

    final list = all.where((a) {
      if (_game != null && a.gameId != _game!.id) return false;
      if (_aStatus != null && a.status != _aStatus) return false;
      if (_query.isNotEmpty &&
          !a.name.toLowerCase().contains(_query) &&
          !a.idCompte.toLowerCase().contains(_query)) {
        return false;
      }
      return true;
    }).toList();

    list.sort((a, b) => switch (_aSort) {
          _ASort.newest => b.createdAt.compareTo(a.createdAt),
          _ASort.oldest => a.createdAt.compareTo(b.createdAt),
          _ASort.saleHigh => b.salePrice.compareTo(a.salePrice),
          _ASort.saleLow => a.salePrice.compareTo(b.salePrice),
          _ASort.buyHigh => b.purchasePrice.compareTo(a.purchasePrice),
          _ASort.nameAz => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        });

    return Column(children: [
      _counter(list.length, all.length, _aSort.label),
      Expanded(
        child: list.isEmpty
            ? Center(child: Text('No account matches', style: TextStyle(color: SpheraColors.muted)))
            : ListView.builder(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final a = list[i];
                  final game = allGames[a.gameId];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      isThreeLine: true,
                      leading: Icon(Icons.sports_esports_outlined, color: SpheraColors.gold, size: 30),
                      title: Text(a.name.isEmpty ? a.idCompte : a.name, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        '${game?.name ?? 'Unknown game'} · ID ${a.idCompte}\n'
                        '${a.status.name.toUpperCase()} · buy ${money(a.purchasePrice, currency: cur)} → '
                        'sell ${money(a.salePrice, currency: cur)} · ${fmtDate(a.createdAt)}',
                        style: TextStyle(color: SpheraColors.muted, fontSize: 12),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: game == null
                          ? null
                          : () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => GameAccountsScreen(game: game))),
                    ),
                  );
                },
              ),
      ),
    ]);
  }
}
