import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/activity/cubit/activity_state.dart';
import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/format_utils.dart';

import 'cubit/notifications_cubit.dart';
import 'cubit/notifications_state.dart';
import 'models/notification_model.dart';
import 'widgets/notification_item.dart';
import 'widgets/notification_presentation.dart';
import 'widgets/notification_section.dart';

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

  List<NotificationModel> _getNotifications(
    List<NotificationModel> notifications,
    _NotificationGroup group,
    DateTime now,
  ) {
    return notifications
        .where((notification) => _groupOf(notification.createdAt, now) == group)
        .toList(growable: false);
  }

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

            final now = DateTime.now();
            final today = _getNotifications(
              state.notifications,
              _NotificationGroup.today,
              now,
            );
            final yesterday = _getNotifications(
              state.notifications,
              _NotificationGroup.yesterday,
              now,
            );
            final thisWeek = _getNotifications(
              state.notifications,
              _NotificationGroup.thisWeek,
              now,
            );

            return CustomScrollView(
              key: const PageStorageKey<String>('notifications_scroll'),
              physics: const ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: _NotificationsHeader(
                    onBack: () => Navigator.of(context).maybePop(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      NotificationSection(
                        title: 'Today',
                        date: AppFormat.notificationSectionDate(now),
                      ),
                      const SizedBox(height: 28),

                      ...today.expand(
                        (notification) => [
                          NotificationItem(
                            notification: notification,
                            onAction: () {
                              _handleAction(context, notification);
                            },
                          ),
                          const SizedBox(height: 38),
                        ],
                      ),

                      const SizedBox(height: 26),

                      NotificationSection(
                        title: 'Yesterday',
                        date: AppFormat.notificationSectionDate(
                          now.subtract(const Duration(days: 1)),
                        ),
                      ),
                      const SizedBox(height: 50),

                      ...yesterday.expand(
                        (notification) => [
                          NotificationItem(
                            notification: notification,
                            onAction: () {
                              _handleAction(context, notification);
                            },
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),

                      const SizedBox(height: 30),

                      NotificationSection(
                        title: 'This Week',
                        date: AppFormat.notificationWeekRange(now),
                      ),
                      const SizedBox(height: 50),

                      ...thisWeek.expand(
                        (notification) => [
                          NotificationItem(
                            notification: notification,
                            onAction: () {
                              _handleAction(context, notification);
                            },
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Center(
                        child: Text(
                          "You're all caught up on earlier updates",
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium(
                            color: AppPalette.textNeutralSecondary,
                          ).copyWith(fontSize: 14),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, NotificationModel notification) {
    final actionLabel = notification.type.actionLabel;

    if (actionLabel == null || actionLabel.isEmpty) {
      return;
    }

    switch (notification.type) {
      case NotificationType.activity:
        _openActivity(context, ActivityTab.activities);
      case NotificationType.weeklyProgress:
        _openActivity(context, ActivityTab.progress);
      case NotificationType.reminder:
      case NotificationType.streak:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$actionLabel belum tersedia.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  void _openActivity(BuildContext context, ActivityTab tab) {
    context.read<DashboardCubit>().openActivity(tab);
    Navigator.of(context).maybePop();
  }
}

enum _NotificationGroup { today, yesterday, thisWeek }

_NotificationGroup? _groupOf(DateTime date, DateTime now) {
  final day = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  if (day == today) return _NotificationGroup.today;
  if (day == today.subtract(const Duration(days: 1))) {
    return _NotificationGroup.yesterday;
  }

  final weekStart = today.subtract(Duration(days: today.weekday - 1));
  if (!day.isBefore(weekStart) && day.isBefore(today)) {
    return _NotificationGroup.thisWeek;
  }
  return null;
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppPalette.borderNeutral)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
              color: AppPalette.textNeutralPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Notifications',
            style:
                AppTypography.headlineSmall(
                  color: AppPalette.textNeutralPrimary,
                ).copyWith(
                  fontSize: 20,
                  fontWeight: AppTypography.semiBold,
                  height: 1.2,
                ),
          ),
        ],
      ),
    );
  }
}
