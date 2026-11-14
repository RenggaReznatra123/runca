import 'package:flutter_test/flutter_test.dart';
import 'package:runca/config/user_preference.dart';
import 'package:runca/data/dummy/dummy_profile_repository.dart';
import 'package:runca/data/dummy/dummy_wallet.dart';
import 'package:runca/features/dashboard/profile/models/edit_profile_model.dart';
import 'package:runca/features/dashboard/profile/models/profile_setup_model.dart';
import 'package:runca/features/dashboard/profile/models/running_goal.dart';
import 'package:runca/models/user_model.dart';
import 'package:runca/utility/resource/data_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('profiles persist independently by normalized session email', () async {
    final preferences = UserPreference(await SharedPreferences.getInstance());
    final repository = DummyProfileRepository(DummyWallet(), preferences);
    final birthDate = DateTime(2000, 4, 12);

    await preferences.setUser(UserModel(email: 'ASEP@example.com'));
    final saved = await repository.saveSetupProfile(
      ProfileSetupData(
        firstName: 'Asep',
        lastName: 'Runner',
        gender: ProfileGender.male,
        birthDate: birthDate,
        goals: const [RunningGoal.stayHealthyFit],
      ),
    );

    expect(saved, isA<DataStateSuccess<EditProfileData>>());
    expect(saved.data?.name, 'Asep Runner');
    expect(saved.data?.email, 'asep@example.com');
    expect(saved.data?.heightCm, isNull);
    expect(saved.data?.weightKg, isNull);

    await preferences.clearSession();
    await preferences.setUser(UserModel(email: 'other@example.com'));
    final empty = await repository.getEditProfile();
    expect(empty.data?.name, isEmpty);
    expect(empty.data?.email, 'other@example.com');
    expect(empty.data?.gender, isNull);
    expect(empty.data?.birthDate, isNull);

    await preferences.setUser(UserModel(email: 'asep@example.com'));
    final reopenedRepository = DummyProfileRepository(
      DummyWallet(),
      preferences,
    );
    final restored = await reopenedRepository.getEditProfile();
    expect(restored.data?.name, 'Asep Runner');
    expect(restored.data?.birthDate, birthDate);
  });

  test('demo profile retains its seed and uses the session email', () async {
    final preferences = UserPreference(await SharedPreferences.getInstance());
    final repository = DummyProfileRepository(DummyWallet(), preferences);
    await preferences.setUser(UserModel(email: 'RUNCA@example.com'));

    final result = await repository.getEditProfile();

    expect(result.data?.name, 'Dede Fernanda');
    expect(result.data?.email, 'runca@example.com');
  });
}
