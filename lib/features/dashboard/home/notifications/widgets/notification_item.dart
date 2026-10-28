import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/notification_model.dart';
import 'notification_presentation.dart';
import 'notification_activity_summary.dart';
import 'notification_icon.dart';
import 'weekly_progress_card.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    this.onAction,
  });

  final NotificationModel notification;
  final VoidCallback? onAction;

  static const Color _textColor = AppPalette.textNeutralPrimary;
  static const Color _secondaryColor = AppPalette.textNeutralSecondary;
  static const Color _primaryColor = AppPalette.bgFillPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: notification.highlighted ? 12 : 0,
      ),
      decoration: BoxDecoration(
        color: notification.highlighted
            ? AppPalette.bgPrimary
            : AppPalette.baseBlack.withValues(alpha: 0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationIcon(notification: notification),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppTypography.titleMedium(color: _textColor).copyWith(
                    fontSize: 15,
                    fontWeight: AppTypography.medium,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: AppTypography.bodyLarge(
                    color: _secondaryColor,
                  ).copyWith(fontSize: 12.5, height: 1.5),
                ),
                if (notification.activity != null) ...[
                  const SizedBox(height: 12),
                  NotificationActivitySummary(activity: notification.activity!),
                ],
                if (notification.progress != null) ...[
                  const SizedBox(height: 10),
                  WeeklyProgressCard(progress: notification.progress!),
                ],
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        AppFormat.notificationTime(notification.createdAt),
                        style: AppTypography.bodyMedium(
                          color: _secondaryColor,
                        ).copyWith(fontSize: 12, height: 1.4),
                      ),
                    ),
                    if (notification.type.actionLabel != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onAction,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            notification.type.actionLabel!,
                            style:
                                AppTypography.titleSmall(
                                  color: _primaryColor,
                                ).copyWith(
                                  fontSize: 12.5,
                                  fontWeight: AppTypography.medium,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
