import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

class ProgressLoadingBlock extends StatelessWidget {
  const ProgressLoadingBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 240,
      child: Center(
        child: CircularProgressIndicator(color: AppPalette.bgFillPrimary),
      ),
    );
  }
}
