import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';

/// Garis tebal pemisah antar bagian di Home.
class HomeSectionDivider extends StatelessWidget {
  const HomeSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 4,
      color: AppPalette.borderNeutral,
    );
  }
}