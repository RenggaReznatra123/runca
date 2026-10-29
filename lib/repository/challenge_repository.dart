import 'package:runca/features/dashboard/challenge/models/challenge_model.dart';
import 'package:runca/utility/resource/data_state.dart';

abstract class ChallengeRepository {
  /// Daftar challenge. [kind] memilih daftar (Discover, Active, atau History),
  /// [type] null berarti semua jenis.
  Future<DataState<List<ChallengeModel>>> getChallenges({
    ChallengeType? type,
    ChallengeListKind kind = ChallengeListKind.discover,
  });

  Future<DataState<ChallengeDetail>> getChallengeDetail(String id);

  Future<DataState<int>> getCoinBalance();
}
