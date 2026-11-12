import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

import 'run_settings_row_text.dart';

/// Baris pengaturan dengan ikon, teks, dan saklar.
class RunSettingsToggleRow extends StatelessWidget {
  const RunSettingsToggleRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final vertical = subtitle == null ? 16.0 : 12.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: vertical),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppPalette.iconNeutralPrimary),
          const SizedBox(width: 16),
          Expanded(
            child: RunSettingsRowText(title: title, subtitle: subtitle),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 32,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppPalette.profileAccent,
              inactiveTrackColor: AppPalette.borderDisabled,
              activeThumbColor: AppPalette.baseWhite,
              inactiveThumbColor: AppPalette.baseWhite,
              trackOutlineColor: const WidgetStatePropertyAll(
                AppPalette.transparent,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
