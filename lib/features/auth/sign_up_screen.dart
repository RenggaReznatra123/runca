import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/sign_up_cubit.dart';
import 'package:runca/features/auth/login_screen.dart';
import 'package:runca/features/auth/verify_email_screen.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'widgets/sign_up_form_layout.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _email = ValueNotifier<String>('');
  final _password = ValueNotifier<String>('');
  final _confirmPassword = ValueNotifier<String>('');
  final _obscurePassword = ValueNotifier<bool>(true);
  final _obscureConfirmPassword = ValueNotifier<bool>(true);
  final _acceptedTerms = ValueNotifier<bool>(false);

  Listenable get _formListenable =>
      Listenable.merge([_email, _password, _confirmPassword, _acceptedTerms]);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    _acceptedTerms.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!_emailPattern.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Minimum 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }

    if (value != _password.value) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    context.read<SignUpCubit>().signUp(
      email: _email.value.trim(),
      password: _password.value,
    );
  }

  void _goToLogin() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  void _goToVerifyEmail() {
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VerifyEmailScreen(email: _email.value.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          switch (state) {
            case SignUpStateError():
              context.showErrorSnackbar(state.message);
            case SignUpStateSuccess():
              _goToVerifyEmail();
            case SignUpStateLoading():
            case SignUpInitial():
              break;
          }
        },
        child: SafeArea(
          child: SignUpFormLayout(
            formKey: _formKey,
            formListenable: _formListenable,
            email: _email,
            password: _password,
            confirmPassword: _confirmPassword,
            obscurePassword: _obscurePassword,
            obscureConfirmPassword: _obscureConfirmPassword,
            acceptedTerms: _acceptedTerms,
            validateEmail: _validateEmail,
            validatePassword: _validatePassword,
            validateConfirmPassword: _validateConfirmPassword,
            onSubmit: _submit,
            onLogin: _goToLogin,
          ),
        ),
      ),
    );
  }
}
