import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runca/features/dashboard/challenge/models/challenge_model.dart';
import 'package:runca/features/dashboard/challenge/widgets/challenge_detail_header.dart';
import 'package:runca/features/dashboard/challenge/widgets/challenge_detail_sheet.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/snackbar_extension.dart';

class ChallengeDetailLoadedView extends StatelessWidget {
  const ChallengeDetailLoadedView({super.key, required this.challenge});

  final ChallengeDetail challenge;

  static const double _sheetTop = 298;
  static const double _bannerHeight = 318;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppPalette.transparent,
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
                      child: ChallengeDetailSheet(challenge: challenge),
                    ),
                  ],
                ),
              ),
            ),
            _JoinBar(
              onJoin: () => context.showUnavailableSnackbar(
                'Join Challenge',
                hideCurrent: false,
              ),
            ),
          ],
        ),
      ),
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
