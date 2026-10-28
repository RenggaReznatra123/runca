import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/auth_cubit.dart';
import 'package:runca/ui/custom_button.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({
    required this.formListenable,
    required this.email,
    required this.password,
    required this.onSubmit,
    super.key,
  });

  final Listenable formListenable;
  final ValueNotifier<String> email;
  final ValueNotifier<String> password;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthStateLoading;

        return ListenableBuilder(
          listenable: formListenable,
          builder: (context, _) {
            final canSubmit =
                email.value.trim().isNotEmpty &&
                password.value.isNotEmpty &&
                !isLoading;

            return SizedBox(
              height: 48,
              child: CustomButton(
                text: 'Log In',
                isLoading: isLoading,
                onPressed: canSubmit ? onSubmit : null,
              ),
            );
          },
        );
      },
    );
  }
}
