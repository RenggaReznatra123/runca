enum ProgressPeriod {
  day('Day'),
  week('Week'),
  month('Month'),
  year('Year');

  const ProgressPeriod(this.label);

  final String label;
}

/// Satu batang di grafik.
class ProgressBar {
  const ProgressBar({required this.label, required this.distanceKm});

  /// Label sumbu X, contoh: '08.00'.
  final String label;

  /// Jarak dalam kilometer.
  final double distanceKm;
}

/// Perubahan dibanding periode sebelumnya.
class ProgressChange {
  const ProgressChange({
    required this.amount,
    required this.isIncrease,
    this.isPercent = false,
  });

  /// Besar perubahan, contoh: 2 atau 12.
  final double amount;

  /// True kalau [amount] berupa persen.
  final bool isPercent;

  /// True kalau naik, false kalau turun.
  final bool isIncrease;
}

class ProgressStats {
  const ProgressStats({
    required this.bars,
    required this.distanceKm,
    required this.activityCount,
    required this.calories,
    required this.distanceChange,
    required this.activityChange,
    required this.caloriesChange,
  });

  final List<ProgressBar> bars;
  final double distanceKm;
  final int activityCount;
  final int calories;
  final ProgressChange distanceChange;
  final ProgressChange activityChange;
  final ProgressChange caloriesChange;
}

class PersonalRecords {
  const PersonalRecords({
    required this.longestDistanceKm,
    required this.longestStreakDays,
    required this.bestPaceSecondsPerKm,
  });

  final double longestDistanceKm;
  final int longestStreakDays;

  /// Pace terbaik dalam detik per kilometer, contoh: 255 (4'15").
  final int bestPaceSecondsPerKm;
}
