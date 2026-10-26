import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Gambar dari URL (diawali 'http') atau aset. Kalau path kosong atau gagal
/// dimuat, tampil [placeholder] (atau kotak abu-abu dengan ikon).
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final source = path;

    if (source == null || source.isEmpty) return _fallback();

    if (source.startsWith('http')) {
      return Image.network(
        source,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }

    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() {
    return placeholder ??
        SizedBox(
          width: width,
          height: height,
          child: const ColoredBox(
            color: AppPalette.bgSurfaceNeutral,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppPalette.textNeutralSecondary,
              ),
            ),
          ),
        );
  }
}
