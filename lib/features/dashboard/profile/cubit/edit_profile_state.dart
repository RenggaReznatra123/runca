import '../models/edit_profile_model.dart';

enum EditProfileLoadStatus { loading, success, failure }

enum EditProfileSaveStatus { idle, saving, success, failure }

class EditProfileState {
  const EditProfileState({
    this.loadStatus = EditProfileLoadStatus.loading,
    this.saveStatus = EditProfileSaveStatus.idle,
    this.draft,
  });

  final EditProfileLoadStatus loadStatus;
  final EditProfileSaveStatus saveStatus;

  /// Data yang sedang diedit (gender dan tanggal lahir dipilih lewat Cubit).
  final EditProfileData? draft;

  EditProfileState copyWith({
    EditProfileLoadStatus? loadStatus,
    EditProfileSaveStatus? saveStatus,
    EditProfileData? draft,
  }) {
    return EditProfileState(
      loadStatus: loadStatus ?? this.loadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      draft: draft ?? this.draft,
    );
  }
}