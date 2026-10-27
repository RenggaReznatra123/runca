import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Kotak "VOUCHER CODE" dengan tombol salin.
class VoucherCodeBox extends StatelessWidget {
  const VoucherCodeBox({super.key, required this.code, required this.onCopy});

  final String code;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: AppPalette.bgSurfaceNeutral,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppPalette.baseBlack.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VOUCHER CODE',
                    style: AppTypography.bodySmall(
                      color: AppPalette.textNeutralPrimary,
                    ).copyWith(fontWeight: AppTypography.semiBold),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      code,
                      maxLines: 1,
                      style:
                          AppTypography.titleMedium(
                            color: AppPalette.textNeutralPrimary,
                          ).copyWith(
                            fontWeight: AppTypography.bold,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Material(
              color: AppPalette.baseWhite,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onCopy,
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.content_copy_outlined,
                    size: 20,
                    color: AppPalette.textNeutralPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
