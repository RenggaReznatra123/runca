import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/features/auth/cubit/sign_up_cubit.dart';
import 'package:runca/features/auth/login_screen.dart';
import 'package:runca/features/auth/verify_email_screen.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/custom_button.dart';
import 'package:runca/ui/custom_icons.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';
import 'package:runca/ui/shared_view/or_divider.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/snackbar_extension.dart';

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
  static const String _title = 'Create Your Account';
  static const String _subtitle =
      'Sign up to start tracking your runs and building healthy habits.';

  static const String _emailLabel = 'Email';
  static const String _emailHint = 'Enter your email';
  static const String _passwordLabel = 'Password';
  static const String _passwordHint = 'Enter your password';
  static const String _confirmPasswordLabel = 'Confirm Password';
  static const String _signUpLabel = 'Sign Up';
  static const String _googleLabel = 'Continue with Google';
  static const String _hasAccountLabel = 'Already have an account?';
  static const String _loginLabel = 'Login';

  static const double _horizontalPadding = 20;
  static const double _titleFontSize = 20;
  static const double _subtitleFontSize = 12;
  static const double _googleIconSize = 18;
  static const double _tapTargetHeight = 40;
  static const double _buttonHeight = 40;

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
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

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
    final textTheme = Theme.of(context).textTheme;

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 780;

              final topSpacing = compact ? 8.0 : 12.0;
              final headingGap = compact ? 2.0 : 4.0;
              final descriptionGap = compact ? 18.0 : 20.0;
              final fieldSpacing = compact ? 7.0 : 10.0;
              final termsGap = compact ? 8.0 : 12.0;
              final buttonGap = compact ? 12.0 : 16.0;
              final footerGap = compact ? 4.0 : 8.0;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: topSpacing),

                      Text(
                        _title,
                        style: textTheme.headlineSmall?.copyWith(
                          fontSize: _titleFontSize,
                          height: 1.2,
                          fontWeight: AppTypography.medium,
                          color: AppPalette.textNeutralPrimary,
                        ),
                      ),

                      SizedBox(height: headingGap),

                      Text(
                        _subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: _subtitleFontSize,
                          height: 1.4,
                          color: AppPalette.textNeutralPrimary,
                        ),
                      ),

                      SizedBox(height: descriptionGap),

                      CustomTextFormField(
                        label: _emailLabel,
                        hint: _emailHint,
                        isRequired: true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(CustomIcons.email),
                        validator: _validateEmail,
                        onChanged: (value) => _email.value = value,
                      ),

                      SizedBox(height: fieldSpacing),

                      _PasswordField(
                        label: _passwordLabel,
                        hint: _passwordHint,
                        obscure: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        validator: _validatePassword,
                        onChanged: (value) => _password.value = value,
                      ),

                      SizedBox(height: fieldSpacing),

                      _PasswordField(
                        label: _confirmPasswordLabel,
                        hint: _passwordHint,
                        obscure: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        validator: _validateConfirmPassword,
                        onChanged: (value) => _confirmPassword.value = value,
                        onFieldSubmitted: (_) => _submit(),
                      ),

                      SizedBox(height: termsGap),

                      _TermsCheckbox(accepted: _acceptedTerms),

                      SizedBox(height: buttonGap),

                      BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) {
                          final isLoading = state is SignUpStateLoading;

                          return ListenableBuilder(
                            listenable: _formListenable,
                            builder: (context, _) {
                              final canSubmit =
                                  _email.value.trim().isNotEmpty &&
                                  _password.value.isNotEmpty &&
                                  _confirmPassword.value.isNotEmpty &&
                                  _acceptedTerms.value &&
                                  !isLoading;

                              return SizedBox(
                                height: _buttonHeight,
                                child: CustomButton(
                                  text: _signUpLabel,
                                  isLoading: isLoading,
                                  onPressed: canSubmit ? _submit : null,
                                ),
                              );
                            },
                          );
                        },
                      ),

                      SizedBox(height: footerGap),

                      const OrDivider(),

                      SizedBox(height: footerGap),

                      SizedBox(
                        height: _buttonHeight,
                        child: CustomButton(
                          text: _googleLabel,
                          isOutlined: true,
                          icon: SvgPicture.asset(
                            AppAssets.googleLogo,
                            width: _googleIconSize,
                            height: _googleIconSize,
                          ),
                          onPressed: () {},
                        ),
                      ),

                      SizedBox(height: compact ? 0 : 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              _hasAccountLabel,
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                color: AppPalette.textNeutralSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _goToLogin,
                            style: TextButton.styleFrom(
                              foregroundColor: AppPalette.textNeutralPrimary,
                              textStyle: AppTypography.bodySmall().copyWith(
                                fontSize: 12,
                                fontWeight: AppTypography.medium,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.s4,
                              ),
                              minimumSize: const Size(0, _tapTargetHeight),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(_loginLabel),
                          ),
                        ],
                      ),
                    ],
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

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.hint,
    required this.obscure,
    required this.validator,
    required this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final String label;
  final String hint;
  final ValueNotifier<bool> obscure;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  static const double _iconSize = 18;
  static const double _suffixTapSize = 40;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscure,
      builder: (context, isObscured, _) {
        return CustomTextFormField(
          label: label,
          hint: hint,
          isRequired: true,
          obscureText: isObscured,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: textInputAction,
          prefixIcon: const Icon(CustomIcons.password),
          suffixIcon: IconButton(
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(
              minWidth: _suffixTapSize,
              minHeight: _suffixTapSize,
            ),
            padding: EdgeInsets.zero,
            icon: Icon(
              isObscured ? CustomIcons.visibilityOff : CustomIcons.visibility,
              size: _iconSize,
            ),
            onPressed: () => obscure.value = !isObscured,
          ),
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
        );
      },
    );
  }
}

class _TermsCheckbox extends StatefulWidget {
  const _TermsCheckbox({required this.accepted});

  final ValueNotifier<bool> accepted;

  @override
  State<_TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<_TermsCheckbox> {
  static const String _prefix = 'I agree to the ';
  static const String _termsLabel = 'Terms & Conditions';
  static const String _joiner = ' and ';
  static const String _privacyLabel = 'Privacy Policy';
  static const String _suffix = '.';

  late final TapGestureRecognizer _termsTap = TapGestureRecognizer()
    ..onTap = _openTerms;

  late final TapGestureRecognizer _privacyTap = TapGestureRecognizer()
    ..onTap = _openPrivacy;

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  void _openTerms() {}

  void _openPrivacy() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final baseStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 12,
      color: AppPalette.textNeutralPrimary,
    );

    final linkStyle = baseStyle?.copyWith(color: theme.colorScheme.primary);

    return ValueListenableBuilder<bool>(
      valueListenable: widget.accepted,
      builder: (context, isAccepted, _) {
        return Row(
          children: [
            Checkbox(
              value: isAccepted,
              onChanged: (value) => widget.accepted.value = value ?? false,
            ),
            const SizedBox(width: AppDimens.s8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: baseStyle,
                  children: [
                    const TextSpan(text: _prefix),
                    TextSpan(
                      text: _termsLabel,
                      style: linkStyle,
                      recognizer: _termsTap,
                    ),
                    const TextSpan(text: _joiner),
                    TextSpan(
                      text: _privacyLabel,
                      style: linkStyle,
                      recognizer: _privacyTap,
                    ),
                    const TextSpan(text: _suffix),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
