import 'package:flutter/material.dart';

/// One complete colour set. Several styles, each in a dark and a light version.
class SpheraPalette {
  const SpheraPalette({
    required this.style,
    required this.dark,
    required this.black,
    required this.surface,
    required this.surfaceHigh,
    required this.border,
    required this.gold,
    required this.goldSoft,
    required this.ivory,
    required this.muted,
  });
  final String style;
  final bool dark;
  final Color black; // page background
  final Color surface; // cards
  final Color surfaceHigh; // inputs, raised areas
  final Color border;
  final Color gold; // main accent
  final Color goldSoft; // secondary accent
  final Color ivory; // main text
  final Color muted; // secondary text
}

/// Style id -> display name. (No green theme: green is reserved for DONE / positive.)
const kThemeStyles = {
  'gold': 'Gold',
  'silver': 'Silver',
  'rose': 'Rose Gold',
  'midnight': 'Midnight',
};

const kPalettes = <SpheraPalette>[
  // --- Gold ---
  SpheraPalette(style: 'gold', dark: true, black: Color(0xFF0B0B0C), surface: Color(0xFF141416),
      surfaceHigh: Color(0xFF1C1C1F), border: Color(0xFF2A2A2E), gold: Color(0xFFD4AF37),
      goldSoft: Color(0xFFB8975A), ivory: Color(0xFFF5F1E6), muted: Color(0xFF8E8E93)),
  SpheraPalette(style: 'gold', dark: false, black: Color(0xFFF7F3EA), surface: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFF0EBDD), border: Color(0xFFDDD5C2), gold: Color(0xFFB8860B),
      goldSoft: Color(0xFF9A7B4F), ivory: Color(0xFF1B1B1D), muted: Color(0xFF6B6B70)),
  // --- Silver ---
  SpheraPalette(style: 'silver', dark: true, black: Color(0xFF0B0B0C), surface: Color(0xFF141416),
      surfaceHigh: Color(0xFF1C1C1F), border: Color(0xFF2A2A2E), gold: Color(0xFFC8CCD4),
      goldSoft: Color(0xFF9BA1AD), ivory: Color(0xFFF2F3F5), muted: Color(0xFF8E9099)),
  SpheraPalette(style: 'silver', dark: false, black: Color(0xFFF4F5F7), surface: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFECEEF2), border: Color(0xFFD5D8DE), gold: Color(0xFF4A5468),
      goldSoft: Color(0xFF7A8394), ivory: Color(0xFF17181B), muted: Color(0xFF6A6F7A)),
  // --- Rose Gold ---
  SpheraPalette(style: 'rose', dark: true, black: Color(0xFF0D0A0B), surface: Color(0xFF171214),
      surfaceHigh: Color(0xFF201A1C), border: Color(0xFF33282B), gold: Color(0xFFE0A899),
      goldSoft: Color(0xFFB5776E), ivory: Color(0xFFF7EEEA), muted: Color(0xFF9A8F8C)),
  SpheraPalette(style: 'rose', dark: false, black: Color(0xFFFBF4F1), surface: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFF4E8E3), border: Color(0xFFE6D5CF), gold: Color(0xFFB76E5C),
      goldSoft: Color(0xFF9A5E50), ivory: Color(0xFF2A1D1B), muted: Color(0xFF7A6B67)),
  // --- Midnight ---
  SpheraPalette(style: 'midnight', dark: true, black: Color(0xFF0A0F1F), surface: Color(0xFF121A30),
      surfaceHigh: Color(0xFF1A2440), border: Color(0xFF2A3658), gold: Color(0xFFD4AF37),
      goldSoft: Color(0xFFB8975A), ivory: Color(0xFFF2F4FA), muted: Color(0xFF8D96AE)),
  SpheraPalette(style: 'midnight', dark: false, black: Color(0xFFEEF2FA), surface: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFE3E9F5), border: Color(0xFFCBD5E8), gold: Color(0xFF2A4A9B),
      goldSoft: Color(0xFF5B7BC0), ivory: Color(0xFF101830), muted: Color(0xFF5E6A86)),
];

SpheraPalette paletteFor(String style, {required bool dark}) => kPalettes.firstWhere(
    (p) => p.style == style && p.dark == dark,
    orElse: () => kPalettes.first);

/// Colours used across the app. The themed ones follow the active palette
/// (changed from Tools & Settings); the status colours never change.
class SpheraColors {
  static SpheraPalette _p = kPalettes.first;
  static SpheraPalette get palette => _p;
  static void apply(SpheraPalette p) => _p = p;

  static Color get black => _p.black;
  static Color get surface => _p.surface;
  static Color get surfaceHigh => _p.surfaceHigh;
  static Color get border => _p.border;
  static Color get gold => _p.gold;
  static Color get goldSoft => _p.goldSoft;
  static Color get ivory => _p.ivory;
  static Color get muted => _p.muted;

  // Fixed status colours.
  static const bronze = Color(0xFF8C6A3F);
  static const done = Color(0xFF3FA66B); // positive / completed only
  static const danger = Color(0xFFD0453F);
  static const coming = Color(0xFFE2B93B);
  static const empty = Color(0xFF55555A);
}

ThemeData buildSpheraTheme({required String style, required bool dark}) {
  final p = paletteFor(style, dark: dark);
  final base = p.dark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true);
  final onAccent =
      ThemeData.estimateBrightnessForColor(p.gold) == Brightness.dark ? Colors.white : Colors.black;
  return base.copyWith(
    scaffoldBackgroundColor: p.black,
    colorScheme: ColorScheme(
      brightness: p.dark ? Brightness.dark : Brightness.light,
      primary: p.gold,
      onPrimary: onAccent,
      secondary: p.goldSoft,
      onSecondary: onAccent,
      error: SpheraColors.danger,
      onError: Colors.white,
      surface: p.surface,
      onSurface: p.ivory,
    ),
    textTheme: base.textTheme.apply(bodyColor: p.ivory, displayColor: p.ivory),
    appBarTheme: AppBarTheme(
      backgroundColor: p.black,
      foregroundColor: p.ivory,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: p.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: p.border),
      ),
    ),
    dialogTheme: DialogThemeData(backgroundColor: p.surface),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: p.surface),
    dividerColor: p.border,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.gold,
        foregroundColor: onAccent,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.surfaceHigh,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: p.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: p.gold),
      ),
    ),
  );
}
