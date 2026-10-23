
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DummyAuthService {
  DummyAuthService();

  static const String _accountsKey = 'runca_dummy_accounts';

  static const String defaultEmail = 'runca@example.com';
  static const String defaultPassword = 'Runca123!';

  Future<List<Map<String, String>>> _getAccounts() async {
    final preferences = await SharedPreferences.getInstance();
    final savedAccounts = preferences.getStringList(_accountsKey) ?? [];

    final accounts = savedAccounts.map((account) {
      final decoded = jsonDecode(account) as Map<String, dynamic>;

      return decoded.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    }).toList();

    final hasDefaultAccount = accounts.any(
      (account) =>
          account['email']?.toLowerCase() == defaultEmail.toLowerCase(),
    );

    if (!hasDefaultAccount) {
      accounts.insert(0, {
        'email': defaultEmail,
        'password': defaultPassword,
      });

      await _saveAccounts(accounts);
    }

    return accounts;
  }

  Future<void> _saveAccounts(
    List<Map<String, String>> accounts,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setStringList(
      _accountsKey,
      accounts.map((account) => jsonEncode(account)).toList(),
    );
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final accounts = await _getAccounts();
    final normalizedEmail = email.trim().toLowerCase();

    return accounts.any(
      (account) =>
          account['email']?.toLowerCase() == normalizedEmail &&
          account['password'] == password,
    );
  }

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    final accounts = await _getAccounts();
    final normalizedEmail = email.trim().toLowerCase();

    final emailExists = accounts.any(
      (account) =>
          account['email']?.toLowerCase() == normalizedEmail,
    );

    if (emailExists) {
      return 'Email sudah terdaftar. Gunakan email lain.';
    }

    accounts.add({
      'email': normalizedEmail,
      'password': password,
    });

    await _saveAccounts(accounts);

    return null;
  }
}
