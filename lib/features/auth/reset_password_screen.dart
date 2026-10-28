import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/reset_password_cubit.dart';
import 'package:runca/features/auth/cubit/reset_password_state.dart';
import 'package:runca/features/auth/verify_email_screen.dart';
import 'package:runca/ui/color.dart';

import 'widgets/reset_password_form.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) return 'Email wajib diisi.';
    if (!_emailPattern.hasMatch(email)) {
      return 'Masukkan alamat email yang valid.';
    }

    return null;
  }

  void _submitEmail(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

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

                return ResetPasswordForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  isLoading: isLoading,
                  validator: _validateEmail,
                  onSubmit: () => _submitEmail(context),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
