import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/features/dashboard/dashboard_screen.dart';
import 'package:runca/features/success/cubit/success_cubit.dart';
import 'package:runca/features/success/success_type.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.type});

  final SuccessType type;

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => SuccessCubit()..start(),
      child: BlocListener<SuccessCubit, SuccessState>(
        listener: (context, state) {
          if (state is SuccessCompleted) {
            _goToHome(context);
          }
        },
        child: PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: AppPalette.bg,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final illustrationWidth = (constraints.maxWidth * 0.85).clamp(
                    0.0,
                    520.0,
                  );

                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppAssets.successIllustration,
                            width: illustrationWidth,
                            fit: BoxFit.contain,
                            excludeFromSemantics: true,
                          ),
                          const SizedBox(height: 48),
                          Text(
                            type.title,
                            textAlign: TextAlign.center,
                            style: textTheme.headlineSmall?.copyWith(
                              height: 1.2,
                              fontWeight: AppTypography.medium,
                              color: AppPalette.textNeutralPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
