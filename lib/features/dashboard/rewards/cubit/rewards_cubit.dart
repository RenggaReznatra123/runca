import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/rewards_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/reward_model.dart';
import 'rewards_state.dart';

class RewardsCubit extends Cubit<RewardsState> {
  RewardsCubit({RewardsRepository? repository})
    : _repository = repository ?? serviceLocator.get<RewardsRepository>(),
      super(const RewardsState()) {
    loadRewards();
  }

  final RewardsRepository _repository;

  // Dipakai untuk mengabaikan jawaban lama kalau ada permintaan yang lebih baru.
  int _requestId = 0;

  /// Muat awal dan tombol Try Again. Menampilkan loading.
  Future<void> loadRewards() => _fetch(showLoading: true);

  /// Ambil ulang tanpa loading, contoh: setelah redeem.
  Future<void> refresh() => _fetch(showLoading: false);

  void selectFilter(RewardFilter filter) {
    if (filter == state.selectedFilter) return;

    emit(state.copyWith(selectedFilter: filter));
    _fetch(showLoading: false);
  }

  Future<void> _fetch({required bool showLoading}) async {
    final requestId = ++_requestId;
    final category = state.selectedFilter.category;

    if (showLoading) {
      emit(state.copyWith(status: RewardsStatus.loading));
    }

    final result = await _repository.getRewards(category: category);

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<RewardsData>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(
            status: RewardsStatus.success,
            coinBalance: data.coinBalance,
            rewards: data.rewards,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(status: RewardsStatus.failure));
  }
}
