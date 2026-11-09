/// Jenis target lari yang bisa dipilih di sheet Set a Goal.
enum RunGoalType { distance, time }

/// Target lari. Berisi data mentah (km atau detik), tanpa teks tampilan.
sealed class RunGoal {
  const RunGoal();
}

/// Target jarak dalam kilometer.
final class DistanceGoal extends RunGoal {
  const DistanceGoal(this.km);

  final double km;
}

/// Target waktu dalam detik.
final class TimeGoal extends RunGoal {
  const TimeGoal(this.seconds);

  final int seconds;
}

/// Hasil sheet Set a Goal: target yang dipakai, ditambah isian valid di
/// kedua tab supaya tidak hilang saat sheet dibuka lagi.
class RunGoalSubmission {
  const RunGoalSubmission({
    required this.goal,
    this.distanceKm,
    this.timeSeconds,
  });

  final RunGoal goal;

  /// Isian tab Distance (null kalau kosong atau tidak valid).
  final double? distanceKm;

  /// Isian tab Time dalam detik (null kalau kosong atau tidak valid).
  final int? timeSeconds;
}
