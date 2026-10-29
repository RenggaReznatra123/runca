import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/rewards/widgets/rewards_error_view.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_page_header.dart';
import 'package:runca/ui/shared_view/empty_view.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/faq_cubit.dart';
import 'cubit/faq_state.dart';
import 'models/help_model.dart';
import 'widgets/faq_category_chips.dart';
import 'widgets/faq_item_card.dart';
import 'widgets/faq_search_field.dart';
import 'widgets/faq_support_card.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => FaqCubit(), child: const _FaqView());
  }
}

class _FaqView extends StatelessWidget {
  const _FaqView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FaqCubit>();

    return Scaffold(
      backgroundColor: AppPalette.baseWhite,
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'FAQ'),
            const Divider(height: 1, color: AppPalette.borderNeutral),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FaqSearchField(onChanged: cubit.search),
            ),
            const SizedBox(height: 16),
            BlocSelector<FaqCubit, FaqState, FaqFilter>(
              selector: (state) => state.filter,
              builder: (context, filter) => FaqCategoryChips(
                selected: filter,
                onChanged: cubit.selectFilter,
              ),
            ),
            Expanded(
              child: BlocBuilder<FaqCubit, FaqState>(builder: _buildBody),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FaqState state) {
    final cubit = context.read<FaqCubit>();

    if (state.status == FaqLoadStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    if (state.status == FaqLoadStatus.failure) {
      return RewardsErrorView(
        title: 'Unable to load FAQ',
        onRetry: cubit.loadFaqs,
      );
    }

    return ListView(
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        if (state.items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: EmptyView(message: 'No help articles found.'),
          ),
        for (final item in state.items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FaqItemCard(
              key: ValueKey(item.id),
              item: item,
              expanded: item.id == state.expandedId,
              onTap: () => cubit.toggleItem(item.id),
            ),
          ),
        // 12 (jarak kartu) + 18 = 30, sesuai jarak di Figma.
        const SizedBox(height: 18),
        FaqSupportCard(
          // Halaman Contact Support belum ada desainnya.
          onContactSupport: () => context.showUnavailableSnackbar(
            'Contact Support',
            duration: const Duration(seconds: 2),
          ),
        ),
      ],
    );
  }
}
