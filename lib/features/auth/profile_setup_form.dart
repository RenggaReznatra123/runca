import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/profile_setup_cubit.dart';
import 'package:runca/features/auth/cubit/profile_setup_state.dart';
import 'package:runca/features/success/success_screen.dart';
import 'package:runca/features/success/success_type.dart';
import 'package:runca/utility/format_utils.dart';

import 'widgets/profile_setup_birthday_step.dart';
import 'widgets/profile_setup_gender_step.dart';
import 'widgets/profile_setup_goal_step.dart';
import 'widgets/profile_setup_name_step.dart';
import 'widgets/profile_setup_page.dart';
import 'widgets/profile_setup_progress.dart';

class ProfileSetupForm extends StatefulWidget {
  const ProfileSetupForm({super.key});

  @override
  State<ProfileSetupForm> createState() => _ProfileSetupFormState();
}

class _ProfileSetupFormState extends State<ProfileSetupForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthdayController = TextEditingController();

  int _currentStep = 0;
  String? _gender;
  DateTime? _birthday;
  final Set<String> _selectedGoals = {};

  bool get _canContinue {
    switch (_currentStep) {
      case 0:
        return _firstNameController.text.trim().isNotEmpty &&
            _lastNameController.text.trim().isNotEmpty;
      case 1:
        return _gender != null;
      case 2:
        return _birthday != null;
      case 3:
        return _selectedGoals.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_refresh);
    _lastNameController.addListener(_refresh);
  }

  @override
  void dispose() {
    _firstNameController
      ..removeListener(_refresh)
      ..dispose();

    _lastNameController
      ..removeListener(_refresh)
      ..dispose();

    _birthdayController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      return;
    }

    Navigator.of(context).maybePop();
  }

  void _continue() {
    if (!_canContinue) return;

    FocusScope.of(context).unfocus();

    if (_currentStep < 3) {
      setState(() => _currentStep++);
      return;
    }

    context.read<ProfileSetupCubit>().submitProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      gender: _gender!,
      birthday: _birthday!,
      goals: _selectedGoals.toList(),
    );
  }

  Future<void> _selectBirthday() async {
    final selectedDate = await ProfileSetupBirthdayStep.selectDate(
      context,
      _birthday,
    );

    if (selectedDate == null || !mounted) return;

    setState(() {
      _birthday = selectedDate;
      _birthdayController.text = AppFormat.birthdayInput(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
      listener: (context, state) {
        if (state.status == ProfileSetupStatus.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const SuccessScreen(type: SuccessType.signUp),
            ),
            (route) => false,
          );
        } else if (state.status == ProfileSetupStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ??
                    'Gagal menyimpan profil. Silakan coba lagi.',
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == ProfileSetupStatus.loading;

        return ProfileSetupPage(
          currentStep: _currentStep,
          isSubmitting: isSubmitting,
          canContinue: _canContinue,
          onBack: _goBack,
          onContinue: _continue,
          progress: ProfileSetupProgress(currentStep: _currentStep),
          stepContent: _buildStepContent(),
        );
      },
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return ProfileSetupNameStep(
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          onLastNameSubmitted: (_) {
            if (_canContinue) _continue();
          },
        );
      case 1:
        return ProfileSetupGenderStep(
          selectedGender: _gender,
          onSelected: (gender) => setState(() => _gender = gender),
        );
      case 2:
        return ProfileSetupBirthdayStep(
          controller: _birthdayController,
          onTap: _selectBirthday,
        );
      case 3:
        return ProfileSetupGoalStep(
          firstName: _firstNameController.text.trim(),
          selectedGoals: _selectedGoals,
          onToggle: (goal) {
            setState(() {
              if (_selectedGoals.contains(goal)) {
                _selectedGoals.remove(goal);
              } else {
                _selectedGoals.add(goal);
              }
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
