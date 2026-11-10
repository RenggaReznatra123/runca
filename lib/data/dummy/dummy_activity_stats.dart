import 'package:runca/features/dashboard/activity/models/activity_model.dart';

/// Hitungan turunan dari daftar aktivitas, dipakai repository dummy
/// Progress dan Home. Saat API ada, server yang menghitung ini.
class DummyActivityStats {
  const DummyActivityStats._();

  static DateTime dayOf(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime _nextDay(DateTime day) {
    return DateTime(day.year, day.month, day.day + 1);
  }

  static DateTime _previousDay(DateTime day) {
    return DateTime(day.year, day.month, day.day - 1);
  }

  static Set<DateTime> _activeDays(List<ActivityModel> activities) {
    return {for (final activity in activities) dayOf(activity.startedAt)};
  }

  /// Aktivitas yang mulai di dalam [start] (termasuk) sampai [end] (tidak
  /// termasuk).
  static List<ActivityModel> between(
    List<ActivityModel> activities,
    DateTime start,
    DateTime end,
  ) {
    return activities
        .where(
          (activity) =>
              !activity.startedAt.isBefore(start) &&
              activity.startedAt.isBefore(end),
        )
        .toList(growable: false);
  }

  /// Jumlah hari berturut-turut yang ada larinya, dihitung mundur dari hari
  /// ini. Kalau hari ini belum lari, streak kemarin masih dihitung.
  static int currentStreak(List<ActivityModel> activities, {DateTime? now}) {
    final days = _activeDays(activities);
    var cursor = dayOf(now ?? DateTime.now());

    if (!days.contains(cursor)) cursor = _previousDay(cursor);

    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = _previousDay(cursor);
    }

    return streak;
  }

  /// Rangkaian hari berturut-turut terpanjang sepanjang riwayat.
  static int longestStreak(List<ActivityModel> activities) {
    final days = _activeDays(activities).toList()..sort();

    var longest = 0;
    var run = 0;
    DateTime? previous;

    for (final day in days) {
      run = previous != null && day == _nextDay(previous) ? run + 1 : 1;
      if (run > longest) longest = run;
      previous = day;
    }

    return longest;
  }
}