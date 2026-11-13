import 'package:flutter/material.dart';

import 'package:runca/config/app_assets.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

/// Panel bawah layar Preview: Unduh, Instagram, WhatsApp, dan Others.
/// [onTap] dipanggil dengan nama tombolnya.
class ActivityShareActions extends StatelessWidget {
  const ActivityShareActions({super.key, required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 24, 0, 32 + bottomInset),
      decoration: BoxDecoration(
        color: AppPalette.baseWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppPalette.baseBlack.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionItem(
              label: 'Unduh',
              onTap: () => onTap('Unduh'),
              child: const Icon(
                Icons.save_alt_rounded,
                size: 24,
                color: AppPalette.iconNeutralPrimary,
              ),
            ),
          ),
          Expanded(
            child: _ActionItem(
              label: 'Instagram',
              onTap: () => onTap('Instagram'),
              child: const _BrandIcon(
                asset: AppAssets.shareInstagram,
                fallback: Icons.camera_alt_outlined,
              ),
            ),
          ),
          Expanded(
            child: _ActionItem(
              label: 'WhatsApp',
              onTap: () => onTap('WhatsApp'),
              child: const _BrandIcon(
                asset: AppAssets.shareWhatsapp,
                fallback: Icons.chat_bubble_outline_rounded,
              ),
            ),
          ),
          Expanded(
            child: _ActionItem(
              label: 'Others',
              onTap: () => onTap('Others'),
              child: const Icon(
                Icons.more_vert_rounded,
                size: 24,
                color: AppPalette.iconNeutralPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.label,
    required this.onTap,
    required this.child,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: AppPalette.bgSurfaceNeutral,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(width: 48, height: 48, child: Center(child: child)),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          maxLines: 1,
          style: AppTypography.bodyMedium(color: AppPalette.textNeutralPrimary),
        ),
      ],
    );
  }
}

/// Logo dari aset; kalau file belum ada, tampil ikon pengganti.
class _BrandIcon extends StatelessWidget {
  const _BrandIcon({required this.asset, required this.fallback});

  final String asset;
  final IconData fallback;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: 28,
      height: 28,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) =>
          Icon(fallback, size: 24, color: AppPalette.iconNeutralPrimary),
    );
  }
}
