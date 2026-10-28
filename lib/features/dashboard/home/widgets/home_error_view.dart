import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/activity/widgets/activity_state_view.dart';
import 'package:runca/ui/color.dart';

/// Tampilan Home gagal dimuat.
class HomeErrorView extends StatelessWidget {
  const HomeErrorView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ActivityStateView(
      leading: const DecoratedBox(
        decoration: BoxDecoration(
          color: AppPalette.bgSurfacePrimary,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: 104,
          height: 104,
          child: Icon(
            Icons.cloud_off_outlined,
            size: 44,
            color: AppPalette.bgFillPrimary,
          ),
        ),
      ),
      title: 'Unable to load home',
      message:
          'We couldn\u2019t load your home data. Check your connection and try again.',
      actionLabel: 'Try Again',
      onAction: onRetry,
    );
  }
}
