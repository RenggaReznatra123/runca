import 'package:flutter/material.dart';

import 'package:runca/features/dashboard/home/models/home_model.dart';
import 'package:runca/ui/color.dart';

/// Toggle Indoor / Outdoor.
class HomeActivityToggle extends StatelessWidget {
  const HomeActivityToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final HomeActivityType selected;
  final ValueChanged<HomeActivityType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppPalette.bgSurfaceNeutral,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _ToggleOption(
            label: 'Indoor',
            selected: selected == HomeActivityType.indoor,
            onTap: () => onChanged(HomeActivityType.indoor),
          ),
          _ToggleOption(
            label: 'Outdoor',
            selected: selected == HomeActivityType.outdoor,
            onTap: () => onChanged(HomeActivityType.outdoor),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppPalette.baseWhite
              : AppPalette.baseBlack.withValues(alpha: 0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
      ),
    );
  }
}