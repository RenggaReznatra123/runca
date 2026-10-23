import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.imagePath,
    required this.onTap,
  });

  final String title;
  final String value;
  final String imagePath;
  final VoidCallback onTap;

  static const Color _cardColor = AppPalette.bgSurfaceNeutral;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 78,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall(
                          color: AppPalette.textNeutralPrimary,
                        ).copyWith(fontSize: 12),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppPalette.profileMutedText,
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Image.asset(
                      imagePath,
                      width: 23,
                      height: 23,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.image_not_supported_outlined,
                        size: 22,
                        color: AppPalette.textNeutralSecondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMedium(
                          color: AppPalette.textNeutralPrimary,
                        ).copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
