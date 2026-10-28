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

import 'sign_up_password_field.dart';
import 'sign_up_header.dart';
import 'sign_up_submit_button.dart';
import 'sign_up_terms_checkbox.dart';

class SignUpFormLayout extends StatelessWidget {
  const SignUpFormLayout({
    required this.formKey,
    required this.formListenable,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.acceptedTerms,
    required this.validateEmail,
    required this.validatePassword,
    required this.validateConfirmPassword,
    required this.onSubmit,
    required this.onLogin,
    super.key,
  });

  static const String _emailLabel = 'Email';
  static const String _emailHint = 'Enter your email';
  static const String _passwordLabel = 'Password';
  static const String _passwordHint = 'Enter your password';
  static const String _confirmPasswordLabel = 'Confirm Password';
  static const String _googleLabel = 'Continue with Google';
  static const String _hasAccountLabel = 'Already have an account?';
  static const String _loginLabel = 'Login';

  static const double _horizontalPadding = 20;
  static const double _googleIconSize = 18;
  static const double _tapTargetHeight = 40;
  static const double _buttonHeight = 40;

  final GlobalKey<FormState> formKey;
  final Listenable formListenable;
  final ValueNotifier<String> email;
  final ValueNotifier<String> password;
  final ValueNotifier<String> confirmPassword;
  final ValueNotifier<bool> obscurePassword;
  final ValueNotifier<bool> obscureConfirmPassword;
  final ValueNotifier<bool> acceptedTerms;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validatePassword;
  final String? Function(String?) validateConfirmPassword;
  final VoidCallback onSubmit;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
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
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: topSpacing),
                SignUpHeader(headingGap: headingGap),
                SizedBox(height: descriptionGap),
                CustomTextFormField(
                  label: _emailLabel,
                  hint: _emailHint,
                  isRequired: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(CustomIcons.email),
                  validator: validateEmail,
                  onChanged: (value) => email.value = value,
                ),
                SizedBox(height: fieldSpacing),
                SignUpPasswordField(
                  label: _passwordLabel,
                  hint: _passwordHint,
                  obscure: obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: validatePassword,
                  onChanged: (value) => password.value = value,
                ),
                SizedBox(height: fieldSpacing),
                SignUpPasswordField(
                  label: _confirmPasswordLabel,
                  hint: _passwordHint,
                  obscure: obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: validateConfirmPassword,
                  onChanged: (value) => confirmPassword.value = value,
                  onFieldSubmitted: (_) => onSubmit(),
                ),
                SizedBox(height: termsGap),
                SignUpTermsCheckbox(accepted: acceptedTerms),
                SizedBox(height: buttonGap),
                SignUpSubmitButton(
                  formListenable: formListenable,
                  email: email,
                  password: password,
                  confirmPassword: confirmPassword,
                  acceptedTerms: acceptedTerms,
                  onSubmit: onSubmit,
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
                    onPressed: () =>
                        context.showUnavailableSnackbar('Continue with Google'),
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
                      onPressed: onLogin,
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
    );
  }
}
