import 'package:flutter/material.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Tampilan tengah halaman: gambar, judul, pesan, dan satu tombol.
class ActivityStateView extends StatelessWidget {
  const ActivityStateView({
    super.key,
    required this.leading,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final Widget leading;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(height: 28),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleMedium(
              color: AppPalette.textNeutralPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(
              color: AppPalette.textNeutralSecondary,
            ).copyWith(height: 24 / 14),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onAction,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 37),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppPalette.textButtonOutlined,
              side: const BorderSide(
                color: AppPalette.borderButtonOutlinedDefault,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: AppTypography.bodyMedium(),
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

/// Tampilan saat belum ada aktivitas sama sekali.
class ActivityEmptyView extends StatelessWidget {
  const ActivityEmptyView({super.key, required this.onStartActivity});

  final VoidCallback onStartActivity;

  @override
  Widget build(BuildContext context) {
    return ActivityStateView(
      leading: SizedBox(
        width: 108,
        height: 104,
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            AppAssets.activityEmpty,
            width: 108,
            height: 91,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const _EmptyIllustrationFallback(),
          ),
        ),
      ),
      title: 'No activities yet',
      message:
          'Your journey starts here. Record your first activity and find it here when you finish.',
      actionLabel: 'Start Activity',
      onAction: onStartActivity,
    );
  }
}

/// Pengganti sementara kalau file ilustrasi belum ada.
class _EmptyIllustrationFallback extends StatelessWidget {
  const _EmptyIllustrationFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.bgSurfacePrimary,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 91,
        height: 91,
        child: Icon(
          Icons.directions_run_rounded,
          size: 40,
          color: AppPalette.bgFillPrimary,
        ),
      ),
    );
  }
}

/// Tampilan saat data aktivitas gagal dimuat.
class ActivityErrorView extends StatelessWidget {
  const ActivityErrorView({super.key, required this.onRetry});

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
      title: 'Unable to load activities',
      message:
          'We couldn\u2019t load your activity history. Check your connection and try again.',
      actionLabel: 'Try Again',
      onAction: onRetry,
    );
  }
}
