import 'package:runca/features/dashboard/home/notifications/models/notification_model.dart';
import 'package:runca/utility/resource/data_state.dart';

abstract class NotificationsRepository {
  Future<DataState<List<NotificationModel>>> getNotifications();
}
