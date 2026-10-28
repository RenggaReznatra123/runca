import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

import 'create_password_field.dart';

class CreateNewPasswordForm extends StatelessWidget {
  const CreateNewPasswordForm({
    required this.formKey,
    required this.passwordController,
    required this.confirmController,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.isLoading,
    required this.canSubmit,
    required this.onPasswordChanged,
    required this.onConfirmChanged,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.validatePassword,
    required this.validateConfirm,
    required this.onConfirmSubmitted,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool isLoading;
  final bool canSubmit;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final String? Function(String?) validatePassword;
  final String? Function(String?) validateConfirm;
  final VoidCallback onConfirmSubmitted;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Your New Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Make sure the new password is easy to remember.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
              const SizedBox(height: 34),
              CreatePasswordField(
                label: 'New Password',
                controller: passwordController,
                obscure: obscurePassword,
                textInputAction: TextInputAction.next,
                onChanged: onPasswordChanged,
                onToggle: onTogglePassword,
                validator: validatePassword,
              ),
              const SizedBox(height: 8),
              const Text(
                'Minimum of 6 characters, a combination of letters and numbers.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppPalette.textNeutralSecondary,
                ),
              ),
              const SizedBox(height: 20),
              CreatePasswordField(
                label: 'Confirm New Password',
                controller: confirmController,
                obscure: obscureConfirm,
                textInputAction: TextInputAction.done,
                onChanged: onConfirmChanged,
                onToggle: onToggleConfirm,
                validator: validateConfirm,
                onFieldSubmitted: (_) => onConfirmSubmitted(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: (isLoading || !canSubmit) ? null : onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canSubmit
                        ? AppPalette.bgButtonPrimaryDefault
                        : AppPalette.bgDisabled,
                    foregroundColor: canSubmit
                        ? AppPalette.baseWhite
                        : AppPalette.textDisabled,
                    disabledBackgroundColor: AppPalette.bgDisabled,
                    disabledForegroundColor: AppPalette.textDisabled,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                          'Create Password',
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
      ),
    );
  }
}
