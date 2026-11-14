import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runca/features/dashboard/activity/cubit/activity_state.dart';
import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/snackbar_extension.dart';
import 'package:runca/features/dashboard/run/run_screen.dart';
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
        child: BlocListener<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state.hasRefreshError) {
              context.showErrorSnackbar('Unable to refresh. Try again.');
              context.read<NotificationsCubit>().clearRefreshError();
            }
          },
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final cubit = context.read<NotificationsCubit>();

              if (state.status == NotificationsStatus.loading ||
                  state.status == NotificationsStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppPalette.bgFillPrimary,
                  ),
                );
              }

              if (state.status == NotificationsStatus.failure) {
                return RefreshIndicator(
                  color: AppPalette.bgFillPrimary,
                  onRefresh: cubit.refresh,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
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
                                    onPressed: cubit.loadNotifications,
                                    child: const Text('Try Again'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return RefreshIndicator(
                color: AppPalette.bgFillPrimary,
                onRefresh: cubit.refresh,
                child: NotificationsContent(
                  notifications: state.notifications,
                  onBack: () => Navigator.of(context).maybePop(),
                  onAction: (notification) =>
                      _handleAction(context, notification),
                ),
              );
            },
          ),
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
      case NotificationType.streak:
        Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const RunScreen()));
      case NotificationType.reminder:
        context.showUnavailableSnackbar(actionLabel, hideCurrent: false);
    }
  }

  void _openActivity(BuildContext context, ActivityTab tab) {
    context.read<DashboardCubit>().openActivity(tab);
    Navigator.of(context).maybePop();
  }
}
