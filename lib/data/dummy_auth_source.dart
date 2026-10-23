/// In-memory stand-in for the auth API, used while the backend is not ready.
///
/// All data lives in memory and resets when the app restarts.
class DummyAuthSource {
  DummyAuthSource._();

  static final DummyAuthSource instance = DummyAuthSource._();

  /// OTP dummy untuk Sign Up dan Reset Password.
  static const String verificationCode = '12345';

  static const String emailTakenMessage = 'This email is already registered.';

  static const String invalidCodeMessage =
      'The code is incorrect. Please try again.';

  static const Duration _latency = Duration(seconds: 1);

  final Map<String, String> _accounts = {};

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  /// Registrasi akun dummy.
  /// Mengembalikan false jika email sudah terdaftar.
  Future<bool> signUp({required String email, required String password}) async {
    await Future<void>.delayed(_latency);

    final key = _normalizeEmail(email);

    if (_accounts.containsKey(key)) {
      return false;
    }

    _accounts[key] = password;
    return true;
  }

  /// Verifikasi OTP dummy untuk Sign Up maupun Reset Password.
  Future<bool> verifyEmail({required String code}) async {
    await Future<void>.delayed(_latency);
    return code.trim() == verificationCode;
  }

  /// Simulasi mengirim OTP reset password.
  ///
  /// Tidak mengirim email sungguhan. Gunakan OTP 12345 di halaman OTP.
  Future<bool> requestPasswordReset({required String email}) async {
    await Future<void>.delayed(_latency);
    return email.trim().isNotEmpty;
  }

  /// Memperbarui password pada penyimpanan dummy.
  ///
  /// Akun yang belum ada juga dibuat agar flow prototype dapat diuji
  /// tanpa harus melakukan Sign Up terlebih dahulu.
  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future<void>.delayed(_latency);

    final key = _normalizeEmail(email);

    if (key.isEmpty || newPassword.isEmpty) {
      return false;
    }

    _accounts[key] = newPassword;
    return true;
  }
}

/// Build-time switches, set with --dart-define.
class AppConfig {
  const AppConfig._();

  /// Menggunakan data dummy alih-alih Firebase dan API asli.
  static const bool useDummyData = bool.fromEnvironment(
    'USE_DUMMY_DATA',
    defaultValue: true,
  );
}
