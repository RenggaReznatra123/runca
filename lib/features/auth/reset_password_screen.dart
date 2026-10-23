import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/verify_email_screen.dart';
import 'package:runca/features/auth/cubit/reset_password_cubit.dart';
import 'package:runca/features/auth/cubit/reset_password_state.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/ui/typography.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitEmail(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<ResetPasswordCubit>().requestPasswordReset(
      _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppPalette.bg,
            appBar: AppBar(
              backgroundColor: AppPalette.bg,
              surfaceTintColor: AppPalette.baseBlack.withValues(alpha: 0),
              scrolledUnderElevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(height: 1, color: AppPalette.borderNeutral),
              ),
            ),
            body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
              listener: (context, state) {
                if (state.status == ResetPasswordStatus.success) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => VerifyEmailScreen(
                        email: _emailController.text.trim(),
                        purpose: VerifyEmailPurpose.resetPassword,
                      ),
                    ),
                  );
                } else if (state.status == ResetPasswordStatus.failure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          state.errorMessage ??
                              'Gagal mengirim email reset. Silakan coba lagi.',
                        ),
                      ),
                    );
                }
              },
              builder: (context, state) {
                final isLoading = state.status == ResetPasswordStatus.loading;

                final theme = Theme.of(context);
                final textTheme = theme.textTheme;

                return SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.pagePadding,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: constraints.maxHeight < 500 ? 16 : 24,
                            ),
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
                              key: _formKey,
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
                                            color:
                                                AppPalette.textNeutralPrimary,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: AppPalette.textDanger,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    enabled: !isLoading,
                                    onFieldSubmitted: (_) {
                                      if (!isLoading) {
                                        _submitEmail(context);
                                      }
                                    },
                                    validator: (value) {
                                      final email = value?.trim() ?? '';

                                      if (email.isEmpty) {
                                        return 'Email wajib diisi.';
                                      }

                                      if (!_emailPattern.hasMatch(email)) {
                                        return 'Masukkan alamat email yang valid.';
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter your email',
                                      hintStyle: textTheme.bodyMedium?.copyWith(
                                        color: AppPalette.textNeutralSecondary,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.mail_outline,
                                        size: 20,
                                      ),
                                      filled: true,
                                      fillColor: AppPalette.baseWhite,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                      onPressed: isLoading
                                          ? null
                                          : () => _submitEmail(context),
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            AppPalette.bgButtonPrimaryDefault,
                                        foregroundColor: AppPalette.baseWhite,
                                        disabledBackgroundColor:
                                            AppPalette.bgDisabled,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
              },
            ),
          );
        },
      ),
    );
  }
}
