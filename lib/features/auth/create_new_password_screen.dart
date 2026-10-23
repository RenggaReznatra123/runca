import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/success/success_screen.dart';
import 'package:runca/features/success/success_type.dart';
import 'package:runca/features/auth/cubit/create_new_password_cubit.dart';
import 'package:runca/features/auth/cubit/create_new_password_state.dart';
import 'package:runca/ui/color.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool get _canSubmit {
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    return password.length >= 6 && confirm.isNotEmpty && password == confirm;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_canSubmit) return;

    context.read<CreateNewPasswordCubit>().createPassword(
      widget.email,
      _passwordController.text,
    );
  }

  InputDecoration _passwordDecoration({
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppPalette.textNeutralSecondary,
        fontSize: 14,
      ),
      prefixIcon: const Icon(
        Icons.lock_outline,
        size: 20,
        color: AppPalette.textNeutralPrimary,
      ),
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
          color: AppPalette.textNeutralPrimary,
        ),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.borderFormDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppPalette.bgButtonPrimaryDefault,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.textDanger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.textDanger, width: 1.5),
      ),
    );
  }

  Widget _requiredLabel(String label) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label),
          const TextSpan(
            text: ' *',
            style: TextStyle(color: AppPalette.textDanger),
          ),
        ],
      ),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppPalette.textNeutralPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateNewPasswordCubit(),
      child: Scaffold(
        backgroundColor: AppPalette.bg,
        body: BlocConsumer<CreateNewPasswordCubit, CreateNewPasswordState>(
          listener: (context, state) {
            if (state.status == CreateNewPasswordStatus.success) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      const SuccessScreen(type: SuccessType.passwordChanged),
                ),
                (route) => false,
              );
            } else if (state.status == CreateNewPasswordStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Terjadi kesalahan.'),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == CreateNewPasswordStatus.loading;

            final canSubmit = _canSubmit;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Form(
                  key: _formKey,
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

                      _requiredLabel('New Password'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: _passwordDecoration(
                          hint: 'Enter your password',
                          obscure: _obscurePassword,
                          onToggle: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Password wajib diisi.';
                          }

                          if ((value ?? '').length < 6) {
                            return 'Password minimal 6 karakter.';
                          }

                          return null;
                        },
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

                      _requiredLabel('Confirm New Password'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _confirmController,
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: _passwordDecoration(
                          hint: 'Enter your password',
                          obscure: _obscureConfirm,
                          onToggle: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Konfirmasi password wajib diisi.';
                          }

                          if (value != _passwordController.text) {
                            return 'Password tidak cocok.';
                          }

                          return null;
                        },
                        onFieldSubmitted: (_) {
                          if (_canSubmit && !isLoading) {
                            _submit(context);
                          }
                        },
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: (isLoading || !canSubmit)
                              ? null
                              : () => _submit(context),
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
          },
        ),
      ),
    );
  }
}
