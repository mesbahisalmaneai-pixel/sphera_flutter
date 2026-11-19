import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import 'game_accounts_screen.dart';

/// Add (account == null) or edit a gaming account.
class GameAccountForm extends ConsumerStatefulWidget {
  const GameAccountForm({super.key, this.game, this.account});
  final Game? game; // preselected game
  final GameAccount? account;

  @override
  ConsumerState<GameAccountForm> createState() => _GameAccountFormState();
}

class _GameAccountFormState extends ConsumerState<GameAccountForm> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _idCompte, _name, _purchase, _sale, _notes;
  late String? _gameId;
  late GameAccountStatus _status;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.account != null;

  /// Stored amounts are in DH; the form shows and accepts the chosen currency.
  String _num(double? storedDh) =>
      storedDh == null ? '' : amountText(ref.read(currencyProvider).toDisplay(storedDh));
  late String _initPurchase, _initSale;

  @override
  void initState() {
    super.initState();
    final a = widget.account;
    _idCompte = TextEditingController(text: a?.idCompte ?? '');
    _name = TextEditingController(text: a?.name ?? '');
    _initPurchase = _num(a?.purchasePrice);
    _initSale = _num(a?.salePrice);
    _purchase = TextEditingController(text: _initPurchase);
    _sale = TextEditingController(text: _initSale);
    _notes = TextEditingController(text: a?.notes ?? '');
    _gameId = a?.gameId ?? widget.game?.id;
    _status = a?.status ?? GameAccountStatus.active;
  }

  @override
  void dispose() {
    for (final c in [_idCompte, _name, _purchase, _sale, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

  String? _priceValidator(String? v) {
    final n = _parse(v ?? '');
    if (n == null) return context.l10n.enterNumber;
    if (n < 0) return context.l10n.mustBeZeroOrMore;
    return null;
  }

  Future<void> _save() async {
    if (_saving || !_key.currentState!.validate()) return;
    if (_gameId == null) {
      setState(() => _error = context.l10n.chooseGame);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final repo = ref.read(gameAccountRepoProvider);
    final cur = ref.read(currencyProvider);
    // Typed amounts are in the chosen currency; store them in DH (rounded to 2 decimals).
    double toDh(String text) => double.parse(cur.toBase(_parse(text)!).toStringAsFixed(2));
    try {
      if (_isEdit) {
        // Prices that were not touched keep their exact stored value (no rounding drift).
        await repo.update(widget.account!.id,
            gameId: _gameId, idCompte: _idCompte.text, name: _name.text,
            purchasePrice: _purchase.text.trim() == _initPurchase ? null : toDh(_purchase.text),
            salePrice: _sale.text.trim() == _initSale ? null : toDh(_sale.text),
            status: _status, notes: _notes.text);
      } else {
        await repo.create(
            gameId: _gameId!, idCompte: _idCompte.text, name: _name.text,
            purchasePrice: toDh(_purchase.text), salePrice: toDh(_sale.text),
            status: _status, notes: _notes.text);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = context.l10n.couldNotSave('$e'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(activeGamesProvider).value ?? <Game>[];
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? context.l10n.editAccount : context.l10n.addAccountShort)),
      body: Form(
        key: _key,
        child: ListView(padding: EdgeInsets.all(20), children: [
          DropdownButtonFormField<String>(
            initialValue: games.any((g) => g.id == _gameId) ? _gameId : null,
            decoration: InputDecoration(labelText: context.l10n.game),
            items: [for (final g in games) DropdownMenuItem(value: g.id, child: Text(g.name))],
            onChanged: (v) => setState(() => _gameId = v),
          ),
          SizedBox(height: 14),
          TextFormField(
            controller: _idCompte,
            decoration: InputDecoration(labelText: context.l10n.idCompte),
            validator: (v) => (v ?? '').trim().isEmpty ? context.l10n.idCompteRequired : null,
          ),
          SizedBox(height: 14),
          TextFormField(
            controller: _name,
            decoration: InputDecoration(labelText: context.l10n.accountName),
            validator: (v) => (v ?? '').trim().isEmpty ? context.l10n.nameRequired : null,
          ),
          SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: TextFormField(
                controller: _purchase,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: context.l10n.purchasePrice, suffixText: ref.watch(currencyProvider).code),
                validator: _priceValidator,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _sale,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: context.l10n.salePrice, suffixText: ref.watch(currencyProvider).code),
                validator: _priceValidator,
              ),
            ),
          ]),
          SizedBox(height: 18),
          Text(context.l10n.status, style: TextStyle(color: SpheraColors.muted)),
          SizedBox(height: 8),
          Wrap(spacing: 10, children: [
            for (final s in GameAccountStatus.values)
              ChoiceChip(
                label: Text(statusLabel(s)),
                selected: _status == s,
                selectedColor: statusColor(s).withValues(alpha: 0.3),
                side: BorderSide(color: statusColor(s)),
                onSelected: (_) => setState(() => _status = s),
              ),
          ]),
          SizedBox(height: 14),
          TextFormField(
            controller: _notes,
            maxLines: 3,
            decoration: InputDecoration(labelText: context.l10n.notesOptional),
          ),
          if (_error != null)
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(_error!, style: TextStyle(color: SpheraColors.danger)),
            ),
          SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : Text(_isEdit ? context.l10n.saveChanges : context.l10n.addAccountShort),
          ),
        ]),
      ),
    );
  }
}
