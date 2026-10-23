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

  /// 324 -> '324 kcal'
  static String calories(int kcal) => '$kcal kcal';

  /// 2 -> '2', 12 (persen) -> '12%', 1.5 -> '1.5'
  static String change(double amount, {bool isPercent = false}) {
    final isWhole = amount == amount.roundToDouble();
    final text = isWhole ? amount.round().toString() : amount.toStringAsFixed(1);

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
}