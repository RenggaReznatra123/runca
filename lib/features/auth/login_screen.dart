import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/auth_cubit.dart';
import 'package:runca/features/auth/reset_password_screen.dart';
import 'package:runca/features/auth/sign_up_screen.dart';
import 'package:runca/features/success/success_screen.dart';
import 'package:runca/features/success/success_type.dart';
import 'package:runca/models/request/login_request.dart';
import 'package:runca/ui/color.dart';

import 'widgets/login_form_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _email = ValueNotifier<String>('');
  final _password = ValueNotifier<String>('');
  final _obscurePassword = ValueNotifier<bool>(true);

  String? _emailAuthError;
  String? _passwordAuthError;

  Listenable get _formListenable => Listenable.merge([_email, _password]);

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().init();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!_emailPattern.hasMatch(value.trim())) return 'Enter a valid email';
    return _emailAuthError;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Minimum 6 characters';
    return _passwordAuthError;
  }

  void _clearAuthErrors() {
    if (_emailAuthError == null && _passwordAuthError == null) return;

    setState(() {
      _emailAuthError = null;
      _passwordAuthError = null;
    });

    _formKey.currentState?.validate();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _emailAuthError = null;
      _passwordAuthError = null;
    });

    context.read<AuthCubit>().login(
      request: LoginRequest(
        email: _email.value.trim(),
        password: _password.value,
      ),
    );
  }

  void _goToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const SignUpScreen()),
    );
  }

  void _goToResetPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ResetPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthStateError) {
            setState(() {
              _emailAuthError = 'Email address not registered';
              _passwordAuthError = 'The password you entered is incorrect.';
            });

            _formKey.currentState?.validate();
          } else if (state is AuthStateSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) => const SuccessScreen(type: SuccessType.login),
              ),
              (route) => false,
            );
          }
        },
        child: SafeArea(
          child: LoginFormLayout(
            formKey: _formKey,
            formListenable: _formListenable,
            email: _email,
            password: _password,
            obscurePassword: _obscurePassword,
            validateEmail: _validateEmail,
            validatePassword: _validatePassword,
            onEmailChanged: (value) {
              _email.value = value;
              _clearAuthErrors();
            },
            onPasswordChanged: (value) {
              _password.value = value;
              _clearAuthErrors();
            },
            onSubmit: _submit,
            onForgotPassword: _goToResetPassword,
            onSignUp: _goToSignUp,
          ),
        ),
      ),
    );
  }
}
