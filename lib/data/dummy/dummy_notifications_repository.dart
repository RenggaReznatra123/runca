import 'package:runca/config/app_assets.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/home/notifications/models/notification_model.dart';
import 'package:runca/repository/activity_repository.dart';
import 'package:runca/repository/notifications_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyNotificationsRepository implements NotificationsRepository {
  DummyNotificationsRepository({required this._activityRepository});

  final ActivityRepository _activityRepository;

  @override
  Future<DataState<List<NotificationModel>>> getNotifications() async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<List<NotificationModel>>('/notifications');
      case DummyScenario.empty:
        return const DataStateSuccess<List<NotificationModel>>([]);
      case DummyScenario.data:
        final notifications = _buildNotifications(DateTime.now());
        final activities = await _activityRepository.getActivities();
        if (activities is DataStateSuccess<List<ActivityModel>>) {
          final savedActivities = activities.data;
          if (savedActivities != null) {
            notifications.addAll(
              savedActivities.map(_notificationFromActivity),
            );
          }
        }
        final indexedNotifications =
            List.generate(
              notifications.length,
              (index) => (index: index, notification: notifications[index]),
            )..sort((a, b) {
              final byDate = b.notification.createdAt.compareTo(
                a.notification.createdAt,
              );
              return byDate != 0 ? byDate : a.index.compareTo(b.index);
            });
        return DataStateSuccess<List<NotificationModel>>(
          indexedNotifications
              .map((entry) => entry.notification)
              .toList(growable: false),
        );
    }
  }

  List<NotificationModel> _buildNotifications(DateTime now) {
    final twoDaysAgo = DateTime(now.year, now.month, now.day - 2, 8);

    return [
      NotificationModel(
        id: 'notification-reminder',
        title: 'Ready for your evening run?',
        description:
            'Your 5:00 PM run is coming up. Lace up and make time for yourself.',
        createdAt: now.subtract(const Duration(hours: 2)),
        type: NotificationType.reminder,
        highlighted: true,
        imageUrl: AppAssets.challengeImage,
      ),
      NotificationModel(
        id: 'notification-streak',
        title: 'Keep your 2-day streak alive!',
        description:
            "You've run two days in a row. Run today to keep your streak going.",
        createdAt: now.subtract(const Duration(hours: 2)),
        type: NotificationType.streak,
      ),
      NotificationModel(
        id: 'notification-weekly-progress',
        title: 'Your weekly progress is ready',
        description:
            'You ran 2.0 km more than last week. Here’s your outdoor running summary.',
        createdAt: twoDaysAgo,
        type: NotificationType.weeklyProgress,
        progress: const WeeklyProgress(
          distanceKm: 32.6,
          calories: 230,
          paceSecondsPerKm: 334,
          durationSeconds: 5532,
        ),
      ),
    ];
  }

  NotificationModel _notificationFromActivity(ActivityModel activity) {
    return NotificationModel(
      id: 'notification-activity-${activity.id}',
      title: activity.type == ActivityType.cycling
          ? 'Your ride is saved'
          : 'Your run is saved',
      description:
          '${activity.title} has been synced to your activity history.',
      createdAt: activity.startedAt.add(
        Duration(seconds: activity.durationSeconds),
      ),
      type: NotificationType.activity,
      activity: ActivitySummary(
        title: activity.title,
        distanceKm: activity.distanceKm,
        durationSeconds: activity.durationSeconds,
        paceSecondsPerKm: activity.avgPaceSecondsPerKm,
        calories: activity.calories,
        route: activity.route,
        mapImageUrl: activity.mapImageUrl,
      ),
    );
  }
}
