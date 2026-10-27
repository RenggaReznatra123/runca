import '../models/placoin_transaction_model.dart';

enum PlaCoinHistoryStatus { loading, success, failure }

class PlaCoinHistoryState {
  const PlaCoinHistoryState({
    this.status = PlaCoinHistoryStatus.loading,
    this.filter = PlaCoinHistoryFilter.all,
    this.transactions = const [],
  });

  final PlaCoinHistoryStatus status;
  final PlaCoinHistoryFilter filter;

  /// Hasil dari repository, sudah terfilter.
  final List<PlaCoinTransaction> transactions;

  PlaCoinHistoryState copyWith({
    PlaCoinHistoryStatus? status,
    PlaCoinHistoryFilter? filter,
    List<PlaCoinTransaction>? transactions,
  }) {
    return PlaCoinHistoryState(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      transactions: transactions ?? this.transactions,
    );
  }
}
