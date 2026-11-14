import '../models/notification_model.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.hasRefreshError = false,
  });

  final NotificationsStatus status;
  final List<NotificationModel> notifications;
  final bool hasRefreshError;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationModel>? notifications,
    bool? hasRefreshError,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      hasRefreshError: hasRefreshError ?? this.hasRefreshError,
    );
  }
}
