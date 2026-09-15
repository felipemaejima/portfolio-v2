import 'package:flutter/material.dart';

/// Tokens do layout de referência (APP.md §6). Só tema escuro na v2.
abstract final class AppColors {
  static const bg = Color(0xFF161826);
  static const surface = Color(0xFF232532);
  static const surface2 = Color(0xFF2B2D3D);
  static const text = Color(0xFFE9E9ED);
  static const neutral300 = Color(0xFFCFD3E5);
  static const neutral400 = Color(0xFFB2B6CA);
  static const neutral500 = Color(0xFF9397AB);
  static const neutral600 = Color(0xFF75798C);
  static const neutral800 = Color(0xFF3F424D);
  static const accent = Color(0xFF9184D9);
  static const accent100 = Color(0xFFF5F4FF);
  static const accent300 = Color(0xFFD2CEFD);
  static const accent800 = Color(0xFF423A6A);
  static const divider = Color(0x29E9E9ED);
}

ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    primary: AppColors.accent,
    onPrimary: AppColors.bg,
    secondary: AppColors.accent300,
    surface: AppColors.surface,
    onSurface: AppColors.text,
    error: Color(0xFFFF8A80),
    outline: AppColors.divider,
  );
  // Inter variável, embutida (APP.md §6): sem google_fonts em runtime.
  final base = ThemeData(useMaterial3: true, colorScheme: scheme, brightness: Brightness.dark, fontFamily: 'Inter');
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    dividerColor: AppColors.divider,
    textTheme: base.textTheme.apply(bodyColor: AppColors.text, displayColor: AppColors.text),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        side: const BorderSide(color: AppColors.accent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: const CardThemeData(color: AppColors.surface, elevation: 0),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.bg, foregroundColor: AppColors.text, elevation: 0),
  );
}
