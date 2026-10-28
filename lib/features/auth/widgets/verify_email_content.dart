import 'package:flutter/material.dart';
import 'package:runca/features/auth/cubit/verify_email_cubit.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/custom_button.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/ui/shared_view/otp_input.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

class VerifyEmailContent extends StatelessWidget {
  const VerifyEmailContent({
    required this.email,
    required this.codeController,
    required this.state,
    required this.onCodeChanged,
    required this.onResend,
    required this.onVerify,
    super.key,
  });

  static const String _verifyLabel = 'Verify & Continue';
  static const String _resendPrompt = "Haven't received the email?";
  static const String _resendLabel = 'Resend the code.';
  static const String _expiryPrefix = 'The code will expire in ';
  static const String _expiredLabel = 'The code has expired.';
  static const double _tapTargetHeight = 40;

  final String email;
  final TextEditingController codeController;
  final VerifyEmailState state;
  final ValueChanged<String> onCodeChanged;
  final VoidCallback onResend;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyStyle = textTheme.bodyMedium?.copyWith(
      color: AppPalette.textNeutralPrimary,
    );
    final emphasisStyle = bodyStyle?.copyWith(
      fontWeight: AppTypography.semiBold,
    );
    final accentStyle = emphasisStyle?.copyWith(
      color: theme.colorScheme.primary,
    );
    final isVerifying = state.status == VerifyEmailStatus.verifying;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.s24),
          Text(
            'Verify Your Email',
            style: textTheme.headlineSmall?.copyWith(
              height: 1.2,
              fontWeight: AppTypography.medium,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
          const SizedBox(height: AppDimens.s12),
          Text.rich(
            TextSpan(
              style: bodyStyle,
              children: [
                TextSpan(
                  text:
                      "We've sent a "
                      '${VerifyEmailCubit.codeLength}-digit '
                      'verification code to ',
                ),
                TextSpan(text: email, style: emphasisStyle),
                const TextSpan(text: '. Enter the code below to continue.'),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.s32),
          OtpInput(
            controller: codeController,
            length: VerifyEmailCubit.codeLength,
            hasError: state.status == VerifyEmailStatus.failure,
            onChanged: onCodeChanged,
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: AppDimens.s8),
            Text(
              state.errorMessage!,
              style: textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: AppDimens.s32),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(_resendPrompt, style: bodyStyle),
              TextButton(
                onPressed: isVerifying ? null : onResend,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.s4),
                  minimumSize: const Size(0, _tapTargetHeight),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: AppTypography.bodyMedium().copyWith(
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                child: const Text(_resendLabel),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.s16),
          ListenableBuilder(
            listenable: codeController,
            builder: (context, _) {
              final canSubmit =
                  codeController.text.length == VerifyEmailCubit.codeLength &&
                  !isVerifying;

              return CustomButton(
                text: _verifyLabel,
                isLoading: isVerifying,
                onPressed: canSubmit ? onVerify : null,
              );
            },
          ),
          const SizedBox(height: AppDimens.s32),
          Text.rich(
            textAlign: TextAlign.center,
            state.isExpired
                ? TextSpan(text: _expiredLabel, style: bodyStyle)
                : TextSpan(
                    style: bodyStyle,
                    children: [
                      const TextSpan(text: _expiryPrefix),
                      TextSpan(
                        text: AppFormat.countdownMinutesSeconds(
                          state.secondsLeft,
                        ),
                        style: accentStyle,
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: AppDimens.s16),
        ],
      ),
    );
  }
}
