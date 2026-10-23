import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/verify_email_cubit.dart';
import 'package:runca/features/auth/create_new_password_screen.dart';
import 'package:runca/features/auth/profile_setup_screen.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/custom_button.dart';
import 'package:runca/ui/custom_icons.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/ui/shared_view/otp_input.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/snackbar_extension.dart';

enum VerifyEmailPurpose { signUp, resetPassword }

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({
    super.key,
    required this.email,
    this.purpose = VerifyEmailPurpose.signUp,
  });

  final String email;
  final VerifyEmailPurpose purpose;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyEmailCubit()..start(),
      child: _VerifyEmailView(email: email, purpose: purpose),
    );
  }
}

class _VerifyEmailView extends StatefulWidget {
  const _VerifyEmailView({required this.email, required this.purpose});

  final String email;
  final VerifyEmailPurpose purpose;

  @override
  State<_VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<_VerifyEmailView> {
  static const String _verifyLabel = 'Verify & Continue';
  static const String _resendPrompt = "Haven't received the email?";
  static const String _resendLabel = 'Resend the code.';
  static const String _expiryPrefix = 'The code will expire in ';
  static const String _expiredLabel = 'The code has expired.';
  static const String _resentMessage = 'A new code has been sent.';
  static const double _tapTargetHeight = 40;

  final TextEditingController _codeController = TextEditingController();

  bool _isNavigating = false;

  bool get _isResetPassword =>
      widget.purpose == VerifyEmailPurpose.resetPassword;

  String get _title =>
      _isResetPassword ? 'Verify Your Email' : 'Verify Your Email';

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() {
    FocusScope.of(context).unfocus();

    context.read<VerifyEmailCubit>().verify(_codeController.text.trim());
  }

  void _resend() {
    _codeController.clear();
    context.read<VerifyEmailCubit>().resend();
    context.showSuccessSnackbar(_resentMessage);
  }

  void _goToNextStep() {
    if (!mounted || _isNavigating) return;

    _isNavigating = true;

    if (_isResetPassword) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => CreateNewPasswordScreen(email: widget.email),
        ),
      );
      return;
    }

    // Flow Sign Up tetap menuju Profile Setup.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const ProfileSetupScreen()),
      (route) => false,
    );
  }

  String _formatCountdown(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

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

    return Scaffold(
      backgroundColor: AppPalette.bg,
      appBar: AppBar(
        backgroundColor: AppPalette.bg,
        surfaceTintColor: AppPalette.baseBlack.withValues(alpha: 0),
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(CustomIcons.back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppPalette.borderNeutral),
        ),
      ),
      body: BlocListener<VerifyEmailCubit, VerifyEmailState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == VerifyEmailStatus.success) {
            context.showSuccessSnackbar(
              _isResetPassword ? 'OTP verified' : 'Email verified',
            );
            _goToNextStep();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePadding,
            ),
            child: BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
              builder: (context, state) {
                final isVerifying = state.status == VerifyEmailStatus.verifying;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimens.s24),
                    Text(
                      _title,
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
                          TextSpan(text: widget.email, style: emphasisStyle),
                          const TextSpan(
                            text:
                                '. Enter the code below to '
                                'continue.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.s32),
                    OtpInput(
                      controller: _codeController,
                      length: VerifyEmailCubit.codeLength,
                      hasError: state.status == VerifyEmailStatus.failure,
                      onChanged: (_) {
                        context.read<VerifyEmailCubit>().clearError();
                      },
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
                          onPressed: isVerifying ? null : _resend,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.s4,
                            ),
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
                      listenable: _codeController,
                      builder: (context, _) {
                        final canSubmit =
                            _codeController.text.length ==
                                VerifyEmailCubit.codeLength &&
                            !isVerifying;

                        return CustomButton(
                          text: _verifyLabel,
                          isLoading: isVerifying,
                          onPressed: canSubmit ? _verify : null,
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
                                  text: _formatCountdown(state.secondsLeft),
                                  style: accentStyle,
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: AppDimens.s16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
