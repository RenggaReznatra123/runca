import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class SettingsToggleItem extends StatelessWidget {
  const SettingsToggleItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 46,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyMedium(
                    color: AppPalette.textNeutralPrimary,
                  ).copyWith(fontSize: 14),
                ),
              ),
              SizedBox(
                height: 32,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: AppPalette.profileAccent,
                  inactiveTrackColor: AppPalette.borderDisabled,
                  activeThumbColor: Colors.white,
                  inactiveThumbColor: Colors.white,
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppPalette.borderNeutral,
          ),
      ],
    );
  }
}
