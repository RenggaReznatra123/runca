import 'package:runca/config/app_assets.dart';
import 'package:runca/data/dummy/dummy_wallet.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyProfileRepository implements ProfileRepository {
  DummyProfileRepository(this._wallet);

  final DummyWallet _wallet;

  static final List<AchievementModel> _achievements = [
    AchievementModel(
      id: 'achievement-1',
      title: 'First 5K',
      completedAt: DateTime(2026, 8, 12),
      iconAsset: AppAssets.first5K,
    ),
    AchievementModel(
      id: 'achievement-2',
      title: '10K Milestone',
      completedAt: DateTime(2026, 7, 28),
      iconAsset: AppAssets.tenKMilestone,
    ),
    AchievementModel(
      id: 'achievement-3',
      title: 'Half Marathon',
      completedAt: DateTime(2026, 6, 15),
      iconAsset: AppAssets.halfMarathon,
    ),
  ];

  @override
  Future<DataState<ProfileData>> getProfileData() async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<ProfileData>('/profile');

      case DummyScenario.empty:
        return const DataStateSuccess<ProfileData>(
          ProfileData(
            profile: ProfileModel(name: '', location: '', coins: 0, rank: 0),
            achievements: [],
          ),
        );

      case DummyScenario.data:
        return DataStateSuccess<ProfileData>(
          ProfileData(
            profile: ProfileModel(
              name: 'Dede Fernanda',
              location: 'Semarang, Indonesia',
              coins: _wallet.balance,
              rank: 7,
            ),
            achievements: _achievements,
          ),
        );
    }
  }
}