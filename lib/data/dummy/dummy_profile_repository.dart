import 'package:runca/config/app_assets.dart';
import 'package:runca/data/dummy/dummy_wallet.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/profile/models/edit_profile_model.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyProfileRepository implements ProfileRepository {
  DummyProfileRepository(this._wallet);

  final DummyWallet _wallet;

  /// Data profil di memori dummy. Save Changes mengubahnya, jadi nama dan
  /// lokasi di halaman Profile ikut berubah.
  EditProfileData _profile = EditProfileData(
    name: 'Dede Fernanda',
    email: 'dede@example.com',
    gender: ProfileGender.male,
    birthDate: DateTime(2005, 3, 22),
    heightCm: 175,
    weightKg: 62,
    location: 'Semarang, Indonesia',
    avatarUrl: AppAssets.avatarDede,
  );

  /// Semua badge, urutannya mengikuti Figma. Badge terkunci tidak punya
  /// tanggal. Kategori adalah ASUMSI (belum ada di Figma).
  static final List<AchievementModel> _achievements = [
    AchievementModel(
      id: 'achievement-1',
      title: 'First 5K',
      category: AchievementCategory.running,
      completedAt: DateTime(2026, 8, 12),
      iconAsset: AppAssets.first5K,
    ),
    AchievementModel(
      id: 'achievement-2',
      title: '10K Milestone',
      category: AchievementCategory.running,
      completedAt: DateTime(2026, 7, 28),
      iconAsset: AppAssets.tenKMilestone,
    ),
    AchievementModel(
      id: 'achievement-4',
      title: '50 km Total',
      category: AchievementCategory.running,
      completedAt: DateTime(2026, 6, 5),
      iconAsset: AppAssets.fiftyKmTotal,
    ),
    AchievementModel(
      id: 'achievement-5',
      title: '10 Runs',
      category: AchievementCategory.running,
      completedAt: DateTime(2026, 7, 10),
      iconAsset: AppAssets.tenRuns,
    ),
    AchievementModel(
      id: 'achievement-6',
      title: '7 Day Streak',
      category: AchievementCategory.streak,
      completedAt: DateTime(2026, 7, 20),
      iconAsset: AppAssets.sevenDayStreak,
    ),
    AchievementModel(
      id: 'achievement-3',
      title: 'Half Marathon',
      category: AchievementCategory.running,
      completedAt: DateTime(2026, 6, 15),
      iconAsset: AppAssets.halfMarathon,
    ),
    const AchievementModel(
      id: 'achievement-7',
      title: '100 km Total',
      category: AchievementCategory.running,
      completedAt: null,
      iconAsset: AppAssets.lockedAchievement,
    ),
    const AchievementModel(
      id: 'achievement-8',
      title: '100 Runs',
      category: AchievementCategory.running,
      completedAt: null,
      iconAsset: AppAssets.lockedAchievement,
    ),
  ];

  /// Tiga badge pratinjau di halaman Profile (tetap sama seperti sebelumnya).
  static const Set<String> _previewIds = {
    'achievement-1',
    'achievement-2',
    'achievement-3',
  };

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
              name: _profile.name,
              location: _profile.location,
              coins: _wallet.balance,
              rank: 7,
              avatarUrl: _profile.avatarUrl,
            ),
            achievements: _achievements
                .where((item) => _previewIds.contains(item.id))
                .toList(growable: false),
          ),
        );
    }
  }

  @override
  Future<DataState<List<AchievementModel>>> getAchievements({
    AchievementFilter filter = AchievementFilter.all,
  }) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<List<AchievementModel>>(
          '/profile/achievements',
        );
      case DummyScenario.empty:
        return const DataStateSuccess<List<AchievementModel>>([]);
      case DummyScenario.data:
        break;
    }

    final category = filter.category;

    final items = _achievements
        .where((item) => category == null || item.category == category)
        .toList(growable: false);

    return DataStateSuccess<List<AchievementModel>>(items);
  }

  @override
  Future<DataState<EditProfileData>> getEditProfile() async {
    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<EditProfileData>('/profile/edit');
    }

    return DataStateSuccess<EditProfileData>(_profile);
  }

  @override
  Future<DataState<EditProfileData>> updateProfile(EditProfileData data) async {
    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<EditProfileData>('/profile');
    }

    // Email tidak bisa diubah dari klien.
    _profile = data.copyWith(email: _profile.email);

    return DataStateSuccess<EditProfileData>(_profile);
  }
}
