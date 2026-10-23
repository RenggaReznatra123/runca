import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/features/auth/login_screen.dart';
import 'package:runca/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/custom_button.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/ui/typography.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
            );
          }
        },
        child: const Scaffold(body: _OnboardingBody()),
      ),
    );
  }
}

class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody();

  static const String _title = 'Track Your Runs, Hit\nYour Goals';
  static const String _subtitle =
      'Keep track of every run, stay on pace, and make every step '
      'count toward your goals.';
  static const String _getStartedLabel = 'Get Started';
  static const String _hasAccountLabel = 'Already have an account?';
  static const String _loginLabel = 'Log In';

  static const double _logoHeight = 56;
  static const double _titleLineHeight = 1.15;
  static const double _tapTargetHeight = 44;
  static const double _gradientStart = 0.45;
  static const double _gradientEndAlpha = 0.85;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image.
        Image.asset(
          AppAssets.onboardingBackground,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),

        // Dark gradient to keep the text readable.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [_gradientStart, 1],
              colors: [
                AppPalette.baseBlack.withValues(alpha: 0),
                AppPalette.baseBlack.withValues(alpha: _gradientEndAlpha),
              ],
            ),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppDimens.s16),

                // Plarita logo.
                Image.asset(
                  AppAssets.onboardingLogo,
                  height: _logoHeight,
                  semanticLabel: 'Plarita logo',
                ),

                const Spacer(),

                // Heading.
                Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    height: _titleLineHeight,
                    color: AppPalette.textWhitePrimary,
                    fontWeight: AppTypography.medium,
                  ),
                ),

                const SizedBox(height: AppDimens.s12),

                // Description.
                Text(
                  _subtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppPalette.textWhiteSecondary,
                  ),
                ),

                const SizedBox(height: AppDimens.s24),

                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    final isLoading = state is OnboardingLoading;

                    return Column(
                      children: [
                        CustomButton(
                          text: _getStartedLabel,
                          backgroundColor: AppPalette.bgButtonPrimaryDefault,
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () => context
                                    .read<OnboardingCubit>()
                                    .getStarted(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _hasAccountLabel,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppPalette.textWhitePrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context
                                        .read<OnboardingCubit>()
                                        .skipToLogin(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.s4,
                                ),
                                minimumSize: const Size(0, _tapTargetHeight),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                _loginLabel,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppPalette.textWhitePrimary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppPalette.textWhitePrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppDimens.s16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
