import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/auth/reset_password_screen.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_page_header.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'package:runca/features/dashboard/settings/cubit/change_password_cubit.dart';
import 'package:runca/features/dashboard/settings/cubit/change_password_state.dart';
import 'package:runca/features/dashboard/settings/widgets/change_password_form.dart';

/// Halaman Change Password. Menutup dengan hasil `true` kalau berhasil.
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatelessWidget {
  const _ChangePasswordView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ChangePasswordStatus.success:
            Navigator.of(context).pop(true);
          case ChangePasswordStatus.failure:
            context.showErrorSnackbar(
              'Unable to change password. Please try again.',
            );
            context.read<ChangePasswordCubit>().clearStatus();
          case ChangePasswordStatus.idle:
          case ChangePasswordStatus.saving:
          case ChangePasswordStatus.wrongCurrentPassword:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: AppPalette.baseWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppPageHeader(title: 'Change Password'),
              const Divider(height: 1, color: AppPalette.borderNeutral),
              Expanded(
                child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                  builder: (context, state) {
                    final cubit = context.read<ChangePasswordCubit>();

                    return ChangePasswordForm(
                      isSaving: state.status == ChangePasswordStatus.saving,
                      wrongCurrentPassword:
                          state.status ==
                          ChangePasswordStatus.wrongCurrentPassword,
                      onSubmit: (current, next) => cubit.submit(
                        currentPassword: current,
                        newPassword: next,
                      ),
                      onForgotPassword: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const ResetPasswordScreen(),
                          ),
                        );
                      },
                      onCurrentPasswordEdited: cubit.clearStatus,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
