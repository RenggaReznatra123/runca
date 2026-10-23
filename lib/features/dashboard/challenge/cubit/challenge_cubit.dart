import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/app_assets.dart';

import '../models/challenge_model.dart';
import 'challenge_state.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit() : super(const ChallengeState()) {
    loadChallenges();
  }

  // Data dummy sesuai Figma, sampai backend tersedia.
  static const List<ChallengeModel> dummyChallenges = [
    ChallengeModel(
      id: 'challenge-1',
      type: ChallengeType.running,
      title: '5K Morning Run',
      description: 'Complete a 5 km morning run.',
      rewardCoins: 5000,
      timeLeft: '3 days left',
      about:
          'Complete a 5 km run (outdoor or treadmill) in a single session before the deadline to earn 5,000 PlaCoins.',
      dateRange: '03 Jul 2026 - 07 Jul 2026',
      target: '5 KM',
      requirements: [
        'Use the app to track your run',
        'Complete 5 km in a single activity',
        'Run between 6:00 AM and 9:00 AM',
      ],
      imageAsset: AppAssets.challengeImage,
      bannerAsset: AppAssets.challengeImage,
    ),
    ChallengeModel(
      id: 'challenge-2',
      type: ChallengeType.running,
      title: '5K Morning Run',
      description: 'Complete a 5 km morning run.',
      rewardCoins: 5000,
      timeLeft: '3 days left',
      about:
          'Complete a 5 km run (outdoor or treadmill) in a single session before the deadline to earn 5,000 PlaCoins.',
      dateRange: '03 Jul 2026 - 07 Jul 2026',
      target: '5 KM',
      requirements: [
        'Use the app to track your run',
        'Complete 5 km in a single activity',
        'Run between 6:00 AM and 9:00 AM',
      ],
      imageAsset: AppAssets.challengeImage,
      bannerAsset: AppAssets.challengeImage,
    ),
    ChallengeModel(
      id: 'challenge-3',
      type: ChallengeType.running,
      title: '5K Morning Run',
      description: 'Complete a 5 km morning run.',
      rewardCoins: 5000,
      timeLeft: '3 days left',
      about:
          'Complete a 5 km run (outdoor or treadmill) in a single session before the deadline to earn 5,000 PlaCoins.',
      dateRange: '03 Jul 2026 - 07 Jul 2026',
      target: '5 KM',
      requirements: [
        'Use the app to track your run',
        'Complete 5 km in a single activity',
        'Run between 6:00 AM and 9:00 AM',
      ],
      imageAsset: AppAssets.challengeImage,
      bannerAsset: AppAssets.challengeImage,
    ),
  ];

  void loadChallenges() {
    emit(state.copyWith(coinBalance: 10000, challenges: dummyChallenges));
  }

  void selectTab(ChallengeTab tab) {
    if (tab == state.selectedTab) return;

    emit(state.copyWith(selectedTab: tab));
  }

  void selectFilter(ChallengeFilter filter) {
    if (filter == state.selectedFilter) return;

    emit(state.copyWith(selectedFilter: filter));
  }
}
