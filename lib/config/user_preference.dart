import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserPreference {
  UserPreference(this.prefs);

  final SharedPreferences prefs;

  Future<bool> setUser(UserModel user) =>
      prefs.setString('user', json.encode(user.toJson()));

  UserModel getUser() {
    try {
      final raw = prefs.getString('user');
      if (raw == null || raw.isEmpty) return UserModel();
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        return UserModel.fromJson(decoded);
      }
      return UserModel();
    } catch (_) {
      return UserModel();
    }
  }

  Future<bool> setToken(String token) => prefs.setString('token', token);

  String? getToken() => prefs.getString('token');

  Future<void> clearSession() async {
    await prefs.remove('token');
    await prefs.remove('user');
  }

  bool get isLoggedIn {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAllData() => prefs.clear();
}
