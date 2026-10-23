
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/settings/cubit/settings_cubit.dart';
import 'package:runca/features/dashboard/settings/cubit/settings_state.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_choice_sheet.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_header.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_logout_button.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_logout_dialog.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_menu_item.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_section.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_toggle_item.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showUnavailable(BuildContext context, String page) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$page belum tersedia.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _selectLanguage(
    BuildContext context,
    SettingsCubit cubit,
    String selected,
  ) async {
    final result = await SettingsChoiceSheet.show(
      context: context,
      title: 'Select Language',
      description: 'Choose your preferred language for the app interface.',
      options: const ['English (US)', 'Bahasa Indonesia'],
      selected: selected,
    );

    if (result != null && context.mounted) {
      cubit.changeLanguage(result);
    }
  }

  Future<void> _selectUnits(
    BuildContext context,
    SettingsCubit cubit,
    String selected,
  ) async {
    final result = await SettingsChoiceSheet.show(
      context: context,
      title: 'Select Units',
      description:
          'Choose your preferred measurement units for running activities.',
      options: const ['Metric (km)', 'Imperial (mi)'],
      selected: selected,
    );

    if (result != null && context.mounted) {
      cubit.changeUnits(result);
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await SettingsLogoutDialog.show(context);

    if (confirmed && context.mounted) {
      _showUnavailable(context, 'Logout');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppPalette.baseWhite,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
                    child: SettingsHeader(
                      onBack: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF2F2F2),
                  ),
                  Expanded(
                    child: BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        final cubit = context.read<SettingsCubit>();

                        return ListView(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                          children: [
                            SettingsSection(
                              title: 'Account',
                              children: [
                                SettingsMenuItem(
                                  title: 'Change Password',
                                  showDivider: false,
                                  onTap: () => _showUnavailable(
                                    context,
                                    'Change Password',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SettingsSection(
                              title: 'Preferences',
                              children: [
                                SettingsMenuItem(
                                  title: 'Language',
                                  value: state.language,
                                  onTap: () => _selectLanguage(
                                    context,
                                    cubit,
                                    state.language,
                                  ),
                                ),
                                SettingsMenuItem(
                                  title: 'Units',
                                  value: state.units,
                                  onTap: () => _selectUnits(
                                    context,
                                    cubit,
                                    state.units,
                                  ),
                                ),
                                SettingsToggleItem(
                                  title: 'Notifications',
                                  value: state.notificationsEnabled,
                                  onChanged: cubit.toggleNotifications,
                                ),
                                SettingsToggleItem(
                                  title: 'Dark Mode',
                                  value: state.darkModeEnabled,
                                  onChanged: cubit.toggleDarkMode,
                                  showDivider: false,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SettingsSection(
                              title: 'Help',
                              children: [
                                SettingsMenuItem(
                                  title: 'FAQ',
                                  onTap: () => _showUnavailable(context, 'FAQ'),
                                ),
                                SettingsMenuItem(
                                  title: 'Contact Support',
                                  showDivider: false,
                                  onTap: () => _showUnavailable(
                                    context,
                                    'Contact Support',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SettingsSection(
                              title: 'About',
                              children: [
                                SettingsMenuItem(
                                  title: 'Privacy Policy',
                                  onTap: () => _showUnavailable(
                                    context,
                                    'Privacy Policy',
                                  ),
                                ),
                                SettingsMenuItem(
                                  title: 'Terms of Service',
                                  showDivider: false,
                                  onTap: () => _showUnavailable(
                                    context,
                                    'Terms of Service',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SettingsLogoutButton(
                              onTap: () => _confirmLogout(context),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Plarita v1.0.0',
                                style: AppTypography.bodySmall(
                                  color: const Color(0xFF8293AD),
                                ).copyWith(fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
