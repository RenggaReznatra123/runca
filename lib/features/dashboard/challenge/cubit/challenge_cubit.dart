import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/dashboard/challenge/models/challenge_model.dart';
import 'package:runca/repository/challenge_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import 'challenge_state.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit({ChallengeRepository? repository})
    : _repository = repository ?? serviceLocator.get<ChallengeRepository>(),
      super(const ChallengeState()) {
    loadChallenges();
  }

  final ChallengeRepository _repository;

  // Dipakai untuk mengabaikan jawaban lama kalau ada permintaan yang lebih baru.
  // Tiap daftar punya penghitung sendiri.
  int _requestId = 0;
  int _activeRequestId = 0;
  int _historyRequestId = 0;

  Future<void> loadChallenges() => _fetch(showLoading: true, withBalance: true);

  Future<void> refresh() => _fetch(showLoading: false, withBalance: true);

  void selectTab(ChallengeTab tab) {
    if (tab == state.selectedTab) return;
    emit(state.copyWith(selectedTab: tab));

    // Active dan History dimuat (ulang) setiap tabnya dibuka.
    switch (tab) {
      case ChallengeTab.discover:
        break;
      case ChallengeTab.active:
        if (state.activeStatus == ChallengeStatus.success) {
          _fetchActive();
        } else {
          loadActive();
        }
      case ChallengeTab.history:
        if (state.historyStatus == ChallengeStatus.success) {
          _fetchHistory();
        } else {
          loadHistory();
        }
    }
  }

  void selectFilter(ChallengeFilter filter) {
    if (filter == state.selectedFilter) return;
    emit(state.copyWith(selectedFilter: filter));
    _fetch(showLoading: false);
  }

  /// Chip di tab History: daftar lama tetap tampil sampai hasil baru datang.
  void selectHistoryFilter(ChallengeFilter filter) {
    if (filter == state.historyFilter) return;
    emit(state.copyWith(historyFilter: filter));
    _fetchHistory();
  }

  /// Muat awal dan Try Again di tab Active: layar menampilkan loading.
  Future<void> loadActive() async {
    emit(state.copyWith(activeStatus: ChallengeStatus.loading));
    await _fetchActive();
  }

  /// Muat awal dan Try Again di tab History: layar menampilkan loading.
  Future<void> loadHistory() async {
    emit(state.copyWith(historyStatus: ChallengeStatus.loading));
    await _fetchHistory();
  }

  Future<void> _fetchActive() async {
    final requestId = ++_activeRequestId;

    final result = await _repository.getChallenges(
      kind: ChallengeListKind.active,
    );
    if (isClosed || requestId != _activeRequestId) return;

    if (result is DataStateSuccess<List<ChallengeModel>>) {
      emit(
        state.copyWith(
          activeStatus: ChallengeStatus.success,
          activeChallenges: result.data ?? const [],
        ),
      );
    } else {
      emit(state.copyWith(activeStatus: ChallengeStatus.failure));
    }
  }

  Future<void> _fetchHistory() async {
    final requestId = ++_historyRequestId;

    final result = await _repository.getChallenges(
      type: state.historyFilter.type,
      kind: ChallengeListKind.history,
    );
    if (isClosed || requestId != _historyRequestId) return;

    if (result is DataStateSuccess<List<ChallengeModel>>) {
      emit(
        state.copyWith(
          historyStatus: ChallengeStatus.success,
          historyChallenges: result.data ?? const [],
        ),
      );
    } else {
      emit(state.copyWith(historyStatus: ChallengeStatus.failure));
    }
  }

  Future<void> _fetch({
    required bool showLoading,
    bool withBalance = false,
  }) async {
    final requestId = ++_requestId;
    if (showLoading) emit(state.copyWith(status: ChallengeStatus.loading));

    if (withBalance) {
      final (challengeResult, balanceResult) = await (
        _repository.getChallenges(type: state.selectedFilter.type),
        _repository.getCoinBalance(),
      ).wait;
      if (isClosed || requestId != _requestId) return;

      if (challengeResult is DataStateSuccess<List<ChallengeModel>> &&
          balanceResult is DataStateSuccess<int>) {
        emit(
          state.copyWith(
            status: ChallengeStatus.success,
            challenges: challengeResult.data ?? const [],
            coinBalance: balanceResult.data ?? 0,
          ),
        );
      } else {
        emit(state.copyWith(status: ChallengeStatus.failure));
      }
      return;
    }

    final result = await _repository.getChallenges(
      type: state.selectedFilter.type,
    );
    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<ChallengeModel>>) {
      emit(
        state.copyWith(
          status: ChallengeStatus.success,
          challenges: result.data ?? const [],
        ),
      );
    } else {
      emit(state.copyWith(status: ChallengeStatus.failure));
    }
  }
}
