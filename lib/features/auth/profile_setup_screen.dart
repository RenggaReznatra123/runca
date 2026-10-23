import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/auth/cubit/profile_setup_cubit.dart';
import 'package:runca/features/auth/cubit/profile_setup_state.dart';
import 'package:runca/features/success/success_screen.dart';
import 'package:runca/features/success/success_type.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileSetupCubit(),
      child: const _ProfileSetupForm(),
    );
  }
}

class _ProfileSetupForm extends StatefulWidget {
  const _ProfileSetupForm();

  @override
  State<_ProfileSetupForm> createState() => _ProfileSetupFormState();
}

class _ProfileSetupFormState extends State<_ProfileSetupForm> {
  static const List<String> _runningGoals = [
    'Stay Healthy & Fit',
    'Build Cardio Endurance',
    'Prepare for a Race / Event',
    'Lose Weight & Burn Fat',
    'Improve Speed & Pace',
  ];

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
    final now = DateTime.now();

    final initialDate =
        _birthday ?? DateTime(now.year - 16, now.month, now.day.clamp(1, 28));

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Select your birthday',
      cancelText: 'Cancel',
      confirmText: 'Confirm',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppPalette.bgButtonPrimaryDefault,
              onPrimary: AppPalette.textWhitePrimary,
              surface: AppPalette.bgModal,
              onSurface: AppPalette.textNeutralPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null || !mounted) return;

    setState(() {
      _birthday = selectedDate;
      _birthdayController.text = _formatBirthday(selectedDate);
    });
  }

  String _formatBirthday(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day/${date.year}';
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

        return Scaffold(
          backgroundColor: AppPalette.bg,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: AppPalette.bg,
            surfaceTintColor: AppPalette.baseBlack.withValues(alpha: 0),
            elevation: 0,
            toolbarHeight: 64,
            leading: IconButton(
              onPressed: _goBack,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppPalette.iconNeutralPrimary,
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Progress Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildProgress(),
                    ),

                    // Step Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: _buildStepContent(),
                      ),
                    ),

                    // Bottom Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _canContinue && !isSubmitting
                              ? _continue
                              : null,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppPalette.bgButtonPrimaryDefault,
                            disabledBackgroundColor: AppPalette.bgDisabled,
                            foregroundColor: AppPalette.textButtonPrimary,
                            disabledForegroundColor: AppPalette.textDisabled,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _currentStep == 3
                                      ? 'Complete Profile'
                                      : 'Continue',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgress() {
    return Row(
      children: List.generate(4, (index) {
        final isCompleted = index <= _currentStep;

        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == 3 ? 0 : 12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppPalette.bgFillPrimary
                  : AppPalette.borderNeutral,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildNameStep();
      case 1:
        return _buildGenderStep();
      case 2:
        return _buildBirthdayStep();
      case 3:
        return _buildGoalStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeading({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            height: 1.3,
            fontWeight: FontWeight.w400,
            color: AppPalette.textNeutralPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppPalette.textNeutralPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeading(
          title: 'What’s your name?',
          subtitle:
              'Let’s get to know you so we can personalize your runner profile.',
        ),
        const SizedBox(height: 32),
        CustomTextFormField(
          controller: _firstNameController,
          label: 'First Name',
          isRequired: true,
          hint: 'e.g. Alex',
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          controller: _lastNameController,
          label: 'Last Name',
          isRequired: true,
          hint: 'e.g. Alex',
          onFieldSubmitted: (_) {
            if (_canContinue) _continue();
          },
        ),
      ],
    );
  }

  Widget _buildGenderStep() {
    const genders = ['Man', 'Woman', 'Prefer not to say'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeading(
          title: 'What is your gender?',
          subtitle:
              'Helps us accurately calculate your pace zones and calorie burn.',
        ),
        const SizedBox(height: 32),
        ...genders.map((gender) {
          final selected = _gender == gender;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: selected
                  ? AppPalette.bgButtonPrimaryDefault
                  : AppPalette.bgSurfacePrimary,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => _gender = gender),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    gender,
                    style: TextStyle(
                      fontSize: 16,
                      color: selected
                          ? AppPalette.textWhitePrimary
                          : AppPalette.textButtonSecondaryDefault,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBirthdayStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeading(
          title: 'When is your birthday?',
          subtitle:
              'Used for age-group leaderboards and personalized performance metrics.',
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: _selectBirthday,
          child: AbsorbPointer(
            child: CustomTextFormField(
              controller: _birthdayController,
              label: 'Birthday',
              isRequired: true,
              hint: 'MM/DD/YYYY',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalStep() {
    final firstName = _firstNameController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeading(
          title: firstName.isEmpty
              ? 'What’s your top Running Goal?'
              : 'What’s your top Running Goal, $firstName?',
          subtitle: 'Select what motivates you the most to start moving.',
        ),
        const SizedBox(height: 28),
        ..._runningGoals.map((goal) {
          final selected = _selectedGoals.contains(goal);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (selected) {
                    _selectedGoals.remove(goal);
                  } else {
                    _selectedGoals.add(goal);
                  }
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical:
                      16, // Menyesuaikan padding dari figma inspector (16, 16)
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppPalette.bgSurfacePrimary
                      : AppPalette.baseWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected
                        ? AppPalette.borderPrimary
                        : AppPalette.borderNeutral,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppPalette.textNeutralPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: selected,
                        onChanged: (_) {
                          setState(() {
                            if (selected) {
                              _selectedGoals.remove(goal);
                            } else {
                              _selectedGoals.add(goal);
                            }
                          });
                        },
                        activeColor: AppPalette.bgFillPrimary,
                        checkColor: AppPalette.baseWhite,
                        side: const BorderSide(
                          color: AppPalette.borderNeutral,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
