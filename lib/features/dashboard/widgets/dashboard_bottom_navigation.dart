import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/cubit/dashboard_state.dart';
import 'package:runca/ui/color.dart';

class DashboardBottomNavigation extends StatelessWidget {
  const DashboardBottomNavigation({
    required this.selectedTab,
    required this.onSelect,
    super.key,
  });

  final DashboardTab selectedTab;
  final ValueChanged<DashboardTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: AppPalette.bg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppPalette.baseBlack.withValues(alpha: 0.10),
                blurRadius: 22,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavItem(
                label: 'Home',
                icon: Icons.home_rounded,
                selected: selectedTab == DashboardTab.home,
                onTap: () => onSelect(DashboardTab.home),
              ),
              _NavItem(
                label: 'Challenge',
                icon: Icons.emoji_events_outlined,
                selected: selectedTab == DashboardTab.challenge,
                onTap: () => onSelect(DashboardTab.challenge),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => onSelect(DashboardTab.run),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppPalette.bgFillPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions_run_rounded,
                        color: AppPalette.baseWhite,
                        size: 29,
                      ),
                    ),
                  ),
                ),
              ),
              _NavItem(
                label: 'Activity',
                icon: Icons.monitor_heart_outlined,
                selected: selectedTab == DashboardTab.activity,
                onTap: () => onSelect(DashboardTab.activity),
              ),
              _NavItem(
                label: 'Profile',
                icon: Icons.person_outline_rounded,
                selected: selectedTab == DashboardTab.profile,
                onTap: () => onSelect(DashboardTab.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppPalette.bgFillPrimary
        : AppPalette.textNeutralSecondary;

    return Expanded(
      child: Material(
        color: AppPalette.baseBlack.withValues(alpha: 0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 23, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.1,
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
