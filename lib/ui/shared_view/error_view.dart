import 'package:flutter/material.dart';

import '../custom_icons.dart';
import '../dimension.dart';

/// Full-screen error state with retry action.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CustomIcons.error, size: 48),
            const SizedBox(height: AppDimens.s12),
            Text(
              message,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimens.s16),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
