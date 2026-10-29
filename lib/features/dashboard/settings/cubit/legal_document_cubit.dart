import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/service_locator.dart';
import 'package:runca/repository/help_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

import '../models/help_model.dart';
import 'legal_document_state.dart';

class LegalDocumentCubit extends Cubit<LegalDocumentState> {
  LegalDocumentCubit({
    required LegalDocumentType type,
    HelpRepository? repository,
  }) : _type = type,
       _repository = repository ?? serviceLocator.get<HelpRepository>(),
       super(const LegalDocumentState()) {
    loadDocument();
  }

  final LegalDocumentType _type;
  final HelpRepository _repository;
  int _requestId = 0;

  Future<void> loadDocument() async {
    final requestId = ++_requestId;

    emit(state.copyWith(status: LegalDocumentLoadStatus.loading));

    final result = await _repository.getLegalDocument(_type);

    if (isClosed || requestId != _requestId) return;

    if (result is DataStateSuccess<LegalDocument>) {
      final data = result.data;

      if (data != null) {
        emit(
          state.copyWith(
            status: LegalDocumentLoadStatus.success,
            document: data,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(status: LegalDocumentLoadStatus.failure));
  }
}
