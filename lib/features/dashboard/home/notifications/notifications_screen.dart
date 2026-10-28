import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/dashboard/activity/cubit/activity_state.dart';
import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/notifications_cubit.dart';
import 'cubit/notifications_state.dart';
import 'models/notification_model.dart';
import 'widgets/notification_presentation.dart';
import 'widgets/notifications_content.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.baseWhite,
      body: SafeArea(
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state.status == NotificationsStatus.loading ||
                state.status == NotificationsStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppPalette.bgFillPrimary,
                ),
              );
            }

            if (state.status == NotificationsStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Unable to load notifications. Check your connection and try again.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium(
                          color: AppPalette.textNeutralPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          context
                              .read<NotificationsCubit>()
                              .loadNotifications();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return NotificationsContent(
              notifications: state.notifications,
              onBack: () => Navigator.of(context).maybePop(),
              onAction: (notification) => _handleAction(context, notification),
            );
          },
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, NotificationModel notification) {
    final actionLabel = notification.type.actionLabel;
    if (actionLabel == null || actionLabel.isEmpty) return;

    switch (notification.type) {
      case NotificationType.activity:
        _openActivity(context, ActivityTab.activities);
      case NotificationType.weeklyProgress:
        _openActivity(context, ActivityTab.progress);
      case NotificationType.reminder:
      case NotificationType.streak:
        context.showUnavailableSnackbar(actionLabel, hideCurrent: false);
    }
  }

  void _openActivity(BuildContext context, ActivityTab tab) {
    context.read<DashboardCubit>().openActivity(tab);
    Navigator.of(context).maybePop();
  }
}
