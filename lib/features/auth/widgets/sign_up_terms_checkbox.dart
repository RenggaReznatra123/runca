import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/utility/snackbar_extension.dart';

class SignUpTermsCheckbox extends StatefulWidget {
  const SignUpTermsCheckbox({required this.accepted, super.key});

  final ValueNotifier<bool> accepted;

  @override
  State<SignUpTermsCheckbox> createState() => _SignUpTermsCheckboxState();
}

class _SignUpTermsCheckboxState extends State<SignUpTermsCheckbox> {
  static const String _prefix = 'I agree to the ';
  static const String _termsLabel = 'Terms & Conditions';
  static const String _joiner = ' and ';
  static const String _privacyLabel = 'Privacy Policy';
  static const String _suffix = '.';

  late final TapGestureRecognizer _termsTap = TapGestureRecognizer()
    ..onTap = _openTerms;

  late final TapGestureRecognizer _privacyTap = TapGestureRecognizer()
    ..onTap = _openPrivacy;

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  void _openTerms() {
    context.showUnavailableSnackbar(_termsLabel);
  }

  void _openPrivacy() {
    context.showUnavailableSnackbar(_privacyLabel);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 12,
      color: AppPalette.textNeutralPrimary,
    );
    final linkStyle = baseStyle?.copyWith(color: theme.colorScheme.primary);

    return ValueListenableBuilder<bool>(
      valueListenable: widget.accepted,
      builder: (context, isAccepted, _) {
        return Row(
          children: [
            Checkbox(
              value: isAccepted,
              onChanged: (value) => widget.accepted.value = value ?? false,
            ),
            const SizedBox(width: AppDimens.s8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: baseStyle,
                  children: [
                    const TextSpan(text: _prefix),
                    TextSpan(
                      text: _termsLabel,
                      style: linkStyle,
                      recognizer: _termsTap,
                    ),
                    const TextSpan(text: _joiner),
                    TextSpan(
                      text: _privacyLabel,
                      style: linkStyle,
                      recognizer: _privacyTap,
                    ),
                    const TextSpan(text: _suffix),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
