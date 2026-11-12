/// Jarak split otomatis (Auto Lap). [km] null berarti mati.
enum AutoLapOption {
  oneKm(1),
  halfKm(0.5),
  twoKm(2),
  off(null);

  const AutoLapOption(this.km);

  final double? km;
}

/// Hitung mundur sebelum lari. [seconds] 0 berarti dilewati.
enum CountdownOption {
  three(3),
  five(5),
  ten(10),
  off(0);

  const CountdownOption(this.seconds);

  final int seconds;
}

/// Seberapa sering Audio Coach bicara: tiap jarak ([km]) atau tiap
/// waktu ([minutes]). Suaranya belum berfungsi.
enum VoiceFrequencyOption {
  oneKm(km: 1),
  halfKm(km: 0.5),
  twoKm(km: 2),
  fiveMinutes(minutes: 5),
  tenMinutes(minutes: 10);

  const VoiceFrequencyOption({this.km, this.minutes});

  final double? km;
  final int? minutes;
}

class RunSettings {
  const RunSettings({
    this.autoPause = false,
    this.autoLap = AutoLapOption.oneKm,
    this.countdown = CountdownOption.three,
    this.keepScreenAwake = false,
    this.voiceCoach = false,
    this.voiceFrequency = VoiceFrequencyOption.oneKm,
  });

  final bool autoPause;
  final AutoLapOption autoLap;
  final CountdownOption countdown;
  final bool keepScreenAwake;
  final bool voiceCoach;
  final VoiceFrequencyOption voiceFrequency;

  RunSettings copyWith({
    bool? autoPause,
    AutoLapOption? autoLap,
    CountdownOption? countdown,
    bool? keepScreenAwake,
    bool? voiceCoach,
    VoiceFrequencyOption? voiceFrequency,
  }) {
    return RunSettings(
      autoPause: autoPause ?? this.autoPause,
      autoLap: autoLap ?? this.autoLap,
      countdown: countdown ?? this.countdown,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      voiceCoach: voiceCoach ?? this.voiceCoach,
      voiceFrequency: voiceFrequency ?? this.voiceFrequency,
    );
  }
}
