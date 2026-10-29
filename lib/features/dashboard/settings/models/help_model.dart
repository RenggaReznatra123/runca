/// Kategori sebuah pertanyaan FAQ.
enum FaqCategory { trackingAndGps, account }

/// Pilihan chip di halaman FAQ. [category] null berarti semua kategori.
enum FaqFilter {
  all('All'),
  trackingAndGps('Tracking & GPS'),
  account('Account');

  const FaqFilter(this.label);

  final String label;

  FaqCategory? get category => switch (this) {
    FaqFilter.all => null,
    FaqFilter.trackingAndGps => FaqCategory.trackingAndGps,
    FaqFilter.account => FaqCategory.account,
  };
}

class FaqItem {
  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.proTip,
  });

  final String id;
  final String question;
  final String answer;
  final FaqCategory category;

  /// Tips tambahan. Awalan "Pro Tip:" ditulis oleh tampilan.
  final String? proTip;
}

enum LegalDocumentType {
  privacyPolicy('Privacy Policy'),
  termsOfService('Terms of Service');

  const LegalDocumentType(this.label);

  final String label;
}

/// Satu bagian dokumen. Nomor bagian dibuat oleh tampilan.
class LegalSection {
  const LegalSection({required this.title, required this.body});

  final String title;
  final String body;
}

class LegalDocument {
  const LegalDocument({
    required this.type,
    required this.updatedAt,
    required this.sections,
  });

  final LegalDocumentType type;
  final DateTime updatedAt;
  final List<LegalSection> sections;
}
