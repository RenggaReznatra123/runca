import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({
    required this.currentStep,
    required this.isSubmitting,
    required this.canContinue,
    required this.onBack,
    required this.onContinue,
    required this.progress,
    required this.stepContent,
    super.key,
  });

  final int currentStep;
  final bool isSubmitting;
  final bool canContinue;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final Widget progress;
  final Widget stepContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppPalette.bg,
        surfaceTintColor: AppPalette.baseBlack.withValues(alpha: 0),
        elevation: 0,
        toolbarHeight: 64,
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppPalette.iconNeutralPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: progress,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: stepContent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: canContinue && !isSubmitting
                          ? onContinue
                          : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppPalette.bgButtonPrimaryDefault,
                        disabledBackgroundColor: AppPalette.bgDisabled,
                        foregroundColor: AppPalette.textButtonPrimary,
                        disabledForegroundColor: AppPalette.textDisabled,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              currentStep == 3
                                  ? 'Complete Profile'
                                  : 'Continue',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
