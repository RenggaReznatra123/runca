import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_image.dart';

import '../models/notification_model.dart';
import 'notification_presentation.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({required this.notification, super.key});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    if (notification.type == NotificationType.reminder) {
      return ClipOval(
        child: AppImage(
          path: notification.imageUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          placeholder: _fallbackIcon(),
        ),
      );
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: notification.type.iconColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        notification.type.icon,
        color: AppPalette.baseWhite,
        size: 25,
      ),
    );
  }

  Widget _fallbackIcon() {
    return Container(
      width: 48,
      height: 48,
      color: notification.type.iconColor,
      alignment: Alignment.center,
      child: Icon(
        notification.type.icon,
        color: AppPalette.baseWhite,
        size: 25,
      ),
    );
  }
}
