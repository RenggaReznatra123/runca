import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ActivityHeader extends StatelessWidget {
  const ActivityHeader({super.key, required this.onNotificationTap});

  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    // Padding dan ukuran ikon dibuat sama dengan HomeHeader,
    // supaya lonceng tidak bergeser saat pindah halaman.
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Activity',
                style: AppTypography.titleLarge(
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
            ),
            IconButton(
              onPressed: onNotificationTap,
              tooltip: 'Notifications',
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: 25,
                color: AppPalette.textNeutralPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
