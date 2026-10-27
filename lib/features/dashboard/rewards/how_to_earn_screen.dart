import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'cubit/how_to_earn_cubit.dart';
import 'cubit/how_to_earn_state.dart';
import 'widgets/earn_info_box.dart';
import 'widgets/earn_method_card.dart';
import 'widgets/rewards_error_view.dart';

/// Penjelasan cara mendapatkan PlaCoins.
class HowToEarnScreen extends StatelessWidget {
  const HowToEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HowToEarnCubit(),
      child: const _HowToEarnView(),
    );
  }
}

class _HowToEarnView extends StatelessWidget {
  const _HowToEarnView();

  void _showUnavailable(BuildContext context, String page) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$page belum tersedia.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.baseWhite,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 44,
                      ),
                      color: AppPalette.textNeutralPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'How to earn PlaCoins',
                      style: AppTypography.titleMedium(
                        color: AppPalette.textNeutralPrimary,
                      ).copyWith(fontWeight: AppTypography.medium),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HowToEarnCubit, HowToEarnState>(
                builder: (context, state) => _buildBody(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HowToEarnState state) {
    final cubit = context.read<HowToEarnCubit>();

    if (state.status == HowToEarnStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    if (state.status == HowToEarnStatus.failure) {
      return RewardsErrorView(
        title: 'Unable to load this page',
        onRetry: cubit.loadMethods,
      );
    }

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complete activities, stay consistent, and earn PlaCoins!',
            style: AppTypography.bodyLarge(color: AppPalette.profileMutedText),
          ),
          const SizedBox(height: 12),
          for (final method in state.methods) ...[
            EarnMethodCard(
              method: method,
              onTap: () => _showUnavailable(context, method.title),
            ),
            const SizedBox(height: 12),
          ],
          const EarnInfoBox(
            message:
                'Points are only earned for eligible activities and may take '
                'up to 24 hours to be added to your balance.',
          ),
        ],
      ),
    );
  }
}
