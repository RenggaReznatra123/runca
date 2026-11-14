import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/profile/models/edit_profile_model.dart';
import 'package:runca/features/dashboard/profile/models/profile_setup_model.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit({ProfileRepository? repository})
    : _repository = repository ?? serviceLocator.get<ProfileRepository>(),
      super(const ProfileSetupState());

  final ProfileRepository _repository;

  Future<void> submitProfile(ProfileSetupData data) async {
    emit(state.copyWith(status: ProfileSetupStatus.loading, clearError: true));

    try {
      final result = await _repository.saveSetupProfile(data);

      if (isClosed) return;

      if (result is DataStateSuccess<EditProfileData> && result.data != null) {
        emit(state.copyWith(status: ProfileSetupStatus.success));
        return;
      }

      emit(
        state.copyWith(
          status: ProfileSetupStatus.failure,
          errorMessage: 'Gagal menyimpan profil. Periksa koneksi Anda.',
        ),
      );
    } catch (_) {
      if (isClosed) return;

      emit(
        state.copyWith(
          status: ProfileSetupStatus.failure,
          errorMessage: 'Gagal menyimpan profil. Periksa koneksi Anda.',
        ),
      );
    }
  }
}
