import 'package:runca/features/dashboard/settings/models/help_model.dart';
import 'package:runca/utility/resource/data_state.dart';

/// Kontrak data bantuan: FAQ dan dokumen hukum.
abstract class HelpRepository {
  /// Daftar FAQ. [category] null berarti semua kategori, [query] null
  /// berarti tanpa pencarian.
  Future<DataState<List<FaqItem>>> getFaqs({
    FaqCategory? category,
    String? query,
  });

  /// Isi Privacy Policy atau Terms of Service.
  Future<DataState<LegalDocument>> getLegalDocument(LegalDocumentType type);
}
