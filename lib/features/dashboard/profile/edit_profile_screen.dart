import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/rewards/widgets/rewards_error_view.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/edit_profile_cubit.dart';
import 'cubit/edit_profile_state.dart';
import 'widgets/edit_profile_form.dart';

/// Halaman Edit Profile. Menutup dengan hasil `true` kalau berhasil disimpan.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  Future<void> _pickBirthDate(BuildContext context, DateTime current) async {
    final cubit = context.read<EditProfileCubit>();

    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked == null || cubit.isClosed) return;
    cubit.selectBirthDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listenWhen: (previous, current) =>
          previous.saveStatus != current.saveStatus,
      listener: (context, state) {
        switch (state.saveStatus) {
          case EditProfileSaveStatus.success:
            Navigator.of(context).pop(true);
          case EditProfileSaveStatus.failure:
            context.showErrorSnackbar(
              'Unable to save changes. Please try again.',
            );
            context.read<EditProfileCubit>().clearSaveStatus();
          case EditProfileSaveStatus.idle:
          case EditProfileSaveStatus.saving:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: AppPalette.baseWhite,
        body: SafeArea(
          child: Column(
            children: [
              const _Header(),
              const Divider(height: 1, color: AppPalette.borderNeutral),
              Expanded(
                child: BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: _buildBody,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EditProfileState state) {
    final cubit = context.read<EditProfileCubit>();

    if (state.loadStatus == EditProfileLoadStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      );
    }

    final draft = state.draft;

    if (state.loadStatus == EditProfileLoadStatus.failure || draft == null) {
      return RewardsErrorView(
        title: 'Unable to load profile',
        onRetry: cubit.loadProfile,
      );
    }

    return EditProfileForm(
      data: draft,
      isSaving: state.saveStatus == EditProfileSaveStatus.saving,
      onGenderChanged: cubit.selectGender,
      onPickBirthDate: () => _pickBirthDate(context, draft.birthDate),
      onCameraTap: () => context.showUnavailableSnackbar(
        'Change photo',
        duration: const Duration(seconds: 2),
      ),
      onSave: cubit.save,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 44),
              color: AppPalette.textNeutralPrimary,
            ),
            const SizedBox(width: 4),
            Text(
              'Edit Profile',
              style: AppTypography.titleMedium(
                color: AppPalette.textNeutralPrimary,
              ).copyWith(fontWeight: AppTypography.medium),
            ),
          ],
        ),
      ),
    );
  }
}