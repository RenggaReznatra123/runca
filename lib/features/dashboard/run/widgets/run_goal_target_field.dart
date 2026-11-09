import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Kartu isian target (jarak atau waktu) dengan angka besar dan satuan.
/// Tingginya mengikuti isi, jadi tidak overflow.
class RunGoalTargetField extends StatelessWidget {
  const RunGoalTargetField({
    super.key,
    required this.label,
    required this.hint,
    required this.unit,
    required this.controller,
    required this.focusNode,
    required this.keyboardType,
    required this.inputFormatters,
  });

  final String label;
  final String hint;
  final String unit;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    final valueStyle = AppTypography.headlineSmall(
      color: AppPalette.textNeutralPrimary,
    ).copyWith(fontSize: 36, fontWeight: AppTypography.semiBold, height: 1.2);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: focusNode.requestFocus,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        decoration: BoxDecoration(
          color: AppPalette.baseWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppPalette.borderNeutral),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.bodyMedium(
                color: AppPalette.profileMutedText,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    cursorColor: AppPalette.profileAccent,
                    style: valueStyle,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hint,
                      hintStyle: valueStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  unit,
                  style: AppTypography.titleMedium(
                    color: AppPalette.profileMutedText,
                  ).copyWith(fontSize: 20, fontWeight: AppTypography.regular),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
