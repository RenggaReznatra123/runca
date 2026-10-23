
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/utility/resource/data_state.dart';

abstract class ProfileRepository {
  Future<DataState<ProfileData>> getProfileData();
}
