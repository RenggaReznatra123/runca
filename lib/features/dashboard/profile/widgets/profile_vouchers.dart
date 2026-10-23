import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ProfileVouchers extends StatelessWidget {
  const ProfileVouchers({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.bgSurfaceNeutral,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 54,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'My Vouchers',
                    style: AppTypography.bodyMedium(
                      color: AppPalette.textNeutralPrimary,
                    ).copyWith(fontSize: 14),
                  ),
                ),
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
    );
  }
}
