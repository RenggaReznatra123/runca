enum ChallengeType {
  running('Running'),
  treadmill('Treadmill'),
  walking('Walking');

  const ChallengeType(this.label);

  final String label;
}

class ChallengeModel {
  const ChallengeModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.rewardCoins,
    required this.endDate,
    this.imageUrl,
  });

  final String id;
  final ChallengeType type;
  final String title;
  final String description;
  final int rewardCoins;
  final DateTime endDate;
  final String? imageUrl;
}

class ChallengeDetail {
  const ChallengeDetail({
    required this.id,
    required this.type,
    required this.title,
    required this.rewardCoins,
    required this.startDate,
    required this.endDate,
    required this.about,
    required this.targetKm,
    required this.requirements,
    this.bannerUrl,
  });

  final String id;
  final ChallengeType type;
  final String title;
  final int rewardCoins;
  final DateTime startDate;
  final DateTime endDate;
  final String about;
  final double targetKm;
  final List<String> requirements;
  final String? bannerUrl;
}
