import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/profile_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/profile_model.dart';
import 'achievements_state.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  AchievementsCubit({ProfileRepository? repository})
    : _repository = repository ?? serviceLocator.get<ProfileRepository>(),
      super(const AchievementsState()) {
    loadAchievements();
  }

  final ProfileRepository _repository;

  // Dipakai untuk mengabaikan jawaban lama kalau ada permintaan yang lebih baru.
  int _requestId = 0;

  /// Muat awal dan Try Again: layar menampilkan loading.
  Future<void> loadAchievements() async {
    emit(
      state.copyWith(
        status: AchievementsLoadStatus.loading,
        hasRefreshError: false,
      ),
    );
    await _fetch();
  }

  Future<void> refresh() => _fetch(isRefresh: true);

  void clearRefreshError() {
    if (state.hasRefreshError) {
      emit(state.copyWith(hasRefreshError: false));
    }
  }

  /// Ganti chip: daftar lama tetap tampil sampai hasil baru datang.
  Future<void> selectFilter(AchievementFilter filter) async {
    if (filter == state.filter) return;

    emit(state.copyWith(filter: filter));
    await _fetch();
  }

  Future<void> _fetch({bool isRefresh = false}) async {
    final requestId = ++_requestId;

    final result = await _repository.getAchievements(filter: state.filter);

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<AchievementModel>>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(
            status: AchievementsLoadStatus.success,
            achievements: data,
            hasRefreshError: false,
          ),
        );
        return;
      }
    }

    if (isRefresh) {
      emit(state.copyWith(hasRefreshError: true));
    } else {
      emit(
        state.copyWith(
          status: AchievementsLoadStatus.failure,
          hasRefreshError: false,
        ),
      );
    }
  }
}
