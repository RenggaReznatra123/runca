class ProfileModel {
  const ProfileModel({
    required this.name,
    required this.location,
    required this.coins,
    required this.rank,
    this.avatarUrl,
  });

  final String name;
  final String location;
  final int coins;
  final int rank;
  final String? avatarUrl;
}

/// Kategori sebuah badge.
enum AchievementCategory { running, treadmill, streak }

/// Pilihan chip di halaman Achievements. [category] null berarti semua.
enum AchievementFilter {
  all('All'),
  running('Running'),
  treadmill('Treadmill'),
  streak('Streak');

  const AchievementFilter(this.label);

  final String label;

  AchievementCategory? get category => switch (this) {
    AchievementFilter.all => null,
    AchievementFilter.running => AchievementCategory.running,
    AchievementFilter.treadmill => AchievementCategory.treadmill,
    AchievementFilter.streak => AchievementCategory.streak,
  };
}

class AchievementModel {
  const AchievementModel({
    required this.id,
    required this.title,
    required this.category,
    required this.completedAt,
    required this.iconAsset,
  });

  final String id;
  final String title;
  final AchievementCategory category;

  /// Waktu badge diraih. Null berarti badge masih terkunci.
  final DateTime? completedAt;
  final String? iconAsset;
}

class ProfileData {
  const ProfileData({required this.profile, required this.achievements});

  final ProfileModel profile;
  final List<AchievementModel> achievements;
}
