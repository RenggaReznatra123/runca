import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/features/onboarding/onboarding_screen.dart';
import 'package:runca/features/splash/cubit/splash_cubit.dart';
import 'package:runca/ui/color.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const double _logoWidth = 250;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..start(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          debugPrint('Splash state: $state');

          if (state is SplashCompleted) {
            debugPrint('Navigasi ke Onboarding dimulai');

            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppPalette.bgPrimary,
          body: Center(
            child: Image.asset(
              AppAssets.splashLogo,
              width: _logoWidth,
              semanticLabel: 'App logo',
            ),
          ),
        ),
      ),
    );
  }
}
