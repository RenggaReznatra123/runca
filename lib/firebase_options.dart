import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Placeholder Firebase options.
///
/// Replace with the real generated file:
/// ```
/// dart run flutterfire_cli:flutterfire configure
/// ```
/// which overwrites this file with per-platform [FirebaseOptions].
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'run `flutterfire configure` to add them.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TODO-ANDROID-API-KEY',
    appId: 'TODO-ANDROID-APP-ID',
    messagingSenderId: 'TODO-SENDER-ID',
    projectId: 'TODO-PROJECT-ID',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TODO-IOS-API-KEY',
    appId: 'TODO-IOS-APP-ID',
    messagingSenderId: 'TODO-SENDER-ID',
    projectId: 'TODO-PROJECT-ID',
    iosBundleId: 'TODO-BUNDLE-ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'TODO-MACOS-API-KEY',
    appId: 'TODO-MACOS-APP-ID',
    messagingSenderId: 'TODO-SENDER-ID',
    projectId: 'TODO-PROJECT-ID',
    iosBundleId: 'TODO-BUNDLE-ID',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'TODO-WINDOWS-API-KEY',
    appId: 'TODO-WINDOWS-APP-ID',
    messagingSenderId: 'TODO-SENDER-ID',
    projectId: 'TODO-PROJECT-ID',
  );
}
