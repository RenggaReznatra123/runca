import 'package:runca/features/dashboard/profile/models/profile_model.dart';

enum ProfileStatus { loading, success, failure }

class ProfileState {
  const ProfileState({this.status = ProfileStatus.loading, this.data});

  final ProfileStatus status;
  final ProfileData? data;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileData? data,
    bool clearData = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      data: clearData ? null : (data ?? this.data),
    );
  }
}
