import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import '../models/edit_profile_model.dart';
import 'edit_profile_avatar.dart';
import 'edit_profile_gender_field.dart';

/// Isi halaman Edit Profile: avatar, semua kolom, dan tombol Save Changes.
class EditProfileForm extends StatefulWidget {
  const EditProfileForm({
    super.key,
    required this.data,
    required this.isSaving,
    required this.onGenderChanged,
    required this.onPickBirthDate,
    required this.onCameraTap,
    required this.onSave,
  });

  final EditProfileData data;
  final bool isSaving;
  final ValueChanged<ProfileGender> onGenderChanged;
  final VoidCallback onPickBirthDate;
  final VoidCallback onCameraTap;
  final ValueChanged<EditProfileData> onSave;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  static const double _fieldGap = 18;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final data = widget.data;

    _nameController = TextEditingController(text: data.name);
    _emailController = TextEditingController(text: data.email);
    _birthDateController = TextEditingController(
      text: AppFormat.birthDate(data.birthDate),
    );
    _heightController = TextEditingController(text: '${data.heightCm}');
    _weightController = TextEditingController(text: '${data.weightKg}');
    _locationController = TextEditingController(text: data.location);
  }

  @override
  void didUpdateWidget(EditProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Tanggal lahir dipilih lewat date picker, jadi teksnya ikut diperbarui.
    if (oldWidget.data.birthDate != widget.data.birthDate) {
      _birthDateController.text = AppFormat.birthDate(widget.data.birthDate);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    return (value ?? '').trim().isEmpty ? 'Full name is required' : null;
  }

  String? _validateNumber(String? value, String message) {
    final number = int.tryParse((value ?? '').trim());
    return number == null || number <= 0 ? message : null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    widget.onSave(
      widget.data.copyWith(
        name: _nameController.text.trim(),
        heightCm: int.parse(_heightController.text.trim()),
        weightKg: int.parse(_weightController.text.trim()),
        location: _locationController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: EditProfileAvatar(
                      avatarUrl: widget.data.avatarUrl,
                      onCameraTap: widget.onCameraTap,
                    ),
                  ),
                  const SizedBox(height: _fieldGap),
                  CustomTextFormField(
                    label: 'Full Name',
                    controller: _nameController,
                    validator: _validateName,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: _fieldGap),
                  // Email tidak bisa diubah: tidak bisa difokus atau diketuk.
                  AbsorbPointer(
                    child: CustomTextFormField(
                      label: 'Email',
                      controller: _emailController,
                      readOnly: true,
                      fillColor: AppPalette.profileDisabledFill,
                      textColor: AppPalette.textNeutralSecondary,
                    ),
                  ),
                  const SizedBox(height: _fieldGap),
                  EditProfileGenderField(
                    selected: widget.data.gender,
                    onChanged: widget.onGenderChanged,
                  ),
                  const SizedBox(height: _fieldGap),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onPickBirthDate,
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        label: 'Date of Birth',
                        controller: _birthDateController,
                        readOnly: true,
                        suffixIcon: const Icon(
                          Icons.calendar_month_outlined,
                          color: AppPalette.profileMutedIcon,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: _fieldGap),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          label: 'Height',
                          controller: _heightController,
                          suffixText: 'cm',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              _validateNumber(value, 'Enter a valid height'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextFormField(
                          label: 'Weight',
                          controller: _weightController,
                          suffixText: 'kg',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              _validateNumber(value, 'Enter a valid weight'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _fieldGap),
                  CustomTextFormField(
                    label: 'Location',
                    controller: _locationController,
                    textInputAction: TextInputAction.done,
                    suffixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: AppPalette.profileMutedIcon,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: _SaveButton(isSaving: widget.isSaving, onPressed: _submit),
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaving, required this.onPressed});

  final bool isSaving;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: isSaving ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.profileAccent,
          disabledBackgroundColor: AppPalette.profileAccent,
          foregroundColor: AppPalette.baseWhite,
          disabledForegroundColor: AppPalette.baseWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSaving
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppPalette.baseWhite,
                ),
              )
            : Text(
                'Save Changes',
                style: AppTypography.titleSmall(color: AppPalette.baseWhite),
              ),
      ),
    );
  }
}