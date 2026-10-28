import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/dashboard/activity/widgets/activity_state_view.dart';
import 'package:runca/features/dashboard/challenge/cubit/challenge_detail_cubit.dart';
import 'package:runca/features/dashboard/challenge/cubit/challenge_detail_state.dart';
import 'package:runca/ui/color.dart';

import 'widgets/challenge_detail_loaded_view.dart';

class ChallengeDetailScreen extends StatelessWidget {
  const ChallengeDetailScreen({super.key, required this.challengeId});

  final String challengeId;

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
          return _DetailFailure(
            onRetry: context.read<ChallengeDetailCubit>().load,
          );
        }

        final detail = state.detail;
        if (state.status != ChallengeDetailStatus.success || detail == null) {
          return const _DetailLoading();
        }

        return ChallengeDetailLoadedView(challenge: detail);
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
        statusBarColor: AppPalette.transparent,
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
        statusBarColor: AppPalette.transparent,
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
