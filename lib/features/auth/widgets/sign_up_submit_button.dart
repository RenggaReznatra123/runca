import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/sign_up_cubit.dart';
import 'package:runca/ui/custom_button.dart';

class SignUpSubmitButton extends StatelessWidget {
  const SignUpSubmitButton({
    required this.formListenable,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.acceptedTerms,
    required this.onSubmit,
    super.key,
  });

  final Listenable formListenable;
  final ValueNotifier<String> email;
  final ValueNotifier<String> password;
  final ValueNotifier<String> confirmPassword;
  final ValueNotifier<bool> acceptedTerms;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final isLoading = state is SignUpStateLoading;

        return ListenableBuilder(
          listenable: formListenable,
          builder: (context, _) {
            final canSubmit =
                email.value.trim().isNotEmpty &&
                password.value.isNotEmpty &&
                confirmPassword.value.isNotEmpty &&
                acceptedTerms.value &&
                !isLoading;

            return SizedBox(
              height: 40,
              child: CustomButton(
                text: 'Sign Up',
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
