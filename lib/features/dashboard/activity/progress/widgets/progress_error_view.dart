import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

import '../../widgets/activity_state_view.dart';

/// Tampilan saat statistik Progress gagal dimuat.
/// Figma belum punya desain khusus, jadi memakai gaya yang sama
/// dengan tampilan error di tab Activities.
class ProgressErrorView extends StatelessWidget {
  const ProgressErrorView({super.key, required this.onRetry});

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
      title: 'Unable to load progress',
      message:
          'We couldn\u2019t load your progress. Check your connection and try again.',
      actionLabel: 'Try Again',
      onAction: onRetry,
    );
  }
}
