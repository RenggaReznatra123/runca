import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:runca/features/dashboard/profile/models/edit_profile_model.dart';
import 'package:runca/features/dashboard/profile/models/running_goal.dart';

class DummyProfileStore {
  DummyProfileStore(this._prefs);

  final SharedPreferences _prefs;

  EditProfileData? read(String email) {
    final decoded = _read(email);
    if (decoded == null) return null;

    final genderName = decoded['gender'] as String?;
    return EditProfileData(
      name: decoded['name'] as String,
      email: decoded['email'] as String,
      gender: genderName == null
          ? null
          : ProfileGender.values.byName(genderName),
      birthDate: (decoded['birthDate'] as String?) == null
          ? null
          : DateTime.parse(decoded['birthDate'] as String),
      heightCm: decoded['heightCm'] as int?,
      weightKg: decoded['weightKg'] as int?,
      location: decoded['location'] as String,
      avatarUrl: decoded['avatarUrl'] as String?,
    );
  }

  List<RunningGoal> readGoals(String email) {
    final stored = _read(email);
    final values = stored?['goals'] as List<dynamic>?;
    if (values == null) return const [];

    return values
        .map((value) => RunningGoal.values.byName(value as String))
        .toList(growable: false);
  }

  Future<bool> write(
    String email,
    EditProfileData profile, {
    List<RunningGoal>? goals,
  }) {
    return _prefs.setString(
      _key(email),
      json.encode({
        'name': profile.name,
        'email': profile.email,
        'gender': profile.gender?.name,
        'birthDate': profile.birthDate?.toIso8601String(),
        'heightCm': profile.heightCm,
        'weightKg': profile.weightKg,
        'location': profile.location,
        'avatarUrl': profile.avatarUrl,
        'goals': (goals ?? readGoals(email)).map((goal) => goal.name).toList(),
      }),
    );
  }

  Future<String> copyAvatar(String email, String sourcePath) async {
    final source = File(sourcePath);
    final directory = await getApplicationDocumentsDirectory();
    final safeEmail = email.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final sourceName = source.uri.pathSegments.last;
    final extensionIndex = sourceName.lastIndexOf('.');
    final extension = extensionIndex > 0
        ? sourceName.substring(extensionIndex)
        : '.jpg';
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final destination = File(
      '${directory.path}${Platform.pathSeparator}'
      '${safeEmail}_avatar_$timestamp$extension',
    );

    await source.copy(destination.path);
    return destination.path;
  }

  String _key(String email) => 'profile_${Uri.encodeComponent(email)}';

  Map<String, dynamic>? _read(String email) {
    final raw = _prefs.getString(_key(email));
    if (raw == null) return null;

    final decoded = json.decode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid stored profile.');
    }

    return decoded;
  }
}
