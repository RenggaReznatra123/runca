import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';

import 'profile_setup_heading.dart';

class ProfileSetupBirthdayStep extends StatelessWidget {
  const ProfileSetupBirthdayStep({
    required this.controller,
    required this.onTap,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onTap;

  static Future<DateTime?> selectDate(
    BuildContext context,
    DateTime? birthday,
  ) {
    final now = DateTime.now();
    final initialDate =
        birthday ?? DateTime(now.year - 16, now.month, now.day.clamp(1, 28));

    return showDatePicker(
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ProfileSetupHeading(
          title: 'When is your birthday?',
          subtitle:
              'Used for age-group leaderboards and personalized performance metrics.',
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: CustomTextFormField(
              controller: controller,
              label: 'Birthday',
              isRequired: true,
              hint: 'MM/DD/YYYY',
            ),
          ),
        ),
      ],
    );
  }
}
