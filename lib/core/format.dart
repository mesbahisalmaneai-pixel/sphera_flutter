import '../data/settings.dart';

/// Number without useless decimals: 200 -> "200", 21.4 -> "21.40".
String amountText(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

/// True while the app language reads right to left (Arabic). Set by the app
/// (see SpheraApp in main.dart). Amounts are then wrapped in invisible
/// left-to-right marks so "+770 DH" never shows as "DH 770+".
bool amountsInRtl = false;

const _lri = '\u{2066}'; // left-to-right isolate
const _pdi = '\u{2069}'; // pop directional isolate

String _isolate(String s) => amountsInRtl ? '$_lri$s$_pdi' : s;

String _plainMoney(double shown, CurrencySettings? currency) => '${amountText(shown)} ${currency?.code ?? 'DH'}';

/// Amounts are stored in DH (MAD). They are converted to the chosen currency
/// for display only (see CurrencySettings).
String money(double storedDh, {CurrencySettings? currency}) {
  final shown = currency == null ? storedDh : currency.toDisplay(storedDh);
  return _isolate(_plainMoney(shown, currency));
}

/// Signed amount, e.g. "+50 DH" or "-30 USD".
String signedMoney(double storedDh, {CurrencySettings? currency}) {
  final shown = currency == null ? storedDh : currency.toDisplay(storedDh);
  return _isolate('${shown > 0 ? '+' : ''}${_plainMoney(shown, currency)}');
}
