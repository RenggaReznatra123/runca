import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/ui/typography.dart';

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.validator,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final String? Function(String?) validator;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.pagePadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: constraints.maxHeight < 500 ? 16 : 24),
                Text(
                  'Reset Password',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: AppTypography.medium,
                    color: AppPalette.textNeutralPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter your email to reset your password.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppPalette.textNeutralPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Email',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: AppTypography.medium,
                                color: AppPalette.textNeutralPrimary,
                              ),
                            ),
                            const TextSpan(
                              text: ' *',
                              style: TextStyle(color: AppPalette.textDanger),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autocorrect: false,
                        enableSuggestions: false,
                        enabled: !isLoading,
                        onFieldSubmitted: (_) {
                          if (!isLoading) onSubmit();
                        },
                        validator: validator,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: textTheme.bodyMedium?.copyWith(
                            color: AppPalette.textNeutralSecondary,
                          ),
                          prefixIcon: const Icon(Icons.mail_outline, size: 20),
                          filled: true,
                          fillColor: AppPalette.baseWhite,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppPalette.borderNeutral,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppPalette.textDanger,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppPalette.textDanger,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: isLoading ? null : onSubmit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppPalette.bgButtonPrimaryDefault,
                            foregroundColor: AppPalette.baseWhite,
                            disabledBackgroundColor: AppPalette.bgDisabled,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppPalette.baseWhite,
                                  ),
                                )
                              : const Text(
                                  'Email Verification',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ],
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
