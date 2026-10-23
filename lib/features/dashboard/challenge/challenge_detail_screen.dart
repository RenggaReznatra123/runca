import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/dashboard/activity/widgets/activity_state_view.dart';
import 'package:runca/features/dashboard/challenge/cubit/challenge_detail_cubit.dart';
import 'package:runca/features/dashboard/challenge/cubit/challenge_detail_state.dart';
import 'package:runca/features/dashboard/challenge/models/challenge_model.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import 'widgets/challenge_detail_header.dart';
import 'widgets/challenge_info_card.dart';
import 'widgets/challenge_requirement_list.dart';
import 'widgets/challenge_reward_row.dart';

class ChallengeDetailScreen extends StatelessWidget {
  const ChallengeDetailScreen({super.key, required this.challengeId});

  final String challengeId;

  static const double _sheetTop = 298;
  static const double _bannerHeight = 318;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChallengeDetailCubit(challengeId: challengeId),
      child: const _ChallengeDetailView(),
    );
  }
}

class _ChallengeDetailView extends StatelessWidget {
  const _ChallengeDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeDetailCubit, ChallengeDetailState>(
      builder: (context, state) {
        if (state.status == ChallengeDetailStatus.failure) {
          return _DetailFailure(onRetry: context.read<ChallengeDetailCubit>().load);
        }

        final detail = state.detail;
        if (state.status != ChallengeDetailStatus.success || detail == null) {
          return const _DetailLoading();
        }

        return _LoadedChallengeDetail(challenge: detail);
      },
    );
  }
}

class _DetailLoading extends StatelessWidget {
  const _DetailLoading();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppPalette.bgSurfaceNeutral,
        body: Stack(
          children: [
            const Center(
              child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
            ),
            _DetailBackButton(onBack: () => Navigator.of(context).maybePop()),
          ],
        ),
      ),
    );
  }
}

class _DetailFailure extends StatelessWidget {
  const _DetailFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppPalette.baseWhite,
        body: Stack(
          children: [
            Center(
              child: ActivityStateView(
                leading: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppPalette.bgSurfacePrimary,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: 104,
                    height: 104,
                    child: Icon(
                      Icons.cloud_off_outlined,
                      size: 44,
                      color: AppPalette.bgFillPrimary,
                    ),
                  ),
                ),
                title: 'Unable to load challenge',
                message:
                    'We couldn’t load this challenge. Check your connection and try again.',
                actionLabel: 'Try Again',
                onAction: onRetry,
              ),
            ),
            _DetailBackButton(onBack: () => Navigator.of(context).maybePop()),
          ],
        ),
      ),
    );
  }
}

class _DetailBackButton extends StatelessWidget {
  const _DetailBackButton({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 28,
      left: 20,
      child: Material(
        color: AppPalette.bgHoverWarning,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onBack,
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              Icons.chevron_left_rounded,
              size: 28,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadedChallengeDetail extends StatelessWidget {
  const _LoadedChallengeDetail({required this.challenge});

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppPalette.baseWhite,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: ChallengeDetailScreen._bannerHeight,
                      child: ChallengeDetailHeader(
                        challenge: challenge,
                        onBack: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: ChallengeDetailScreen._sheetTop,
                      ),
                      child: _DetailSheet(challenge: challenge),
                    ),
                  ],
                ),
              ),
            ),
            _JoinBar(
              onJoin: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Join Challenge belum tersedia.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  const _DetailSheet({required this.challenge});

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: const BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('About This Challenge'),
          const SizedBox(height: 8),
          Text(
            challenge.about,
            style: AppTypography.bodyMedium(
              color: AppPalette.textNeutralSecondary,
            ).copyWith(height: 24 / 14),
          ),
          const SizedBox(height: 20),
          ChallengeInfoCard(
            dateRange: AppFormat.dateRange(
              challenge.startDate,
              challenge.endDate,
            ),
            target: AppFormat.targetKm(challenge.targetKm),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Requirements'),
          const SizedBox(height: 10),
          ChallengeRequirementList(items: challenge.requirements),
          const SizedBox(height: 18),
          const _SectionTitle('Rewards'),
          const SizedBox(height: 16),
          ChallengeRewardRow(
            amount: AppFormat.thousands(challenge.rewardCoins),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.titleMedium(color: AppPalette.textNeutralPrimary),
    );
  }
}

class _JoinBar extends StatelessWidget {
  const _JoinBar({required this.onJoin});

  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: AppPalette.baseWhite,
        border: Border(top: BorderSide(color: AppPalette.borderNeutral)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onJoin,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppPalette.bgFillPrimary,
              foregroundColor: AppPalette.textWhitePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Join Challenge',
              style: AppTypography.bodyMedium(
                color: AppPalette.textWhitePrimary,
              ).copyWith(fontWeight: AppTypography.semiBold),
            ),
          ),
        ),
      ),
    );
  }
}
