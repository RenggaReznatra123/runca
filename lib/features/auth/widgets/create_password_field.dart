import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

class CreatePasswordField extends StatelessWidget {
  const CreatePasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.validator,
    required this.onChanged,
    required this.onToggle,
    this.textInputAction,
    this.onFieldSubmitted,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggle;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  InputDecoration _decoration() {
    return InputDecoration(
      hintText: 'Enter your password',
      hintStyle: const TextStyle(
        color: AppPalette.textNeutralSecondary,
        fontSize: 14,
      ),
      prefixIcon: const Icon(
        Icons.lock_outline,
        size: 20,
        color: AppPalette.textNeutralPrimary,
      ),
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
          color: AppPalette.textNeutralPrimary,
        ),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.borderFormDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppPalette.bgButtonPrimaryDefault,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.textDanger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.textDanger, width: 1.5),
      ),
    );
  }

  Widget _requiredLabel() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label),
          const TextSpan(
            text: ' *',
            style: TextStyle(color: AppPalette.textDanger),
          ),
        ],
      ),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppPalette.textNeutralPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _requiredLabel(),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          textInputAction: textInputAction,
          onChanged: onChanged,
          decoration: _decoration(),
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
        ),
      ],
    );
  }
}
