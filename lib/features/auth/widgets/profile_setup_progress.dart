import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

class ProfileSetupProgress extends StatelessWidget {
  const ProfileSetupProgress({required this.currentStep, super.key});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        final isCompleted = index <= currentStep;

        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == 3 ? 0 : 12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppPalette.bgFillPrimary
                  : AppPalette.borderNeutral,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
