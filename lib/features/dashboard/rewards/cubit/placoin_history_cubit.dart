import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/rewards_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/placoin_transaction_model.dart';
import 'placoin_history_state.dart';

class PlaCoinHistoryCubit extends Cubit<PlaCoinHistoryState> {
  PlaCoinHistoryCubit({RewardsRepository? repository})
    : _repository = repository ?? serviceLocator.get<RewardsRepository>(),
      super(const PlaCoinHistoryState()) {
    loadHistory();
  }

  final RewardsRepository _repository;
  int _requestId = 0;

  /// Muat awal dan Try Again: layar menampilkan loading.
  Future<void> loadHistory() async {
    emit(state.copyWith(status: PlaCoinHistoryStatus.loading));
    await _fetch();
  }

  /// Ganti tab: daftar lama tetap tampil sampai hasil baru datang.
  Future<void> selectFilter(PlaCoinHistoryFilter filter) async {
    if (filter == state.filter) return;

    emit(state.copyWith(filter: filter));
    await _fetch();
  }

  Future<void> _fetch() async {
    final requestId = ++_requestId;

    final result = await _repository.getCoinHistory(filter: state.filter);

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<List<PlaCoinTransaction>>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(
            status: PlaCoinHistoryStatus.success,
            transactions: data,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(status: PlaCoinHistoryStatus.failure));
  }
}
