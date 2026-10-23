import 'package:flutter/material.dart';

/// Button with built-in loading state and an optional leading icon.
///
/// Colors come from the theme (see `AppStyle`). Only pass
/// [backgroundColor] / [foregroundColor] for one-off exceptions.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  static const double _spinnerSize = 20;
  static const double _spinnerStrokeWidth = 2.5;
  static const double _iconGap = 8;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spinnerColor =
        foregroundColor ?? (isOutlined ? scheme.primary : scheme.onPrimary);

    final Widget label = icon == null
        ? Text(text)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: _iconGap),
              Text(text),
            ],
          );

    final Widget child = isLoading
        ? SizedBox.square(
            dimension: _spinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: _spinnerStrokeWidth,
              color: spinnerColor,
            ),
          )
        : label;

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isLoading ? spinnerColor : foregroundColor,
        ),
        child: child,
      );
    }

    // While loading the button is disabled, but keeps its enabled colors.
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isLoading
            ? (backgroundColor ?? scheme.primary)
            : backgroundColor,
        foregroundColor: isLoading ? spinnerColor : foregroundColor,
      ),
      child: child,
    );
  }
}
