import 'package:flutter/material.dart';
import 'package:runca/features/dashboard/settings/cubit/settings_state.dart';
import 'package:runca/features/dashboard/settings/models/app_settings.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_logout_button.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_menu_item.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_section.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_toggle_item.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({
    required this.state,
    required this.version,
    required this.onUnavailable,
    required this.onSelectLanguage,
    required this.onSelectUnits,
    required this.onToggleNotifications,
    required this.onToggleDarkMode,
    required this.onLogout,
    super.key,
  });

  final SettingsState state;
  final String version;
  final ValueChanged<String> onUnavailable;
  final ValueChanged<AppLanguage> onSelectLanguage;
  final ValueChanged<UnitSystem> onSelectUnits;
  final ValueChanged<bool> onToggleNotifications;
  final ValueChanged<bool> onToggleDarkMode;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final settings = state.settings;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      children: [
        SettingsSection(
          title: 'Account',
          children: [
            SettingsMenuItem(
              title: 'Change Password',
              showDivider: false,
              onTap: () => onUnavailable('Change Password'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SettingsSection(
          title: 'Preferences',
          children: [
            SettingsMenuItem(
              title: 'Language',
              value: settings.language.rowLabel,
              onTap: () => onSelectLanguage(settings.language),
            ),
            SettingsMenuItem(
              title: 'Units',
              value: settings.units.label,
              onTap: () => onSelectUnits(settings.units),
            ),
            SettingsToggleItem(
              title: 'Notifications',
              value: settings.notificationsEnabled,
              onChanged: onToggleNotifications,
            ),
            SettingsToggleItem(
              title: 'Dark Mode',
              value: settings.darkModeEnabled,
              onChanged: onToggleDarkMode,
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SettingsSection(
          title: 'Help',
          children: [
            SettingsMenuItem(title: 'FAQ', onTap: () => onUnavailable('FAQ')),
            SettingsMenuItem(
              title: 'Contact Support',
              showDivider: false,
              onTap: () => onUnavailable('Contact Support'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SettingsSection(
          title: 'About',
          children: [
            SettingsMenuItem(
              title: 'Privacy Policy',
              onTap: () => onUnavailable('Privacy Policy'),
            ),
            SettingsMenuItem(
              title: 'Terms of Service',
              showDivider: false,
              onTap: () => onUnavailable('Terms of Service'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SettingsLogoutButton(onTap: onLogout),
        const SizedBox(height: 20),
        Center(
          child: Text(
            version,
            style: AppTypography.bodySmall(
              color: AppPalette.profileMutedText,
            ).copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
