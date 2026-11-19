import 'package:flutter_test/flutter_test.dart';
import 'package:sphera_flutter/core/format.dart';
import 'package:sphera_flutter/core/theme.dart';
import 'package:sphera_flutter/data/settings.dart';

void main() {
  const usd = CurrencySettings(code: 'USD', rates: {'USD': 0.1, 'EUR': 0.09}, source: 'live');
  const eur = CurrencySettings(code: 'EUR', rates: {'USD': 0.1, 'EUR': 0.09}, source: 'live');
  const dh = CurrencySettings(code: 'DH', rates: {'USD': 0.1, 'EUR': 0.09}, source: 'live');

  test('DH stays unchanged, USD and EUR are converted with their own rates', () {
    expect(dh.toDisplay(200), 200);
    expect(usd.toDisplay(200), closeTo(20, 1e-9));
    expect(eur.toDisplay(200), closeTo(18, 1e-9));
  });

  test('typed amounts convert back to DH', () {
    expect(usd.toBase(20), closeTo(200, 1e-9));
    expect(eur.toBase(18), closeTo(200, 1e-9));
    expect(dh.toBase(150), 150);
  });

  test('money() formats converted amount with the currency code', () {
    expect(money(200), '200 DH');
    expect(money(200, currency: usd), '20 USD');
    expect(money(185, currency: usd), '18.50 USD');
    expect(signedMoney(50, currency: eur), '+4.50 EUR');
    expect(signedMoney(-30, currency: usd), '-3 USD');
  });

  test('every style has a dark and a light palette', () {
    for (final style in kThemeStyles.keys) {
      expect(kPalettes.where((p) => p.style == style && p.dark).length, 1);
      expect(kPalettes.where((p) => p.style == style && !p.dark).length, 1);
    }
    expect(paletteFor('rose', dark: false).dark, isFalse);
  });
}
