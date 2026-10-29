import '../models/help_model.dart';

enum FaqLoadStatus { loading, success, failure }

class FaqState {
  const FaqState({
    this.status = FaqLoadStatus.loading,
    this.filter = FaqFilter.all,
    this.searchQuery = '',
    this.items = const [],
    this.expandedId,
  });

  final FaqLoadStatus status;
  final FaqFilter filter;
  final String searchQuery;

  /// Hasil dari repository, sudah terfilter.
  final List<FaqItem> items;

  /// ID pertanyaan yang sedang terbuka (hanya satu pada satu waktu).
  final String? expandedId;

  FaqState copyWith({
    FaqLoadStatus? status,
    FaqFilter? filter,
    String? searchQuery,
    List<FaqItem>? items,
    String? expandedId,
    bool clearExpandedId = false,
  }) {
    return FaqState(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      items: items ?? this.items,
      expandedId: clearExpandedId ? null : (expandedId ?? this.expandedId),
    );
  }
}
