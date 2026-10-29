import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import '../models/help_model.dart';
import 'faq_pro_tip_box.dart';

/// Kartu satu pertanyaan FAQ yang bisa dibuka (accordion).
class FaqItemCard extends StatelessWidget {
  const FaqItemCard({
    super.key,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final FaqItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.bgSurfaceNeutral,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: AppTypography.bodyMedium(
                        color: AppPalette.textNeutralPrimary,
                      ).copyWith(height: 20 / 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 24,
                    color: AppPalette.iconNeutralPrimary,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? _Answer(item: item)
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _Answer extends StatelessWidget {
  const _Answer({required this.item});

  final FaqItem item;

  @override
  Widget build(BuildContext context) {
    final proTip = item.proTip;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1, color: AppPalette.borderNeutral),
          const SizedBox(height: 10),
          Text(
            item.answer,
            style: AppTypography.bodySmall(
              color: AppPalette.profileMutedText,
            ).copyWith(height: 18 / 12),
          ),
          if (proTip != null) ...[
            const SizedBox(height: 10),
            FaqProTipBox(message: proTip),
          ],
        ],
      ),
    );
  }
}