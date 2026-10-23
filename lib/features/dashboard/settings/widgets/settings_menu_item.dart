import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    super.key,
    required this.title,
    this.value,
    this.onTap,
    this.showChevron = true,
    this.showDivider = true,
  });

  final String title;
  final String? value;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 46,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
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
                  if (value != null) ...[
                    Text(
                      value!,
                      style: AppTypography.bodyMedium(
                        color: AppPalette.profileAccent,
                      ).copyWith(fontSize: 14),
                    ),
                    const SizedBox(width: 10),
                  ],
                  if (showChevron)
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 23,
                      color: AppPalette.profileMutedIcon,
                    ),
                ],
              ),
            ),
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
