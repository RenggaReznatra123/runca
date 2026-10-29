import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/custom_icons.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';
import 'package:runca/ui/typography.dart';

/// Kolom password dengan label (dan tautan opsional di kanan label) serta
/// ikon mata untuk menampilkan atau menyembunyikan isi.
class ChangePasswordField extends StatefulWidget {
  const ChangePasswordField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.onChanged,
    this.helperText,
    this.trailing,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String? helperText;

  /// Widget di kanan label, contoh: tautan "Forgot Password?".
  final Widget? trailing;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<ChangePasswordField> createState() => _ChangePasswordFieldState();
}

class _ChangePasswordFieldState extends State<ChangePasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final trailing = widget.trailing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: AppTypography.bodyMedium(
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 8),
        CustomTextFormField(
          hint: widget.hint,
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          helperText: widget.helperText,
          suffixIcon: IconButton(
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            padding: EdgeInsets.zero,
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
              _obscure ? CustomIcons.visibilityOff : CustomIcons.visibility,
              size: 18,
              color: AppPalette.profileMutedIcon,
            ),
          ),
        ),
      ],
    );
  }
}