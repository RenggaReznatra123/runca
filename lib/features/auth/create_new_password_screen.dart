import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/create_new_password_cubit.dart';
import 'package:runca/features/auth/cubit/create_new_password_state.dart';
import 'package:runca/features/success/success_screen.dart';
import 'package:runca/features/success/success_type.dart';
import 'package:runca/ui/color.dart';

import 'widgets/create_new_password_form.dart';

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

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) return 'Password wajib diisi.';
    if ((value ?? '').length < 6) return 'Password minimal 6 karakter.';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Konfirmasi password wajib diisi.';
    if (value != _passwordController.text) return 'Password tidak cocok.';
    return null;
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_canSubmit) return;

    context.read<CreateNewPasswordCubit>().createPassword(
      widget.email,
      _passwordController.text,
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

            return CreateNewPasswordForm(
              formKey: _formKey,
              passwordController: _passwordController,
              confirmController: _confirmController,
              obscurePassword: _obscurePassword,
              obscureConfirm: _obscureConfirm,
              isLoading: isLoading,
              canSubmit: _canSubmit,
              onPasswordChanged: (_) => setState(() {}),
              onConfirmChanged: (_) => setState(() {}),
              onTogglePassword: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              onToggleConfirm: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
              validatePassword: _validatePassword,
              validateConfirm: _validateConfirmPassword,
              onConfirmSubmitted: () {
                if (_canSubmit && !isLoading) _submit(context);
              },
              onSubmit: () => _submit(context),
            );
          },
        ),
      ),
    );
  }
}
