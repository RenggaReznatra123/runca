import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Kolom pencarian FAQ (tinggi 48, tanpa border).
class FaqSearchField extends StatelessWidget {
  const FaqSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return SizedBox(
      height: 48,
      child: TextField(
        onChanged: onChanged,
        expands: true,
        maxLines: null,
        minLines: null,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        style: AppTypography.bodyMedium(color: AppPalette.textNeutralPrimary),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppPalette.bgSurfaceNeutral,
          hintText: 'Search help articles, question...',
          hintStyle: AppTypography.bodyMedium(
            color: AppPalette.textNeutralSecondary,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppPalette.iconNeutralPrimary,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          contentPadding: const EdgeInsets.only(right: 16),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}
