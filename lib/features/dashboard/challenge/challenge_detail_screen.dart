import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'models/challenge_model.dart';
import 'widgets/challenge_detail_header.dart';
import 'widgets/challenge_info_card.dart';
import 'widgets/challenge_requirement_list.dart';
import 'widgets/challenge_reward_row.dart';

class ChallengeDetailScreen extends StatelessWidget {
  const ChallengeDetailScreen({super.key, required this.challenge});

  final ChallengeModel challenge;

  // Banner lebih tinggi 20 dari bagian yang terlihat, karena 20 dp
  // paling bawah tertutup lembar putih yang melengkung.
  static const double _sheetTop = 298;
  static const double _bannerHeight = 318;

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
                      height: _bannerHeight,
                      child: ChallengeDetailHeader(
                        challenge: challenge,
                        onBack: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: _sheetTop),
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

  final ChallengeModel challenge;

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
            dateRange: challenge.dateRange,
            target: challenge.target,
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Requirements'),
          const SizedBox(height: 10),
          ChallengeRequirementList(items: challenge.requirements),
          const SizedBox(height: 18),
          const _SectionTitle('Rewards'),
          const SizedBox(height: 16),
          ChallengeRewardRow(amount: challenge.formattedReward),
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
          height: 48,
          child: ElevatedButton(
            onPressed: onJoin,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              elevation: 0,
              backgroundColor: AppPalette.bgFillPrimary,
              foregroundColor: AppPalette.textButtonPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: AppTypography.titleSmall().copyWith(
                fontWeight: AppTypography.medium,
              ),
            ),
            child: const Text('Join Challenge'),
          ),
        ),
      ),
    );
  }
}