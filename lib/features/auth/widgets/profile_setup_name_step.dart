import 'package:flutter/material.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';

import 'profile_setup_heading.dart';

class ProfileSetupNameStep extends StatelessWidget {
  const ProfileSetupNameStep({
    required this.firstNameController,
    required this.lastNameController,
    required this.onLastNameSubmitted,
    super.key,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueChanged<String> onLastNameSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ProfileSetupHeading(
          title: 'What’s your name?',
          subtitle:
              'Let’s get to know you so we can personalize your runner profile.',
        ),
        const SizedBox(height: 32),
        CustomTextFormField(
          controller: firstNameController,
          label: 'First Name',
          isRequired: true,
          hint: 'e.g. Alex',
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          controller: lastNameController,
          label: 'Last Name',
          isRequired: true,
          hint: 'e.g. Alex',
          onFieldSubmitted: onLastNameSubmitted,
        ),
      ],
    );
  }
}
