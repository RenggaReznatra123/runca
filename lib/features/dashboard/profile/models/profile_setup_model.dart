import 'edit_profile_model.dart';
import 'running_goal.dart';

class ProfileSetupData {
  const ProfileSetupData({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.goals,
  });

  final String firstName;
  final String lastName;
  final ProfileGender gender;
  final DateTime birthDate;
  final List<RunningGoal> goals;
}
