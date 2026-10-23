import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit() : super(const ProfileSetupState());

  Future<void> submitProfile({
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime birthday,
    required List<String> goals,
  }) async {
    emit(state.copyWith(status: ProfileSetupStatus.loading, clearError: true));

    try {
      // TODO: Ganti dengan pemanggilan fungsi dari DummyAuthSource/API
      await Future.delayed(const Duration(seconds: 2));

      if (isClosed) return;

      emit(state.copyWith(status: ProfileSetupStatus.success));
    } catch (e) {
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
