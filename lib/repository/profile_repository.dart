import 'package:runca/features/dashboard/profile/models/edit_profile_model.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/utility/resource/data_state.dart';

abstract class ProfileRepository {
  Future<DataState<ProfileData>> getProfileData();

  /// Semua badge (selesai dan terkunci). [filter] all berarti semua kategori.
  Future<DataState<List<AchievementModel>>> getAchievements({
    AchievementFilter filter = AchievementFilter.all,
  });

  /// Data profil untuk halaman Edit Profile.
  Future<DataState<EditProfileData>> getEditProfile();

  /// Menyimpan perubahan profil. Email tidak diubah oleh server.
  Future<DataState<EditProfileData>> updateProfile(EditProfileData data);
}
