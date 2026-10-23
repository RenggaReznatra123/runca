import 'package:flutter/material.dart';

import 'color.dart';
import 'style.dart';
import 'typography.dart';

/// App theme (Material 3, SF Pro Display).
class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: AppPalette.bgFillPrimary,
      onPrimary: AppPalette.baseWhite,
      secondary: AppPalette.bgFillSecondary,
      surface: AppPalette.bg,
      onSurface: AppPalette.textNeutralPrimary,
      error: AppPalette.textDanger,
      outline: AppPalette.borderNeutral,
      outlineVariant: AppPalette.borderNeutral,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.sfProDisplay,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppPalette.bgPrimary,
      textTheme: AppTypography.textTheme(
        AppPalette.textNeutralPrimary,
        AppPalette.textNeutralSecondary,
      ),
      elevatedButtonTheme: AppStyle.elevatedButtonTheme(scheme),
      outlinedButtonTheme: AppStyle.outlinedButtonTheme(scheme),
      textButtonTheme: AppStyle.textButtonTheme(scheme),
      inputDecorationTheme: AppStyle.inputDecorationTheme(scheme),
      appBarTheme: AppStyle.appBarTheme(scheme, AppPalette.textNeutralPrimary),
      cardTheme: AppStyle.cardTheme(scheme),
      checkboxTheme: AppStyle.checkboxTheme(scheme),
      snackBarTheme: AppStyle.snackBarTheme(),
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppPalette.bgFillPrimary,
      onPrimary: AppPalette.baseWhite,
      secondary: AppPalette.bgFillSecondary,
      surface: AppPalette.bgBlack,
      onSurface: AppPalette.textWhitePrimary,
      error: AppPalette.textDanger,
      outline: AppPalette.borderFillNeutral,
      outlineVariant: AppPalette.borderFillNeutral,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.sfProDisplay,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppPalette.bgBlack,
      textTheme: AppTypography.textTheme(
        AppPalette.textWhitePrimary,
        AppPalette.textWhiteSecondary,
      ),
      elevatedButtonTheme: AppStyle.elevatedButtonTheme(scheme),
      outlinedButtonTheme: AppStyle.outlinedButtonTheme(scheme),
      textButtonTheme: AppStyle.textButtonTheme(scheme),
      inputDecorationTheme: AppStyle.inputDecorationTheme(scheme),
      appBarTheme: AppStyle.appBarTheme(scheme, AppPalette.textWhitePrimary),
      cardTheme: AppStyle.cardTheme(scheme),
      checkboxTheme: AppStyle.checkboxTheme(scheme),
      snackBarTheme: AppStyle.snackBarTheme(),
    );
  }
}
