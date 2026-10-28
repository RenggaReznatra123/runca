import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

class LoginFormHeader extends StatelessWidget {
  const LoginFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome Back!',
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(
            fontSize: 20,
            height: 1.2,
            fontWeight: FontWeight.w500,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Sign in to continue tracking your runs and challenge progress.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            fontSize: 12,
            height: 1.4,
            fontWeight: FontWeight.w400,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
      ],
    );
  }
}
