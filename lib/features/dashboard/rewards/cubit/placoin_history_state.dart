import '../models/placoin_transaction_model.dart';

enum PlaCoinHistoryStatus { loading, success, failure }

class PlaCoinHistoryState {
  const PlaCoinHistoryState({
    this.status = PlaCoinHistoryStatus.loading,
    this.filter = PlaCoinHistoryFilter.all,
    this.transactions = const [],
    this.hasRefreshError = false,
  });

  final PlaCoinHistoryStatus status;
  final PlaCoinHistoryFilter filter;
  final bool hasRefreshError;

  /// Hasil dari repository, sudah terfilter.
  final List<PlaCoinTransaction> transactions;

  PlaCoinHistoryState copyWith({
    PlaCoinHistoryStatus? status,
    PlaCoinHistoryFilter? filter,
    List<PlaCoinTransaction>? transactions,
    bool? hasRefreshError,
  }) {
    return PlaCoinHistoryState(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      transactions: transactions ?? this.transactions,
      hasRefreshError: hasRefreshError ?? this.hasRefreshError,
    );
  }
}
