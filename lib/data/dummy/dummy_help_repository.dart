import 'package:runca/data/dummy_config.dart';
import 'package:runca/features/dashboard/settings/models/help_model.dart';
import 'package:runca/repository/help_repository.dart';
import 'package:runca/utility/resource/data_state.dart';

class DummyHelpRepository implements HelpRepository {
  // Pertanyaan dan jawaban pertama diambil dari Figma. Jawaban 2 sampai 5
  // dan semua kategori adalah teks contoh (ASUMSI, bukan dari Figma).
  static const List<FaqItem> _faqs = [
    FaqItem(
      id: 'faq-1',
      question: 'How does treadmill tracking work without GPS?',
      answer:
          'Indoor workouts utilize your device\u2019s high-precision built-in '
          'accelerometer and gyroscope to measure cadence, arm swings, and '
          'estimated stride length without needing a satellite signal.',
      category: FaqCategory.trackingAndGps,
      proTip:
          'After completing your run, you can tap Calibrate Distance on the '
          'summary screen to align data precisely with the treadmill console.',
    ),
    FaqItem(
      id: 'faq-2',
      question: 'Why is my GPS route inaccurate or disconnecting?',
      answer:
          'GPS can drop near tall buildings, dense trees, or tunnels. Turn on '
          'high-accuracy location, keep the app open, and wait for a solid '
          'GPS signal before you start your run.',
      category: FaqCategory.trackingAndGps,
    ),
    FaqItem(
      id: 'faq-3',
      question: 'How do I redeem points for brand vouchers?',
      answer:
          'Open Rewards from your Profile, choose a voucher, and tap Redeem. '
          'The PlaCoins are deducted from your balance and the voucher is '
          'saved in My Vouchers.',
      category: FaqCategory.account,
    ),
    FaqItem(
      id: 'faq-4',
      question: 'Can I connect with Apple Health, Strava, or Garmin?',
      answer:
          'Connections with Apple Health, Strava, and Garmin are not '
          'available yet. We will let you know when they are ready.',
      category: FaqCategory.account,
    ),
    FaqItem(
      id: 'faq-5',
      question: 'How do I back up my run history?',
      answer:
          'Your run history is saved to your account automatically whenever '
          'you are online. Log in on a new device to see it again.',
      category: FaqCategory.account,
    ),
  ];

  // Teks diambil dari Figma.
  static final DateTime _legalUpdatedAt = DateTime(2025, 8, 1);

  static const List<LegalSection> _privacySections = [
    LegalSection(
      title: 'Information We Collect',
      body:
          'We collect information you provide directly to us, including your '
          'name, email address, and usage data.',
    ),
    LegalSection(
      title: 'How We Use Your Information',
      body:
          'We use your information to provide, maintain, and improve our '
          'services, and to communicate with you about your account and '
          'updates.',
    ),
    LegalSection(
      title: 'Sharing Your Information',
      body:
          'We do not sell your personal information. We may share it with '
          'trusted partners only when necessary to provide our services.',
    ),
    LegalSection(
      title: 'Your Rights',
      body:
          'You can access, update, or delete your personal information at any '
          'time by contacting us.',
    ),
  ];

  static const List<LegalSection> _termsSections = [
    LegalSection(
      title: 'Acceptance of Terms',
      body:
          'By using our services, you agree to these Terms of Service and our '
          'Privacy Policy.',
    ),
    LegalSection(
      title: 'Use of the Service',
      body:
          'You agree to use the service for lawful purposes only and not to '
          'engage in any activity that may harm the platform or other users.',
    ),
    LegalSection(
      title: 'Account Responsibility',
      body:
          'You are responsible for maintaining the confidentiality of your '
          'account and password.',
    ),
    LegalSection(
      title: 'Changes to Terms',
      body:
          'We may update these terms from time to time. Continued use of the '
          'service means you accept any changes.',
    ),
  ];

  @override
  Future<DataState<List<FaqItem>>> getFaqs({
    FaqCategory? category,
    String? query,
  }) async {
    await DummyConfig.simulateNetwork();

    switch (DummyConfig.scenario) {
      case DummyScenario.failure:
        return DummyConfig.failure<List<FaqItem>>('/help/faqs');
      case DummyScenario.empty:
        return const DataStateSuccess<List<FaqItem>>([]);
      case DummyScenario.data:
        break;
    }

    final keyword = query?.trim().toLowerCase() ?? '';

    final items = _faqs
        .where((faq) {
          if (category != null && faq.category != category) return false;
          if (keyword.isEmpty) return true;

          return faq.question.toLowerCase().contains(keyword) ||
              faq.answer.toLowerCase().contains(keyword);
        })
        .toList(growable: false);

    return DataStateSuccess<List<FaqItem>>(items);
  }

  @override
  Future<DataState<LegalDocument>> getLegalDocument(
    LegalDocumentType type,
  ) async {
    await DummyConfig.simulateNetwork();

    if (DummyConfig.scenario == DummyScenario.failure) {
      return DummyConfig.failure<LegalDocument>('/help/legal/${type.name}');
    }

    return DataStateSuccess<LegalDocument>(
      LegalDocument(
        type: type,
        updatedAt: _legalUpdatedAt,
        sections: switch (type) {
          LegalDocumentType.privacyPolicy => _privacySections,
          LegalDocumentType.termsOfService => _termsSections,
        },
      ),
    );
  }
}
