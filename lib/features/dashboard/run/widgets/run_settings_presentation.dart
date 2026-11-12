import '../models/run_settings.dart';

extension AutoLapPresentation on AutoLapOption {
  /// Teks di sheet pilihan.
  String get sheetLabel => switch (this) {
    AutoLapOption.oneKm => '1.0 km (Standard)',
    AutoLapOption.halfKm => '0.5 km',
    AutoLapOption.twoKm => '2.0 km',
    AutoLapOption.off => 'Off',
  };

  /// Teks di baris pengaturan.
  String get rowLabel => switch (this) {
    AutoLapOption.oneKm => '1 km',
    AutoLapOption.halfKm => '0.5 km',
    AutoLapOption.twoKm => '2 km',
    AutoLapOption.off => 'Off',
  };

  String get description => switch (this) {
    AutoLapOption.oneKm => 'Auto-split every 1 km.',
    AutoLapOption.halfKm => 'Auto-split every 0.5 km.',
    AutoLapOption.twoKm => 'Auto-split every 2 km.',
    AutoLapOption.off => 'Auto-split is off.',
  };
}

extension CountdownPresentation on CountdownOption {
  String get sheetLabel => switch (this) {
    CountdownOption.three => '3 Seconds (Default)',
    CountdownOption.five => '5 Seconds',
    CountdownOption.ten => '10 Seconds',
    CountdownOption.off => 'Off',
  };

  String get rowLabel => switch (this) {
    CountdownOption.three => '3 Seconds',
    CountdownOption.five => '5 Seconds',
    CountdownOption.ten => '10 Seconds',
    CountdownOption.off => 'Off',
  };
}

extension VoiceFrequencyPresentation on VoiceFrequencyOption {
  String get sheetLabel => switch (this) {
    VoiceFrequencyOption.oneKm => 'Every 1.0 km (Default)',
    VoiceFrequencyOption.halfKm => 'Every 0.5 km',
    VoiceFrequencyOption.twoKm => 'Every 2.0 km',
    VoiceFrequencyOption.fiveMinutes => 'Every 5 Minutes',
    VoiceFrequencyOption.tenMinutes => 'Every 10 Minutes',
  };

  String get rowLabel => switch (this) {
    VoiceFrequencyOption.oneKm => 'Every 1 km',
    VoiceFrequencyOption.halfKm => 'Every 0.5 km',
    VoiceFrequencyOption.twoKm => 'Every 2 km',
    VoiceFrequencyOption.fiveMinutes => 'Every 5 min',
    VoiceFrequencyOption.tenMinutes => 'Every 10 min',
  };
}
