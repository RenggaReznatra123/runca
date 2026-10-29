import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/rewards/widgets/rewards_error_view.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_page_header.dart';

import 'cubit/legal_document_cubit.dart';
import 'cubit/legal_document_state.dart';
import 'models/help_model.dart';
import 'widgets/legal_document_content.dart';

/// Halaman Privacy Policy atau Terms of Service (satu halaman, dua jenis).
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.type});

  final LegalDocumentType type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LegalDocumentCubit(type: type),
      child: _LegalDocumentView(title: type.label),
    );
  }
}

class _LegalDocumentView extends StatelessWidget {
  const _LegalDocumentView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.baseWhite,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(title: title),
            const Divider(height: 1, color: AppPalette.borderNeutral),
            Expanded(
              child: BlocBuilder<LegalDocumentCubit, LegalDocumentState>(
                builder: _buildBody,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LegalDocumentState state) {
    if (state.status == LegalDocumentLoadStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    final document = state.document;

    if (state.status == LegalDocumentLoadStatus.failure || document == null) {
      return RewardsErrorView(
        title: 'Unable to load this page',
        onRetry: context.read<LegalDocumentCubit>().loadDocument,
      );
    }

    return LegalDocumentContent(document: document);
  }
}
