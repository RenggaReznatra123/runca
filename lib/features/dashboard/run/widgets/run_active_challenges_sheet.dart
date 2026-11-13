import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/rewards/widgets/rewards_error_view.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/empty_view.dart';
import 'package:runca/ui/typography.dart';

import '../cubit/run_active_challenges_cubit.dart';
import '../cubit/run_active_challenges_state.dart';
import 'run_active_challenge_item.dart';

/// Sheet "Active Challenges" di layar Setup lari. Mengembalikan ID challenge
/// yang ditekan, atau null kalau ditutup.
class RunActiveChallengesSheet extends StatelessWidget {
  const RunActiveChallengesSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.transparent,
      barrierColor: AppPalette.bgBackdrop,
      builder: (_) => BlocProvider(
        create: (_) => RunActiveChallengesCubit(),
        child: const RunActiveChallengesSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppPalette.baseWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 108,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppPalette.profileSoftBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const _Header(),
                const SizedBox(height: 16),
                Flexible(
                  child:
                      BlocBuilder<
                        RunActiveChallengesCubit,
                        RunActiveChallengesState
                      >(builder: _buildBody),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RunActiveChallengesState state) {
    switch (state.status) {
      case RunActiveChallengesStatus.loading:
        return const SizedBox(
          height: 180,
          child: Center(
            child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
          ),
        );
      case RunActiveChallengesStatus.failure:
        return SizedBox(
          height: 360,
          child: RewardsErrorView(
            title: 'Unable to load challenges',
            onRetry: context.read<RunActiveChallengesCubit>().load,
          ),
        );
      case RunActiveChallengesStatus.success:
        break;
    }

    final challenges = state.challenges;

    // ASUMSI: belum ada desain kosong di Figma.
    if (challenges.isEmpty) {
      return const SizedBox(
        height: 200,
        child: EmptyView(message: 'No active challenges yet.'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: challenges.length,
      separatorBuilder: (_, _) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final challenge = challenges[index];

        return RunActiveChallengeItem(
          key: ValueKey(challenge.id),
          progress: challenge,
          onTap: () => Navigator.of(context).pop(challenge.id),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Challenges',
                style: AppTypography.titleMedium(
                  color: AppPalette.profileDarkText,
                ).copyWith(fontWeight: AppTypography.semiBold),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your progress and keep working toward your goals.',
                style: AppTypography.bodySmall(
                  color: AppPalette.profileMutedText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: const Icon(
            Icons.close_rounded,
            size: 24,
            color: AppPalette.profileMutedIcon,
          ),
        ),
      ],
    );
  }
}
