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

  Future<void> loadNotifications() => _fetch(showLoading: true);

  Future<void> refresh() => _fetch(showLoading: false);

  void clearRefreshError() {
    if (state.hasRefreshError) {
      emit(state.copyWith(hasRefreshError: false));
    }
  }

  Future<void> _fetch({required bool showLoading}) async {
    final requestId = ++_requestId;
    if (showLoading) {
      emit(
        state.copyWith(
          status: NotificationsStatus.loading,
          hasRefreshError: false,
        ),
      );
    }

    final result = await _repository.getNotifications();
    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<NotificationModel>>) {
      emit(
        state.copyWith(
          status: NotificationsStatus.success,
          notifications: result.data ?? const [],
          hasRefreshError: false,
        ),
      );
    } else if (showLoading) {
      emit(
        state.copyWith(
          status: NotificationsStatus.failure,
          hasRefreshError: false,
        ),
      );
    } else {
      emit(state.copyWith(hasRefreshError: true));
    }
  }
}
