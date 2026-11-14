import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/profile/models/running_goal.dart';
import 'package:runca/ui/color.dart';

import 'profile_setup_heading.dart';

extension RunningGoalPresentation on RunningGoal {
  String get label => switch (this) {
    RunningGoal.stayHealthyFit => 'Stay Healthy & Fit',
    RunningGoal.buildCardioEndurance => 'Build Cardio Endurance',
    RunningGoal.prepareForRaceEvent => 'Prepare for a Race / Event',
    RunningGoal.loseWeightBurnFat => 'Lose Weight & Burn Fat',
    RunningGoal.improveSpeedPace => 'Improve Speed & Pace',
  };
}

class ProfileSetupGoalStep extends StatelessWidget {
  const ProfileSetupGoalStep({
    required this.firstName,
    required this.selectedGoals,
    required this.onToggle,
    super.key,
  });

  final String firstName;
  final Set<RunningGoal> selectedGoals;
  final ValueChanged<RunningGoal> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileSetupHeading(
          title: firstName.isEmpty
              ? 'What’s your top Running Goal?'
              : 'What’s your top Running Goal, $firstName?',
          subtitle: 'Select what motivates you the most to start moving.',
        ),
        const SizedBox(height: 28),
        ...RunningGoal.values.map((goal) {
          final selected = selectedGoals.contains(goal);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => onToggle(goal),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppPalette.bgSurfacePrimary
                      : AppPalette.baseWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected
                        ? AppPalette.borderPrimary
                        : AppPalette.borderNeutral,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppPalette.textNeutralPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: selected,
                        onChanged: (_) => onToggle(goal),
                        activeColor: AppPalette.bgFillPrimary,
                        checkColor: AppPalette.baseWhite,
                        side: const BorderSide(
                          color: AppPalette.borderNeutral,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
