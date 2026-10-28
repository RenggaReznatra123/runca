import 'package:flutter/material.dart';
import 'package:runca/ui/custom_icons.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';

class SignUpPasswordField extends StatelessWidget {
  const SignUpPasswordField({
    required this.label,
    required this.hint,
    required this.obscure,
    required this.validator,
    required this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    super.key,
  });

  final String label;
  final String hint;
  final ValueNotifier<bool> obscure;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  static const double _iconSize = 18;
  static const double _suffixTapSize = 40;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscure,
      builder: (context, isObscured, _) {
        return CustomTextFormField(
          label: label,
          hint: hint,
          isRequired: true,
          obscureText: isObscured,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: textInputAction,
          prefixIcon: const Icon(CustomIcons.password),
          suffixIcon: IconButton(
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(
              minWidth: _suffixTapSize,
              minHeight: _suffixTapSize,
            ),
            padding: EdgeInsets.zero,
            icon: Icon(
              isObscured ? CustomIcons.visibilityOff : CustomIcons.visibility,
              size: _iconSize,
            ),
            onPressed: () => obscure.value = !isObscured,
          ),
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
        );
      },
    );
  }
}
