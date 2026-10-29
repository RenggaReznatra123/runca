import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/edit_profile_model.dart';

/// Pilihan gender berbentuk radio (Male / Female / Prefer not to say).
class EditProfileGenderField extends StatelessWidget {
  const EditProfileGenderField({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ProfileGender selected;
  final ValueChanged<ProfileGender> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: AppTypography.bodyMedium(color: AppPalette.textNeutralPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final gender in ProfileGender.values)
              Flexible(
                child: _GenderOption(
                  label: gender.label,
                  selected: gender == selected,
                  onTap: () => onChanged(gender),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RadioDot(selected: selected),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium(
                color: AppPalette.textNeutralPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppPalette.profileAccent : AppPalette.borderNeutral,
          width: selected ? 2 : 1.2,
        ),
      ),
      child: selected
          ? const SizedBox(
              width: 12,
              height: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppPalette.profileAccent,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}