import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({ProfileRepository? repository})
    : _repository = repository ?? serviceLocator.get<ProfileRepository>(),
      super(const ProfileState()) {
    loadProfile();
  }

  final ProfileRepository _repository;
  int _requestId = 0;

  Future<void> loadProfile() async {
    await _fetch(showLoading: true);
  }

  Future<void> refresh() => _fetch(showLoading: false);

  Future<void> _fetch({required bool showLoading}) async {
    final requestId = ++_requestId;

    if (showLoading) {
      emit(state.copyWith(status: ProfileStatus.loading));
    }

    try {
      final result = await _repository.getProfileData();

      if (isClosed || requestId != _requestId) return;

      if (result is DataStateSuccess<ProfileData>) {
        emit(state.copyWith(status: ProfileStatus.success, data: result.data));
      } else {
        emit(state.copyWith(status: ProfileStatus.failure));
      }
    } catch (_) {
      if (isClosed || requestId != _requestId) return;
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }
}
