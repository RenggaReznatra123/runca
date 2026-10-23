import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/notification_model.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit()
    : super(
        const NotificationsState(
          status: NotificationsStatus.success,
          notifications: _dummyNotifications,
        ),
      );

  static const List<NotificationModel> _dummyNotifications = [
    NotificationModel(
      title: 'Ready for your evening run?',
      description:
          'Your 5:00 PM run is coming up. Lace up and make time for yourself.',
      time: '2 hours ago',
      type: NotificationType.reminder,
      highlighted: true,
    ),
    NotificationModel(
      title: 'Keep your 2-day streak alive!',
      description:
          "You've run two days in a row. Run today to keep your streak going.",
      time: '2 hours ago',
      type: NotificationType.streak,
      actionLabel: 'Start Run',
    ),
    NotificationModel(
      title: 'Your run is saved',
      description:
          'Afternoon Run at Simpang Lima has been synced to your activity history.',
      time: 'Yesterday · 6:42 PM',
      type: NotificationType.activity,
      actionLabel: 'View Activity',
      activity: ActivitySummary(
        title: 'Afternoon Run at Simpang Lima',
        distance: '5.12 km',
        duration: '28:34',
        pace: "5’34” /km",
        calories: '384 kcal',
      ),
    ),
    NotificationModel(
      title: 'Your weekly progress is ready',
      description:
          'You ran 2.0 km more than last week. Here’s your outdoor running summary.',
      time: 'Sep 22 · 8:00 AM',
      type: NotificationType.weeklyProgress,
      actionLabel: 'View Progress',
      progress: WeeklyProgress(
        distance: '32.6 km',
        calories: '230 kcal',
        pace: "5’34” /km",
        duration: '01:32:12',
      ),
    ),
  ];

  void loadNotifications() {
    emit(
      state.copyWith(
        status: NotificationsStatus.success,
        notifications: _dummyNotifications,
      ),
    );
  }
}
