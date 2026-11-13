import 'package:get_it/get_it.dart';

import 'package:runca/data/dummy/dummy_activity_repository.dart';
import 'package:runca/data/dummy/dummy_challenge_repository.dart';
import 'package:runca/data/dummy/dummy_help_repository.dart';
import 'package:runca/data/dummy/dummy_progress_repository.dart';
import 'package:runca/data/dummy/dummy_profile_repository.dart';
import 'package:runca/data/dummy/dummy_rewards_repository.dart';
import 'package:runca/data/dummy/dummy_settings_repository.dart';
import 'package:runca/data/dummy/dummy_notifications_repository.dart';
import 'package:runca/data/dummy/dummy_leaderboard_repository.dart';
import 'package:runca/data/dummy/dummy_home_repository.dart';
import 'package:runca/data/dummy/dummy_location_repository.dart';
import 'package:runca/data/dummy/dummy_wallet.dart';
import 'package:runca/data/geolocator_location_repository.dart';

import 'package:runca/repository/activity_repository.dart';
import 'package:runca/repository/challenge_repository.dart';
import 'package:runca/repository/help_repository.dart';
import 'package:runca/repository/location_repository.dart';
import 'package:runca/repository/progress_repository.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/repository/rewards_repository.dart';
import 'package:runca/repository/settings_repository.dart';
import 'package:runca/repository/notifications_repository.dart';
import 'package:runca/repository/leaderboard_repository.dart';
import 'package:runca/repository/home_repository.dart';
import 'package:runca/data/dummy/dummy_run_settings_repository.dart';
import 'package:runca/repository/run_settings_repository.dart';
import 'package:runca/data/dummy/dummy_step_repository.dart';
import 'package:runca/repository/step_repository.dart';
import 'package:runca/data/dummy/dummy_place_name_repository.dart';
import 'package:runca/data/geocoding_place_name_repository.dart';
import 'package:runca/data/image_picker_photo_picker_repository.dart';
import 'package:runca/repository/place_name_repository.dart';
import 'package:runca/repository/photo_picker_repository.dart';
import 'package:runca/config/user_preference.dart';

/// Nyalakan untuk menguji lari di emulator tanpa keluar rumah (titik GPS
/// tiruan bergerak sendiri). Matikan (false) saat uji di HP asli atau rilis.
const bool _useDummyLocation = true;

/// Titik pergantian dummy ke API.
///
/// Saat API siap, implementasi repository dapat diganti tanpa
/// perlu mengubah Cubit, State, dan tampilan.
void registerRepositories(GetIt locator) {
  locator.registerLazySingleton<PhotoPickerRepository>(
    () => ImagePickerPhotoPickerRepository(),
  );
  locator.registerLazySingleton<DummyWallet>(() => DummyWallet());

  locator.registerLazySingleton<ActivityRepository>(
    () => DummyActivityRepository(),
  );

  locator.registerLazySingleton<ChallengeRepository>(
    () => DummyChallengeRepository(locator.get<DummyWallet>()),
  );

  locator.registerLazySingleton<ProgressRepository>(
    () => DummyProgressRepository(locator.get<ActivityRepository>()),
  );

  locator.registerLazySingleton<ProfileRepository>(
    () => DummyProfileRepository(locator.get<DummyWallet>()),
  );

  locator.registerLazySingleton<RewardsRepository>(
    () => DummyRewardsRepository(locator.get<DummyWallet>()),
  );

  // Ganti implementasi ini ke repository API saat backend tersedia.
  locator.registerLazySingleton<SettingsRepository>(
    () => DummySettingsRepository(locator.get<UserPreference>()),
  );

  locator.registerLazySingleton<HelpRepository>(() => DummyHelpRepository());

  locator.registerLazySingleton<NotificationsRepository>(
    () => DummyNotificationsRepository(),
  );

  locator.registerLazySingleton<LeaderboardRepository>(
    () => DummyLeaderboardRepository(),
  );

  locator.registerLazySingleton<HomeRepository>(
    () => DummyHomeRepository(locator.get<ActivityRepository>()),
  );

  locator.registerLazySingleton<RunSettingsRepository>(
    () => DummyRunSettingsRepository(locator.get<UserPreference>()),
  );
  // Langkah Treadmill masih simulasi. Ganti ke implementasi sensor nanti.
  locator.registerLazySingleton<StepRepository>(() => DummyStepRepository());
  // Lokasi memakai GPS perangkat, atau simulasi lari kalau
  // _useDummyLocation bernilai true.
  locator.registerLazySingleton<LocationRepository>(
    () => _useDummyLocation
        ? DummyLocationRepository()
        : GeolocatorLocationRepository(),
  );

  // Nama tempat: simulasi selama _useDummyLocation bernilai true.
  locator.registerLazySingleton<PlaceNameRepository>(
    () => _useDummyLocation
        ? DummyPlaceNameRepository()
        : GeocodingPlaceNameRepository(),
  );
}
