import '../models/notification_model.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
  });

  final NotificationsStatus status;
  final List<NotificationModel> notifications;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationModel>? notifications,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
    );
  }
}
