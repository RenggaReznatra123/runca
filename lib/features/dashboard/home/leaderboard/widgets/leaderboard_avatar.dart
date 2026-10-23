import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

class LeaderboardAvatar extends StatelessWidget {
  const LeaderboardAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
  });

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = imageUrl;
    if (path == null || path.isEmpty) return _fallback();

    final image = path.startsWith('http')
        ? Image.network(
            path,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
          )
        : Image.asset(
            path,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
          );
    return ClipOval(child: image);
  }

  Widget _fallback() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppPalette.bgSurfaceNeutral,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: size * 0.65,
        color: AppPalette.iconNeutralSecondary,
      ),
    );
  }
}
