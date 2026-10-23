import 'package:flutter/material.dart';

/// Font family registered in `pubspec.yaml` (`assets/fonts/`).
class AppFonts {
  const AppFonts._();

  static const String sfProDisplay = 'SF Pro Display';
}

/// Type scale used by [AppTheme]. All styles default to SF Pro Display.
class AppTypography {
  const AppTypography._();

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static TextStyle displayLarge({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 32,
    fontWeight: bold,
    height: 1.2,
    color: color,
  );

  static TextStyle displayMedium({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 28,
    fontWeight: bold,
    height: 1.25,
    color: color,
  );
  static TextStyle headlineSmall({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.25,
    color: color,
  );
  static TextStyle titleLarge({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 22,
    fontWeight: semiBold,
    height: 1.3,
    color: color,
  );

  static TextStyle titleMedium({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 18,
    fontWeight: semiBold,
    height: 1.35,
    color: color,
  );

  static TextStyle titleSmall({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 16,
    fontWeight: medium,
    height: 1.4,
    color: color,
  );

  static TextStyle bodyLarge({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 16,
    fontWeight: regular,
    height: 1.5,
    color: color,
  );

  static TextStyle bodyMedium({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
    color: color,
  );

  static TextStyle bodySmall({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 12,
    fontWeight: regular,
    height: 1.5,
    color: color,
  );

  static TextStyle labelLarge({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.4,
    color: color,
  );

  static TextStyle labelSmall({Color? color}) => TextStyle(
    fontFamily: AppFonts.sfProDisplay,
    fontSize: 11,
    fontWeight: medium,
    height: 1.4,
    color: color,
  );

  /// Full [TextTheme] wired into [ThemeData.textTheme].
  static TextTheme textTheme(Color textColor, Color secondaryColor) =>
      TextTheme(
        displayLarge: displayLarge(color: textColor),
        displayMedium: displayMedium(color: textColor),
        headlineSmall: headlineSmall(color: textColor),
        titleLarge: titleLarge(color: textColor),
        titleMedium: titleMedium(color: textColor),
        titleSmall: titleSmall(color: textColor),
        bodyLarge: bodyLarge(color: textColor),
        bodyMedium: bodyMedium(color: textColor),
        bodySmall: bodySmall(color: secondaryColor),
        labelLarge: labelLarge(color: textColor),
        labelSmall: labelSmall(color: secondaryColor),
      );
}
