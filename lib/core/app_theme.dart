import 'package:flutter/material.dart';

class ThemePreset {
  const ThemePreset({
    required this.id,
    required this.name,
    required this.seed,
    required this.background,
    required this.brightness,
  });

  final String id;
  final String name;
  final Color seed;
  final Color background;
  final Brightness brightness;
}

abstract final class AppThemes {
  static const presets = [
    ThemePreset(
      id: 'midnight',
      name: 'Midnight',
      seed: Color(0xFF7C72FF),
      background: Color(0xFF0D1224),
      brightness: Brightness.dark,
    ),
    ThemePreset(
      id: 'royal',
      name: 'Royal',
      seed: Color(0xFF6547D9),
      background: Color(0xFFF7F5FF),
      brightness: Brightness.light,
    ),
    ThemePreset(
      id: 'emerald',
      name: 'Emerald',
      seed: Color(0xFF008F79),
      background: Color(0xFFF3FBF8),
      brightness: Brightness.light,
    ),
    ThemePreset(
      id: 'ocean',
      name: 'Ocean',
      seed: Color(0xFF087EA4),
      background: Color(0xFFF1FAFD),
      brightness: Brightness.light,
    ),
    ThemePreset(
      id: 'sunset',
      name: 'Sunset',
      seed: Color(0xFFE76F51),
      background: Color(0xFFFFF8F3),
      brightness: Brightness.light,
    ),
    ThemePreset(
      id: 'rose',
      name: 'Rose',
      seed: Color(0xFFD94F70),
      background: Color(0xFFFFF5F8),
      brightness: Brightness.light,
    ),
    ThemePreset(
      id: 'snow',
      name: 'Snow',
      seed: Color(0xFF3B5CCC),
      background: Color(0xFFF8FAFF),
      brightness: Brightness.light,
    ),
    ThemePreset(
      id: 'cocoa',
      name: 'Cocoa',
      seed: Color(0xFFD19A66),
      background: Color(0xFF1C1715),
      brightness: Brightness.dark,
    ),
  ];

  static ThemePreset preset(String id) => presets.firstWhere(
    (item) => item.id == id,
    orElse: () => presets.firstWhere((item) => item.id == 'snow'),
  );

  static ThemeData build(String id) {
    final preset = AppThemes.preset(id);
    final scheme = ColorScheme.fromSeed(
      seedColor: preset.seed,
      brightness: preset.brightness,
      surface: preset.background,
    );
    final dark = preset.brightness == Brightness.dark;
    final borderColor = dark
        ? Colors.white.withValues(alpha: 0.10)
        : const Color(0xFFE5E8F2);

    return ThemeData(
      useMaterial3: true,
      brightness: preset.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: preset.background,
      fontFamily: 'sans-serif',
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: 21,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: dark ? const Color(0xFF171D33) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: borderColor),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 74,
        elevation: 0,
        backgroundColor: dark ? const Color(0xFF12182B) : Colors.white,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark
            ? Colors.white.withValues(alpha: 0.06)
            : const Color(0xFFF3F5FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: borderColor),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      dividerTheme: DividerThemeData(color: borderColor),
    );
  }
}
