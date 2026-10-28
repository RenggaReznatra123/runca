import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/custom_button.dart';
import 'package:runca/ui/custom_icons.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';
import 'package:runca/ui/shared_view/or_divider.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'login_form_header.dart';
import 'login_submit_button.dart';

class LoginFormLayout extends StatelessWidget {
  const LoginFormLayout({
    required this.formKey,
    required this.formListenable,
    required this.email,
    required this.password,
    required this.obscurePassword,
    required this.validateEmail,
    required this.validatePassword,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onSignUp,
    super.key,
  });

  static const double _horizontalPadding = 20;
  static const double _topSpacing = 24;
  static const double _fieldSpacing = 12;
  static const double _sectionSpacing = 16;
  static const double _buttonHeight = 48;
  static const double _googleIconSize = 18;
  static const double _footerFontSize = 12;
  static const double _tapTargetHeight = 40;

  final GlobalKey<FormState> formKey;
  final Listenable formListenable;
  final ValueNotifier<String> email;
  final ValueNotifier<String> password;
  final ValueNotifier<bool> obscurePassword;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validatePassword;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: _topSpacing),
                  const LoginFormHeader(),
                  const SizedBox(height: 26),
                  CustomTextFormField(
                    label: 'Email',
                    hint: 'Enter your email',
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(CustomIcons.email),
                    validator: validateEmail,
                    onChanged: onEmailChanged,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  ValueListenableBuilder<bool>(
                    valueListenable: obscurePassword,
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
                          onPressed: () => obscurePassword.value = !obscure,
                        ),
                        validator: validatePassword,
                        onChanged: onPasswordChanged,
                        onFieldSubmitted: (_) => onSubmit(),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onForgotPassword,
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
                  LoginSubmitButton(
                    formListenable: formListenable,
                    email: email,
                    password: password,
                    onSubmit: onSubmit,
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
                      onPressed: () => context.showUnavailableSnackbar(
                        'Continue with Google',
                      ),
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
                        onPressed: onSignUp,
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
    );
  }
}
