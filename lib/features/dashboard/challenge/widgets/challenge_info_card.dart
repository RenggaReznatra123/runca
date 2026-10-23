import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class ChallengeInfoCard extends StatelessWidget {
  const ChallengeInfoCard({
    super.key,
    required this.dateRange,
    required this.target,
  });

  final String dateRange;
  final String target;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppPalette.bgPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_month_outlined,
            iconSize: 20,
            label: 'Date & time',
            value: dateRange,
          ),
          const SizedBox(height: 12),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppPalette.borderNeutral,
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.track_changes_rounded,
            iconSize: 24,
            label: 'Target',
            value: target,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconSize,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final double iconSize;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: iconSize, color: AppPalette.iconPrimary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodyMedium(
                  color: AppPalette.textNeutralSecondary,
                ).copyWith(fontSize: 13),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(fontWeight: AppTypography.medium),
              ),
            ],
          ),
        ),
      ],
    );
  }
}