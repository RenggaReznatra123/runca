import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ActivitySearchField extends StatelessWidget {
  const ActivitySearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );

    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: AppTypography.bodyLarge(color: AppPalette.textNeutralPrimary),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppPalette.bgSurfaceNeutral,
        hintText: 'Search activities...',
        hintStyle: AppTypography.bodyLarge(
          color: AppPalette.textNeutralSecondary,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 22,
          color: AppPalette.iconNeutralPrimary,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 40,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10.5,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
