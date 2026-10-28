import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/verify_email_cubit.dart';
import 'package:runca/features/auth/create_new_password_screen.dart';
import 'package:runca/features/auth/profile_setup_screen.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/custom_icons.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'widgets/verify_email_content.dart';

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
  static const String _resentMessage = 'A new code has been sent.';

  final TextEditingController _codeController = TextEditingController();

  bool _isNavigating = false;

  bool get _isResetPassword =>
      widget.purpose == VerifyEmailPurpose.resetPassword;

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

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const ProfileSetupScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
            builder: (context, state) {
              return VerifyEmailContent(
                email: widget.email,
                codeController: _codeController,
                state: state,
                onCodeChanged: (_) {
                  context.read<VerifyEmailCubit>().clearError();
                },
                onResend: _resend,
                onVerify: _verify,
              );
            },
          ),
        ),
      ),
    );
  }
}
