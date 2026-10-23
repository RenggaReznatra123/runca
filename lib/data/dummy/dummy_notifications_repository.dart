import 'package:runca/config/app_assets.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/home/notifications/models/notification_model.dart';
import 'package:runca/repository/notifications_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyNotificationsRepository implements NotificationsRepository {
  @override
  Future<DataState<List<NotificationModel>>> getNotifications() async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<List<NotificationModel>>('/notifications');
      case DummyScenario.empty:
        return const DataStateSuccess<List<NotificationModel>>([]);
      case DummyScenario.data:
        return DataStateSuccess<List<NotificationModel>>(
          _buildNotifications(DateTime.now()),
        );
    }
  }

  List<NotificationModel> _buildNotifications(DateTime now) {
    final yesterday = DateTime(now.year, now.month, now.day - 1, 18, 42);
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
        id: 'notification-activity',
        title: 'Your run is saved',
        description:
            'Afternoon Run at Simpang Lima has been synced to your activity history.',
        createdAt: yesterday,
        type: NotificationType.activity,
        activity: const ActivitySummary(
          title: 'Afternoon Run at Simpang Lima',
          distanceKm: 5.12,
          durationSeconds: 1714,
          paceSecondsPerKm: 334,
          calories: 384,
        ),
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
}
