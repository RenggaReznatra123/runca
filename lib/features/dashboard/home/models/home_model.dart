enum HomeActivityType { indoor, outdoor }

class HomeOverview {
  const HomeOverview({required this.streak, required this.weekDays});

  final int streak;
  final List<WeeklyCalendarDay> weekDays;
}

class WeeklyCalendarDay {
  const WeeklyCalendarDay({required this.date, required this.isToday});

  final DateTime date;
  final bool isToday;
}

class WeeklyStatsData {
  const WeeklyStatsData({
    required this.distanceKm,
    required this.calories,
    required this.paceSecondsPerKm,
    required this.durationSeconds,
    required this.distanceChangeKm,
    required this.distanceIncreased,
    required this.caloriesChange,
    required this.caloriesIncreased,
    required this.paceChangePercent,
    required this.paceIncreased,
    required this.durationChangeMinutes,
    required this.durationIncreased,
  });

  final double distanceKm;
  final int calories;
  final int? paceSecondsPerKm;
  final int durationSeconds;
  final double distanceChangeKm;
  final bool distanceIncreased;
  final int caloriesChange;
  final bool caloriesIncreased;
  final double paceChangePercent;
  final bool paceIncreased;
  final int durationChangeMinutes;
  final bool durationIncreased;
}
