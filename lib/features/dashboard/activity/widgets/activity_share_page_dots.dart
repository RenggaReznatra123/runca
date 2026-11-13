import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Titik halaman kecil di layar Preview: halaman aktif berupa pil biru.
class ActivitySharePageDots extends StatelessWidget {
  const ActivitySharePageDots({
    super.key,
    required this.count,
    required this.index,
  });

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == index ? 22 : 6,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: i == index
                  ? AppPalette.profileAccent
                  : AppPalette.profileSoftBorder,
            ),
          ),
        ],
      ],
    );
  }
}