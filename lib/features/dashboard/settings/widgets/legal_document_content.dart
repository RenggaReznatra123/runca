import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/help_model.dart';

/// Isi dokumen hukum: tanggal pembaruan dan bagian bernomor.
class LegalDocumentContent extends StatelessWidget {
  const LegalDocumentContent({super.key, required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final sections = document.sections;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last updated: ${AppFormat.longDate(document.updatedAt)}',
            style: AppTypography.bodySmall(color: AppPalette.profileMutedText),
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < sections.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == sections.length - 1 ? 0 : 24,
              ),
              child: _Section(number: i + 1, section: sections[i]),
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.number, required this.section});

  final int number;
  final LegalSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. ${section.title}',
          style: AppTypography.bodyMedium(
            color: AppPalette.textNeutralPrimary,
          ).copyWith(fontWeight: AppTypography.semiBold, height: 20 / 14),
        ),
        const SizedBox(height: 4),
        Text(
          section.body,
          style: AppTypography.bodyMedium(
            color: AppPalette.profileMutedText,
          ).copyWith(height: 24 / 14),
        ),
      ],
    );
  }
}
