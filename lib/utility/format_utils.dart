import 'package:intl/intl.dart';

/// Pemformat teks tampilan. Model menyimpan data mentah,
/// teks siap tampil dibuat di sini.
class AppFormat {
  const AppFormat._();

  static final NumberFormat _thousands = NumberFormat('#,###', 'en_US');

  /// 8.4 -> '8.40 km'
  static String distanceKm(double km) => '${km.toStringAsFixed(2)} km';

  /// 32.6 -> '32.6' (angka saja, satuan ditulis terpisah)
  static String distanceValue(double km) => km.toStringAsFixed(1);

  /// 1280 -> '1,280'
  static String thousands(int value) => _thousands.format(value);

  static String integer(int value) => value.toString();

  static String dayUnit(int count) => count == 1 ? 'day' : 'days';

  /// 2616 -> '43:36', 4133 -> '1:08:53'
  static String duration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');

    if (hours > 0) {
      final paddedMinutes = minutes.toString().padLeft(2, '0');
      return '$hours:$paddedMinutes:$seconds';
    }

    return '$minutes:$seconds';
  }

  /// 311 (detik per km) -> 5'11"
  static String pace(int secondsPerKm) {
    final minutes = secondsPerKm ~/ 60;
    final seconds = (secondsPerKm % 60).toString().padLeft(2, '0');

    return "$minutes'$seconds\"";
  }

  static String pacePerKm(int secondsPerKm) {
    return "${pace(secondsPerKm).replaceAll("'", '’').replaceAll('"', '”')} /km";
  }

  /// 324 -> '324 kcal'
  static String calories(int kcal) => '$kcal kcal';

  /// 2 -> '2', 12 (persen) -> '12%', 1.5 -> '1.5'
  static String change(double amount, {bool isPercent = false}) {
    final isWhole = amount == amount.roundToDouble();
    final text = isWhole
        ? amount.round().toString()
        : amount.toStringAsFixed(1);

    return isPercent ? '$text%' : text;
  }

  /// DateTime(2026, 8, 12, 6, 42) -> 'Aug 12, 2026 • 6:42 AM'
  static String activityDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y \u2022 h:mm a', 'en_US').format(dateTime);
  }

  /// DateTime(2026, 9, 19) -> '19 September 2026'
  static String fullDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'en_US').format(date);
  }

  /// DateTime(2026, 8, 12) -> 'Aug 12, 2026'
  static String shortDate(DateTime date) {
    return DateFormat('MMM d, y', 'en_US').format(date);
  }

  /// DateTime(2005, 3, 22) -> '22-03-2005'
  static String birthDate(DateTime date) {
    return DateFormat('dd-MM-yyyy', 'en_US').format(date);
  }

  /// DateTime(2025, 8, 1) -> 'August 1, 2025'
  static String longDate(DateTime date) {
    return DateFormat('MMMM d, y', 'en_US').format(date);
  }

  /// 5.123 -> '5.12' (angka saja, satuan ditulis di label)
  static String distanceNumber(double km) => km.toStringAsFixed(2);

  /// Besok-kemarin: 'Yesterday, Sep 21 • 6:42 AM'. Hari ini: 'Today, ...'.
  /// Lebih lama dari kemarin: format activityDateTime.
  static String lastActivityDateTime(DateTime dateTime, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    final day = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final time = DateFormat('MMM d \u2022 h:mm a', 'en_US').format(dateTime);

    if (day == today) return 'Today, $time';
    if (day == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, $time';
    }

    return activityDateTime(dateTime);
  }

  /// Waktu tersisa sampai batas akhir challenge.
  static String timeLeft(DateTime endDate, {DateTime? now}) {
    final remaining = endDate.difference(now ?? DateTime.now());
    if (remaining.isNegative) return 'Ended';
    if (remaining < const Duration(days: 1)) return 'Ends today';

    final days = remaining.inDays;
    return days == 1 ? '1 day left' : '$days days left';
  }

  /// Format tanggal awal dan akhir challenge.
  static String dateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('dd MMM yyyy', 'en_US');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  /// Format jarak target challenge.
  static String targetKm(double km) {
    final distance = NumberFormat('0.##', 'en_US').format(km);
    return '$distance KM';
  }

  /// Format relatif untuk waktu notifikasi.
  static String notificationTime(DateTime dateTime, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final currentDay = DateTime(current.year, current.month, current.day);
    final notificationDay = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
    if (notificationDay == currentDay.subtract(const Duration(days: 1))) {
      return 'Yesterday · ${DateFormat('h:mm a', 'en_US').format(dateTime)}';
    }

    final elapsed = current.difference(dateTime);
    if (elapsed < const Duration(hours: 24)) {
      final hours = elapsed.inHours.clamp(1, 23);
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    }

    return DateFormat('MMM d · h:mm a', 'en_US').format(dateTime);
  }

  static String notificationSectionDate(DateTime date) {
    return DateFormat('MMM d', 'en_US').format(date);
  }

  static String notificationWeekRange(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    if (weekStart.month == today.month) {
      return '${DateFormat('MMM d', 'en_US').format(weekStart)}–${today.day}';
    }
    return '${DateFormat('MMM d', 'en_US').format(weekStart)}–'
        '${DateFormat('MMM d', 'en_US').format(today)}';
  }

  /// Format durasi sebagai jam, menit, dan detik dengan dua digit.
  static String clockDuration(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  static String firstName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty || parts.first.isEmpty ? 'there' : parts.first;
  }

  /// 48 -> '48 vouchers', 1 -> '1 voucher'
  static String voucherCount(int count) {
    return count == 1 ? '1 voucher' : '$count vouchers';
  }

  static String weekdayShort(DateTime date) {
    return DateFormat('EEE', 'en_US').format(date);
  }

  /// 5000 -> '+5,000 PC', -10000 -> '-10,000 PC'
  static String coinAmount(int amount) {
    final sign = amount < 0 ? '-' : '+';
    return '$sign${thousands(amount.abs())} PC';
  }

  static String challengeReward(int amount) => '+ ${thousands(amount)}';

  static String dayStreak(int days) => '$days-day streak';

  /// DateTime(2026, 9, 27, 8, 15) -> '08:15 AM'
  static String timeOfDay(DateTime dateTime) {
    return DateFormat('hh:mm a', 'en_US').format(dateTime);
  }

  static String countdownMinutesSeconds(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String birthdayInput(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day/${date.year}';
  }
}
