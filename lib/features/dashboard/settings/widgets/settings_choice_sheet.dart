
import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class SettingsChoiceSheet {
  const SettingsChoiceSheet._();

  static Future<String?> show({
    required BuildContext context,
    required String title,
    required String description,
    required List<String> options,
    required String selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              24,
              16,
              24,
              24 + MediaQuery.paddingOf(sheetContext).bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 128,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppPalette.borderDisabled,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: AppTypography.titleLarge(
                    color: AppPalette.profileDarkText,
                  ).copyWith(fontSize: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTypography.bodyMedium(
                    color: AppPalette.profileMutedText,
                  ).copyWith(height: 1.5),
                ),
                const SizedBox(height: 18),
                ...options.map((option) {
                  final isSelected = option == selected;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: isSelected
                          ? AppPalette.profileAccent
                          : AppPalette.bgSurfaceNeutral,
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(sheetContext).pop(option);
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: double.infinity,
                          height: 70,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 19,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                option,
                                style: AppTypography.bodyMedium(
                                  color: isSelected
                                      ? Colors.white
                                      : AppPalette.profileDarkText,
                                ).copyWith(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
