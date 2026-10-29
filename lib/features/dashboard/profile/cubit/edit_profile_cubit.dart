import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/edit_profile_model.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({ProfileRepository? repository})
    : _repository = repository ?? serviceLocator.get<ProfileRepository>(),
      super(const EditProfileState()) {
    loadProfile();
  }

  final ProfileRepository _repository;
  int _requestId = 0;

  Future<void> loadProfile() async {
    final requestId = ++_requestId;

    emit(state.copyWith(loadStatus: EditProfileLoadStatus.loading));

    final result = await _repository.getEditProfile();

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<EditProfileData>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(
            loadStatus: EditProfileLoadStatus.success,
            draft: data,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(loadStatus: EditProfileLoadStatus.failure));
  }

  void selectGender(ProfileGender gender) {
    final draft = state.draft;
    if (draft == null) return;

    emit(state.copyWith(draft: draft.copyWith(gender: gender)));
  }

  void selectBirthDate(DateTime date) {
    final draft = state.draft;
    if (draft == null) return;

    emit(state.copyWith(draft: draft.copyWith(birthDate: date)));
  }

  Future<void> save(EditProfileData data) async {
    if (state.saveStatus == EditProfileSaveStatus.saving) return;

    emit(
      state.copyWith(saveStatus: EditProfileSaveStatus.saving, draft: data),
    );

    final result = await _repository.updateProfile(data);

    if (isClosed) return;

    if (result is DataStateSuccess<EditProfileData>) {
      emit(
        state.copyWith(
          saveStatus: EditProfileSaveStatus.success,
          draft: result.data ?? data,
        ),
      );
      return;
    }

    emit(state.copyWith(saveStatus: EditProfileSaveStatus.failure));
  }

  void clearSaveStatus() {
    emit(state.copyWith(saveStatus: EditProfileSaveStatus.idle));
  }
}