import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

class RunScreen extends StatelessWidget {
  const RunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppPalette.bgPrimary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_run_rounded,
                size: 64,
                color: AppPalette.bgFillPrimary,
              ),
              SizedBox(height: 16),
              Text(
                'Start Running',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Running screen will be available soon.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppPalette.textNeutralPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
