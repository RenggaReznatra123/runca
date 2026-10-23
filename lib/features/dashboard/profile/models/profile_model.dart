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

class AchievementModel {
  const AchievementModel({
    required this.id,
    required this.title,
    required this.completedAt,
    required this.iconAsset,
  });

  final String id;
  final String title;
  final DateTime completedAt;
  final String? iconAsset;
}

class ProfileData {
  const ProfileData({required this.profile, required this.achievements});

  final ProfileModel profile;
  final List<AchievementModel> achievements;
}
