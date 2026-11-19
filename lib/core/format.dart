import '../data/settings.dart';

/// Number without useless decimals: 200 -> "200", 21.4 -> "21.40".
String amountText(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

/// Amounts are stored in DH (MAD). They are converted to the chosen currency
/// for display only (see CurrencySettings).
String money(double storedDh, {CurrencySettings? currency}) {
  final shown = currency == null ? storedDh : currency.toDisplay(storedDh);
  return '${amountText(shown)} ${currency?.code ?? 'DH'}';
}

/// Signed amount, e.g. "+50 DH" or "-30 USD".
String signedMoney(double storedDh, {CurrencySettings? currency}) {
  final shown = currency == null ? storedDh : currency.toDisplay(storedDh);
  return '${shown > 0 ? '+' : ''}${money(storedDh, currency: currency)}';
}
