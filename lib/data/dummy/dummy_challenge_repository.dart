import 'package:dio/dio.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/challenge/models/challenge_model.dart';
import 'package:runca/repository/challenge_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyChallengeRepository implements ChallengeRepository {
  static const String _about =
      'Complete a 5 km run (outdoor or treadmill) in a single session before '
      'the deadline to earn 5,000 PlaCoins.';
  static const List<String> _requirements = [
    'Use the app to track your run',
    'Complete 5 km in a single activity',
    'Run between 6:00 AM and 9:00 AM',
  ];

  @override
  Future<DataState<List<ChallengeModel>>> getChallenges({
    ChallengeType? type,
  }) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<List<ChallengeModel>>('/challenges');
      case DummyScenario.empty:
        return const DataStateSuccess<List<ChallengeModel>>([]);
      case DummyScenario.data:
        final challenges = _buildChallenges();
        final filtered = type == null
            ? challenges
            : challenges.where((challenge) => challenge.type == type).toList();
        return DataStateSuccess<List<ChallengeModel>>(filtered);
    }
  }

  @override
  Future<DataState<ChallengeDetail>> getChallengeDetail(String id) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<ChallengeDetail>('/challenges/$id');
      case DummyScenario.empty:
        return _notFound(id);
      case DummyScenario.data:
        if (!id.startsWith('challenge-') ||
            int.tryParse(id.substring('challenge-'.length)) == null) {
          return _notFound(id);
        }
        return DataStateSuccess<ChallengeDetail>(_buildDetail(id));
    }
  }

  @override
  Future<DataState<int>> getCoinBalance() async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<int>('/profile/coins');
      case DummyScenario.empty:
        return const DataStateSuccess<int>(0);
      case DummyScenario.data:
        return const DataStateSuccess<int>(10000);
    }
  }

  List<ChallengeModel> _buildChallenges() {
    final endDate = DateTime.now().add(const Duration(days: 3));
    return List<ChallengeModel>.generate(
      3,
      (index) => ChallengeModel(
        id: 'challenge-${index + 1}',
        type: ChallengeType.running,
        title: '5K Morning Run',
        description: 'Complete a 5 km morning run.',
        rewardCoins: 5000,
        endDate: endDate,
        imageUrl: AppAssets.challengeImage,
      ),
      growable: false,
    );
  }

  ChallengeDetail _buildDetail(String id) {
    final endDate = DateTime.now().add(const Duration(days: 3));
    return ChallengeDetail(
      id: id,
      type: ChallengeType.running,
      title: '5K Morning Run',
      rewardCoins: 5000,
      startDate: endDate.subtract(const Duration(days: 4)),
      endDate: endDate,
      about: _about,
      targetKm: 5,
      requirements: _requirements,
      bannerUrl: AppAssets.challengeImage,
    );
  }

  DataStateError<ChallengeDetail> _notFound(String id) {
    return DataStateError<ChallengeDetail>(
      DioException(
        requestOptions: RequestOptions(path: '/challenges/$id'),
        type: DioExceptionType.badResponse,
        message: 'Challenge not found.',
        response: Response(
          requestOptions: RequestOptions(path: '/challenges/$id'),
          statusCode: 404,
        ),
      ),
    );
  }
}
