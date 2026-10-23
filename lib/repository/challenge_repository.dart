import 'package:runca/features/dashboard/challenge/models/challenge_model.dart';
import 'package:runca/utility/resource/data_state.dart';

abstract class ChallengeRepository {
  Future<DataState<List<ChallengeModel>>> getChallenges({
    ChallengeType? type,
  });

  Future<DataState<ChallengeDetail>> getChallengeDetail(String id);

  Future<DataState<int>> getCoinBalance();
}
