import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Titik penanda halaman di layar penuh.
class RunPageDots extends StatelessWidget {
  const RunPageDots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 9),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == index
                  ? AppPalette.profileAccent
                  : AppPalette.profileDisabledFill,
            ),
          ),
        ],
      ],
    );
  }
}
