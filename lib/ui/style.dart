import 'package:flutter/material.dart';

import 'color.dart';
import 'dimension.dart';
import 'typography.dart';

/// Component themes shared by [AppTheme.light] / [AppTheme.dark].
class AppStyle {
  const AppStyle._();

  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme scheme) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppPalette.bgDisabled;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppPalette.bgButtonPrimaryPressed;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppPalette.bgButtonPrimaryHover;
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppPalette.textDisabled;
            }
            return scheme.onPrimary;
          }),
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppDimens.buttonHeight),
          ),
          textStyle: WidgetStatePropertyAll(AppTypography.labelLarge()),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
          ),
        ),
      );

  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme scheme) =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppPalette.bgButtonOutlinedPressed;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppPalette.bgButtonOutlinedHover;
            }
            return AppPalette.bgButtonOutlinedDefault;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppPalette.textDisabled;
            }
            return AppPalette.textButtonOutlined;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return const BorderSide(
                color: AppPalette.borderButtonOutlinedFocused,
              );
            }
            if (states.contains(WidgetState.pressed)) {
              return const BorderSide(
                color: AppPalette.borderButtonOutlinedPressed,
              );
            }
            return const BorderSide(
              color: AppPalette.borderButtonOutlinedDefault,
            );
          }),
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppDimens.buttonHeight),
          ),
          textStyle: WidgetStatePropertyAll(AppTypography.labelLarge()),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
          ),
        ),
      );

  static TextButtonThemeData textButtonTheme(ColorScheme scheme) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          disabledForegroundColor: AppPalette.textDisabled,
          textStyle: AppTypography.labelLarge(),
        ),
      );

  static InputDecorationTheme inputDecorationTheme(ColorScheme scheme) {
    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.s16,
        vertical: AppDimens.s12,
      ),
      hintStyle: AppTypography.bodyMedium(
        color: AppPalette.textNeutralSecondary,
      ),
      prefixIconColor: scheme.onSurface,
      suffixIconColor: scheme.onSurface,
      border: border(scheme.outline),
      enabledBorder: border(scheme.outline),
      disabledBorder: border(AppPalette.borderDisabled),
      focusedBorder: border(scheme.primary, width: 1.5),
      errorBorder: border(scheme.error),
      focusedErrorBorder: border(scheme.error, width: 1.5),
      errorStyle: AppTypography.bodySmall(color: scheme.error),
    );
  }

  static CheckboxThemeData checkboxTheme(ColorScheme scheme) =>
      CheckboxThemeData(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.small / 2),
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return null;
        }),
        side: WidgetStateBorderSide.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BorderSide(color: scheme.primary, width: 1.5);
          }
          return const BorderSide(color: AppPalette.borderDisabled, width: 1.5);
        }),
      );

  static AppBarTheme appBarTheme(ColorScheme scheme, Color textColor) =>
      AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleMedium(color: textColor),
      );

  static CardThemeData cardTheme(ColorScheme scheme) => CardThemeData(
    color: scheme.surface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
      side: BorderSide(color: scheme.outlineVariant),
    ),
  );

  static SnackBarThemeData snackBarTheme() => SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
    ),
  );
}
