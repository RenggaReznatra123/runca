import 'package:flutter/material.dart';

import '../custom_icons.dart';
import '../dimension.dart';

/// Full-screen empty state.
class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.message = 'No data available.'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CustomIcons.empty, size: 48),
            const SizedBox(height: AppDimens.s12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
