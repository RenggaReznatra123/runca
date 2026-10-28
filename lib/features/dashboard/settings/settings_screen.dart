import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:runca/config/service_locator.dart';
import 'package:runca/features/auth/cubit/auth_cubit.dart';
import 'package:runca/features/auth/login_screen.dart';
import 'package:runca/features/dashboard/settings/cubit/settings_cubit.dart';
import 'package:runca/features/dashboard/settings/cubit/settings_state.dart';
import 'package:runca/features/dashboard/settings/models/app_settings.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_choice_sheet.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_header.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_logout_dialog.dart';
import 'package:runca/features/dashboard/settings/widgets/settings_list.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/utility/snackbar_extension.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showUnavailable(BuildContext context, String page) {
    context.showUnavailableSnackbar(page, duration: const Duration(seconds: 2));
  }

  void _showMessage(BuildContext context, String message) {
    context.showInfoSnackbar(message, duration: const Duration(seconds: 2));
  }

  Future<void> _selectLanguage(
    BuildContext context,
    SettingsCubit cubit,
    AppLanguage selected,
  ) async {
    final result = await SettingsChoiceSheet.show(
      context: context,
      title: 'Select Language',
      description: 'Choose your preferred language for the app interface.',
      options: AppLanguage.values.map((language) => language.label).toList(),
      selected: selected.label,
    );

    if (result != null && context.mounted) {
      cubit.changeLanguage(
        AppLanguage.values.firstWhere((language) => language.label == result),
      );
    }
  }

  Future<void> _selectUnits(
    BuildContext context,
    SettingsCubit cubit,
    UnitSystem selected,
  ) async {
    final result = await SettingsChoiceSheet.show(
      context: context,
      title: 'Select Units',
      description:
          'Choose your preferred measurement units for running activities.',
      options: UnitSystem.values.map((units) => units.label).toList(),
      selected: selected.label,
    );

    if (result != null && context.mounted) {
      cubit.changeUnits(
        UnitSystem.values.firstWhere((units) => units.label == result),
      );
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();
    if (cubit.state.isLoggingOut) return;

    final confirmed = await SettingsLogoutDialog.show(context);

    if (confirmed && context.mounted) {
      final success = await cubit.logout();
      if (!context.mounted) return;

      if (!success) {
        _showMessage(context, 'Unable to log out. Please try again.');
        return;
      }

      context.read<AuthCubit>().reset();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: Builder(
        builder: (context) {
          return BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
              if (state.hasError) {
                context.read<SettingsCubit>().clearError();
                _showMessage(
                  context,
                  'Unable to save settings. Please try again.',
                );
              }
            },
            child: Scaffold(
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
                      color: AppPalette.bgButtonOutlinedHover,
                    ),
                    Expanded(
                      child: BlocBuilder<SettingsCubit, SettingsState>(
                        builder: (context, state) {
                          final cubit = context.read<SettingsCubit>();

                          return SettingsList(
                            state: state,
                            version:
                                'Plarita v${serviceLocator.get<PackageInfo>().version}',
                            onUnavailable: (page) =>
                                _showUnavailable(context, page),
                            onSelectLanguage: (selected) =>
                                _selectLanguage(context, cubit, selected),
                            onSelectUnits: (selected) =>
                                _selectUnits(context, cubit, selected),
                            onToggleNotifications: cubit.toggleNotifications,
                            onToggleDarkMode: cubit.toggleDarkMode,
                            onLogout: () => _confirmLogout(context),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
