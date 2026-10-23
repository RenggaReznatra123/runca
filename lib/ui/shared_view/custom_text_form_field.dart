import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

/// Labeled text field used across forms.
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.textInputAction,
    this.onFieldSubmitted,
    this.isRequired = false,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final bool enabled;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isRequired;

  static const double _labelFontSize = 14;
  static const double _hintFontSize = 14;
  static const double _labelFieldGap = 8;
  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 14;
  static const double _iconSize = 18;
  static const double _borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text.rich(
            TextSpan(
              text: label,
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppPalette.textDanger,
                    ),
                  ),
              ],
            ),
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: _labelFontSize,
              fontWeight: FontWeight.w400,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
          const SizedBox(height: _labelFieldGap),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: obscureText ? 1 : maxLines,
          enabled: enabled,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: _hintFontSize,
            color: AppPalette.textNeutralPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              fontSize: _hintFontSize,
              fontWeight: FontWeight.w400,
              color: AppPalette.textNeutralSecondary,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : IconTheme(
                    data: const IconThemeData(size: _iconSize),
                    child: prefixIcon!,
                  ),
            suffixIcon: suffixIcon == null
                ? null
                : IconTheme(
                    data: const IconThemeData(size: _iconSize),
                    child: suffixIcon!,
                  ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: _verticalPadding,
            ),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: const BorderSide(
                color: AppPalette.borderNeutral,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: const BorderSide(
                color: AppPalette.textDanger,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: const BorderSide(
                color: AppPalette.textDanger,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
