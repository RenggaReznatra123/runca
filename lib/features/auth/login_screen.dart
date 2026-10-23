import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/features/auth/cubit/auth_cubit.dart';
import 'package:runca/features/auth/sign_up_screen.dart';
import 'package:runca/models/request/login_request.dart';
import 'package:runca/features/auth/reset_password_screen.dart';
import 'package:runca/features/success/success_screen.dart';
import 'package:runca/features/success/success_type.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/custom_button.dart';
import 'package:runca/ui/custom_icons.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';
import 'package:runca/ui/shared_view/or_divider.dart';
import 'package:runca/ui/typography.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const double _horizontalPadding = 20;
  static const double _topSpacing = 24;
  static const double _titleFontSize = 20;
  static const double _subtitleFontSize = 12;
  static const double _fieldSpacing = 12;
  static const double _sectionSpacing = 16;
  static const double _buttonHeight = 48;
  static const double _googleIconSize = 18;
  static const double _footerFontSize = 12;
  static const double _tapTargetHeight = 40;

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
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!_emailPattern.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return _emailAuthError;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Minimum 6 characters';
    }

    return _passwordAuthError;
  }

  void _clearAuthErrors() {
    if (_emailAuthError == null && _passwordAuthError == null) {
      return;
    }

    setState(() {
      _emailAuthError = null;
      _passwordAuthError = null;
    });

    _formKey.currentState?.validate();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: _topSpacing),

                        Text(
                          'Welcome Back!',
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            fontSize: _titleFontSize,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: AppPalette.textNeutralPrimary,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Sign in to continue tracking your runs and challenge progress.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: _subtitleFontSize,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                            color: AppPalette.textNeutralPrimary,
                          ),
                        ),

                        const SizedBox(height: 26),

                        CustomTextFormField(
                          label: 'Email',
                          hint: 'Enter your email',
                          isRequired: true,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(CustomIcons.email),
                          validator: _validateEmail,
                          onChanged: (value) {
                            _email.value = value;
                            _clearAuthErrors();
                          },
                        ),

                        const SizedBox(height: _fieldSpacing),

                        ValueListenableBuilder<bool>(
                          valueListenable: _obscurePassword,
                          builder: (context, obscure, _) {
                            return CustomTextFormField(
                              label: 'Password',
                              hint: 'Enter your password',
                              isRequired: true,
                              obscureText: obscure,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              prefixIcon: const Icon(CustomIcons.password),
                              suffixIcon: IconButton(
                                visualDensity: VisualDensity.compact,
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  obscure
                                      ? CustomIcons.visibilityOff
                                      : CustomIcons.visibility,
                                  size: 18,
                                ),
                                onPressed: () {
                                  _obscurePassword.value = !obscure;
                                },
                              ),
                              validator: _validatePassword,
                              onChanged: (value) {
                                _password.value = value;
                                _clearAuthErrors();
                              },
                              onFieldSubmitted: (_) => _submit(),
                            );
                          },
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const ResetPasswordScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 4,
                              ),
                              minimumSize: const Size(0, _tapTargetHeight),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              textStyle: AppTypography.bodySmall().copyWith(
                                fontSize: _footerFontSize,
                              ),
                            ),
                            child: const Text('Forgot Password?'),
                          ),
                        ),

                        const SizedBox(height: _sectionSpacing),

                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthStateLoading;

                            return ListenableBuilder(
                              listenable: _formListenable,
                              builder: (context, _) {
                                final canSubmit =
                                    _email.value.trim().isNotEmpty &&
                                    _password.value.isNotEmpty &&
                                    !isLoading;

                                return SizedBox(
                                  height: _buttonHeight,
                                  child: CustomButton(
                                    text: 'Log In',
                                    isLoading: isLoading,
                                    onPressed: canSubmit ? _submit : null,
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: _sectionSpacing),

                        const OrDivider(),

                        const SizedBox(height: _sectionSpacing),

                        SizedBox(
                          height: _buttonHeight,
                          child: CustomButton(
                            text: 'Continue with Google',
                            isOutlined: true,
                            icon: SvgPicture.asset(
                              AppAssets.googleLogo,
                              width: _googleIconSize,
                              height: _googleIconSize,
                            ),
                            onPressed: () {},
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Don't have an account?",
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: _footerFontSize,
                                  color: AppPalette.textNeutralSecondary,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _goToSignUp,
                              style: TextButton.styleFrom(
                                foregroundColor: AppPalette.textNeutralPrimary,
                                textStyle: AppTypography.bodySmall().copyWith(
                                  fontSize: _footerFontSize,
                                  fontWeight: AppTypography.medium,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.s4,
                                ),
                                minimumSize: const Size(0, _tapTargetHeight),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
