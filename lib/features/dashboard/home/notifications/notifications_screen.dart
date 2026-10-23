import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/features/dashboard/activity/cubit/activity_state.dart';
import 'package:runca/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'cubit/notifications_cubit.dart';
import 'cubit/notifications_state.dart';
import 'models/notification_model.dart';
import 'widgets/notification_item.dart';
import 'widgets/notification_section.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..loadNotifications(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  List<NotificationModel> _getNotifications(
    List<NotificationModel> notifications,
    NotificationType type,
  ) {
    return notifications
        .where((notification) => notification.type == type)
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
                        state.errorMessage ?? 'Gagal memuat notifikasi.',
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
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final today = [
              ..._getNotifications(
                state.notifications,
                NotificationType.reminder,
              ),
              ..._getNotifications(
                state.notifications,
                NotificationType.streak,
              ),
            ];

            final yesterday = _getNotifications(
              state.notifications,
              NotificationType.activity,
            );

            final thisWeek = _getNotifications(
              state.notifications,
              NotificationType.weeklyProgress,
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
                      const NotificationSection(title: 'Today', date: 'Sep 24'),
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

                      const NotificationSection(
                        title: 'Yesterday',
                        date: 'Sep 23',
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

                      const NotificationSection(
                        title: 'This Week',
                        date: 'Sep 21–24',
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
    final actionLabel = notification.actionLabel;

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
