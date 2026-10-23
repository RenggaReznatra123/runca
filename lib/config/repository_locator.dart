import 'package:get_it/get_it.dart';

import 'package:runca/data/dummy/dummy_activity_repository.dart';
import 'package:runca/data/dummy/dummy_progress_repository.dart';
import 'package:runca/data/dummy/dummy_profile_repository.dart';

import 'package:runca/repository/activity_repository.dart';
import 'package:runca/repository/progress_repository.dart';
import 'package:runca/repository/profile_repository.dart';

/// Titik pergantian dummy ke API.
///
/// Saat API siap, implementasi repository dapat diganti tanpa
/// perlu mengubah Cubit, State, dan tampilan.
void registerRepositories(GetIt locator) {
  locator.registerLazySingleton<ActivityRepository>(
    () => DummyActivityRepository(),
  );

  locator.registerLazySingleton<ProgressRepository>(
    () => DummyProgressRepository(),
  );

  locator.registerLazySingleton<ProfileRepository>(
    () => DummyProfileRepository(),
  );
}
