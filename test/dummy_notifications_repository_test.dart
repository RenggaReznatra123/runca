import 'package:flutter_test/flutter_test.dart';
import 'package:runca/data/dummy/dummy_activity_repository.dart';
import 'package:runca/data/dummy/dummy_notifications_repository.dart';
import 'package:runca/features/dashboard/activity/models/activity_draft.dart';
import 'package:runca/features/dashboard/activity/models/activity_model.dart';
import 'package:runca/features/dashboard/home/notifications/models/notification_model.dart';
import 'package:runca/utility/resource/data_state.dart';

void main() {
  test('returns no activity notifications when no activities are saved', () async {
    final repository = DummyNotificationsRepository(
      activityRepository: DummyActivityRepository(),
    );

    final result = await repository.getNotifications();
    final notifications = result.data!;

    expect(
      notifications.where(
        (notification) => notification.type == NotificationType.activity,
      ),
      isEmpty,
    );
  });

  test('builds an activity notification from a saved activity', () async {
    final activities = DummyActivityRepository();
    final repository = DummyNotificationsRepository(
      activityRepository: activities,
    );
    final startedAt = DateTime(2026, 11, 15, 7);
    final saved = await activities.saveActivity(
      ActivityDraft(
        type: ActivityType.running,
        title: 'Morning Run',
        startedAt: startedAt,
        distanceKm: 6.25,
        durationSeconds: 1800,
        avgPaceSecondsPerKm: 288,
        calories: 420,
        route: const [],
      ),
    );
    final result = await repository.getNotifications();
    final notifications = result.data!
        .where(
          (notification) => notification.type == NotificationType.activity,
        )
        .toList();

    expect(saved, isA<DataStateSuccess<ActivityModel>>());
    expect(notifications, hasLength(1));
    expect(
      notifications.single.createdAt,
      startedAt.add(const Duration(seconds: 1800)),
    );
    expect(
      notifications.single.activity,
      isA<ActivitySummary>()
          .having((summary) => summary.title, 'title', 'Morning Run')
          .having((summary) => summary.distanceKm, 'distanceKm', 6.25)
          .having((summary) => summary.durationSeconds, 'durationSeconds', 1800)
          .having((summary) => summary.paceSecondsPerKm, 'paceSecondsPerKm', 288)
          .having((summary) => summary.calories, 'calories', 420),
    );
  });

  test('orders activity notifications by creation time, newest first', () async {
    final activities = DummyActivityRepository();
    final repository = DummyNotificationsRepository(
      activityRepository: activities,
    );
    final olderStartedAt = DateTime(2026, 11, 14, 7);
    final newerStartedAt = DateTime(2026, 11, 15, 7);

    await activities.saveActivity(
      ActivityDraft(
        type: ActivityType.running,
        title: 'Older Run',
        startedAt: olderStartedAt,
        distanceKm: 4,
        durationSeconds: 1500,
        avgPaceSecondsPerKm: 375,
        calories: 300,
        route: const [],
      ),
    );
    await activities.saveActivity(
      ActivityDraft(
        type: ActivityType.cycling,
        title: 'Newer Ride',
        startedAt: newerStartedAt,
        distanceKm: 12,
        durationSeconds: 2400,
        avgPaceSecondsPerKm: 200,
        calories: 500,
        route: const [],
      ),
    );

    final result = await repository.getNotifications();
    final activityNotifications = result.data!
        .where(
          (notification) => notification.type == NotificationType.activity,
        )
        .toList();

    expect(activityNotifications, hasLength(2));
    expect(
      activityNotifications.map((notification) => notification.activity?.title),
      ['Newer Ride', 'Older Run'],
    );
  });
}
