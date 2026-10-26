import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/activity/widgets/activity_state_view.dart';
import 'package:runca/ui/color.dart';

/// Tampilan gagal memuat di halaman Rewards dan detail voucher.
/// Figma belum punya desain khusus, jadi memakai gaya yang sama
/// dengan tampilan error di halaman Activity.
class RewardsErrorView extends StatelessWidget {
  const RewardsErrorView({
    super.key,
    required this.title,
    required this.onRetry,
  });

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ActivityStateView(
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
          title: title,
          message:
              'We couldn\u2019t load this. Check your connection and try again.',
          actionLabel: 'Try Again',
          onAction: onRetry,
        ),
      ),
    );
  }
}
