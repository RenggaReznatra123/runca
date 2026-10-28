import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

import 'profile_setup_heading.dart';

class ProfileSetupGenderStep extends StatelessWidget {
  const ProfileSetupGenderStep({
    required this.selectedGender,
    required this.onSelected,
    super.key,
  });

  final String? selectedGender;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const genders = ['Man', 'Woman', 'Prefer not to say'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ProfileSetupHeading(
          title: 'What is your gender?',
          subtitle:
              'Helps us accurately calculate your pace zones and calorie burn.',
        ),
        const SizedBox(height: 32),
        ...genders.map((gender) {
          final selected = selectedGender == gender;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: selected
                  ? AppPalette.bgButtonPrimaryDefault
                  : AppPalette.bgSurfacePrimary,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onSelected(gender),
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
}
