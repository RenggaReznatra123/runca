import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/home/notifications/models/notification_model.dart';
import 'package:runca/repository/notifications_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({NotificationsRepository? repository})
    : _repository =
          repository ?? serviceLocator.get<NotificationsRepository>(),
      super(const NotificationsState()) {
    loadNotifications();
  }

  final NotificationsRepository _repository;
  int _requestId = 0;

  Future<void> loadNotifications() async {
    final requestId = ++_requestId;
    emit(state.copyWith(status: NotificationsStatus.loading));

    final result = await _repository.getNotifications();
    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<NotificationModel>>) {
      emit(
        state.copyWith(
          status: NotificationsStatus.success,
          notifications: result.data ?? const [],
        ),
      );
    } else {
      emit(state.copyWith(status: NotificationsStatus.failure));
    }
  }
}
