import '../models/help_model.dart';

enum LegalDocumentLoadStatus { loading, success, failure }

class LegalDocumentState {
  const LegalDocumentState({
    this.status = LegalDocumentLoadStatus.loading,
    this.document,
  });

  final LegalDocumentLoadStatus status;
  final LegalDocument? document;

  LegalDocumentState copyWith({
    LegalDocumentLoadStatus? status,
    LegalDocument? document,
  }) {
    return LegalDocumentState(
      status: status ?? this.status,
      document: document ?? this.document,
    );
  }
}
