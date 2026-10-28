import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({required this.headingGap, super.key});

  static const String _title = 'Create Your Account';
  static const String _subtitle =
      'Sign up to start tracking your runs and building healthy habits.';
  static const double _titleFontSize = 20;
  static const double _subtitleFontSize = 12;

  final double headingGap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _title,
          style: textTheme.headlineSmall?.copyWith(
            fontSize: _titleFontSize,
            height: 1.2,
            fontWeight: AppTypography.medium,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
        SizedBox(height: headingGap),
        Text(
          _subtitle,
          style: textTheme.bodySmall?.copyWith(
            fontSize: _subtitleFontSize,
            height: 1.4,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
      ],
    );
  }
}
