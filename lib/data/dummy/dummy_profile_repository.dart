import 'dart:async';

import 'package:dio/dio.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/config/user_preference.dart';
import 'package:runca/data/dummy/dummy_profile_store.dart';
import 'package:runca/data/dummy/dummy_wallet.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/profile/models/edit_profile_model.dart';
import 'package:runca/features/dashboard/profile/models/profile_model.dart';
import 'package:runca/features/dashboard/profile/models/profile_setup_model.dart';
import 'package:runca/features/dashboard/profile/models/running_goal.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyProfileRepository implements ProfileRepository {
  DummyProfileRepository(DummyWallet wallet, UserPreference userPreference)
    : _wallet = wallet,
      _userPreference = userPreference,
      _store = DummyProfileStore(userPreference.prefs);

  static const String _demoEmail = 'runca@example.com';

  final DummyWallet _wallet;
  final UserPreference _userPreference;
  final DummyProfileStore _store;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

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
    final email = _sessionEmail();
    if (email == null) return DummyConfig.failure<ProfileData>('/profile');

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
        try {
          final profile = _profileFor(email);
          return DataStateSuccess<ProfileData>(
            ProfileData(
              profile: ProfileModel(
                name: profile.name,
                location: profile.location,
                coins: _wallet.balance,
                rank: 7,
                avatarUrl: profile.avatarUrl,
              ),
              achievements: _achievements
                  .where((item) => _previewIds.contains(item.id))
                  .toList(growable: false),
            ),
          );
        } catch (error) {
          return _storageFailure<ProfileData>('/profile', error);
        }
    }
  }

  @override
  Future<DataState<List<AchievementModel>>> getAchievements({
    AchievementFilter filter = AchievementFilter.all,
  }) async {
    final email = _sessionEmail();
    if (email == null) {
      return DummyConfig.failure<List<AchievementModel>>(
        '/profile/achievements',
      );
    }

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
    final email = _sessionEmail();
    if (email == null) {
      return DummyConfig.failure<EditProfileData>('/profile/edit');
    }

    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<EditProfileData>('/profile/edit');
    }

    try {
      return DataStateSuccess<EditProfileData>(_profileFor(email));
    } catch (error) {
      return _storageFailure<EditProfileData>('/profile/edit', error);
    }
  }

  @override
  Future<DataState<EditProfileData>> updateProfile(EditProfileData data) async {
    final email = _sessionEmail();
    if (email == null) return DummyConfig.failure<EditProfileData>('/profile');

    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<EditProfileData>('/profile');
    }

    try {
      final current = _profileFor(email);
      return await _saveProfile(
        email,
        data.copyWith(email: email),
        current,
        '/profile',
      );
    } catch (error) {
      return _storageFailure<EditProfileData>('/profile', error);
    }
  }

  @override
  Future<DataState<EditProfileData>> saveSetupProfile(
    ProfileSetupData data,
  ) async {
    final email = _sessionEmail();
    if (email == null) {
      return DummyConfig.failure<EditProfileData>('/profile/setup');
    }

    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<EditProfileData>('/profile/setup');
    }

    try {
      final current = _profileFor(email);
      final profile = EditProfileData(
        name: '${data.firstName.trim()} ${data.lastName.trim()}',
        email: email,
        gender: data.gender,
        birthDate: data.birthDate,
        heightCm: null,
        weightKg: null,
        location: '',
      );
      return await _saveProfile(
        email,
        profile,
        current,
        '/profile/setup',
        goals: data.goals,
      );
    } catch (error) {
      return _storageFailure<EditProfileData>('/profile/setup', error);
    }
  }

  String? _sessionEmail() {
    final email = _userPreference.getUser().email?.trim().toLowerCase();
    if (email == null || email.isEmpty) return null;

    return email;
  }

  EditProfileData _profileFor(String email) {
    final saved = _store.read(email);
    if (saved != null) return saved.copyWith(email: email);

    if (email == _demoEmail) {
      return EditProfileData(
        name: 'Dede Fernanda',
        email: _demoEmail,
        gender: ProfileGender.male,
        birthDate: DateTime(2005, 3, 22),
        heightCm: 175,
        weightKg: 62,
        location: 'Semarang, Indonesia',
        avatarUrl: AppAssets.avatarDede,
      );
    }

    return EditProfileData(
      name: '',
      email: email,
      gender: null,
      birthDate: null,
      heightCm: null,
      weightKg: null,
      location: '',
      avatarUrl: null,
    );
  }

  Future<DataState<EditProfileData>> _saveProfile(
    String email,
    EditProfileData profile,
    EditProfileData current,
    String path, {
    List<RunningGoal>? goals,
  }) async {
    var savedProfile = profile.copyWith(email: email);
    final avatar = savedProfile.avatarUrl;

    if (avatar != null &&
        avatar.startsWith('/') &&
        avatar != current.avatarUrl) {
      final persistentPath = await _store.copyAvatar(email, avatar);
      savedProfile = savedProfile.copyWith(avatarUrl: persistentPath);
    }

    if (!await _store.write(email, savedProfile, goals: goals)) {
      return _storageFailure<EditProfileData>(path);
    }

    _changes.add(null);
    return DataStateSuccess<EditProfileData>(savedProfile);
  }

  DataStateError<T> _storageFailure<T>(String path, [Object? error]) {
    return DataStateError<T>(
      DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.unknown,
        message: 'Unable to access local profile data.',
        error: error,
      ),
    );
  }
}
