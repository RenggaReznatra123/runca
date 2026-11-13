import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'activity_share_screen.dart';
import 'cubit/activity_detail_cubit.dart';
import 'cubit/activity_detail_state.dart';
import 'edit_activity_screen.dart';
import 'models/activity_model.dart';
import 'widgets/activity_circle_button.dart';
import 'widgets/activity_delete_dialog.dart';
import 'widgets/activity_detail_map.dart';
import 'widgets/activity_detail_sheet.dart';
import 'widgets/activity_more_menu.dart';
import 'widgets/activity_state_view.dart';

/// Detail satu aktivitas: peta rute dan sheet statistik.
class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen({super.key, required this.activityId});

  final String activityId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivityDetailCubit(activityId: activityId),
      child: const _ActivityDetailView(),
    );
  }
}

class _ActivityDetailView extends StatelessWidget {
  const _ActivityDetailView();

  void _showUnavailable(BuildContext context, String page) {
    context.showUnavailableSnackbar(page, duration: const Duration(seconds: 2));
  }

  void _onMenuSelected(
    BuildContext context,
    ActivityModel activity,
    ActivityMenuAction action,
  ) {
    switch (action) {
      case ActivityMenuAction.mapStyle:
        // ASUMSI: pilihan style peta belum ada di Figma.
        _showUnavailable(context, 'Map Style');
      case ActivityMenuAction.edit:
        _openEdit(context, activity);
      case ActivityMenuAction.delete:
        _confirmDelete(context, activity);
    }
  }

  void _openShare(BuildContext context, ActivityModel activity) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ActivityShareScreen(activity: activity),
      ),
    );
  }

  Future<void> _openEdit(BuildContext context, ActivityModel activity) async {
    final cubit = context.read<ActivityDetailCubit>();

    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => EditActivityScreen(activity: activity),
      ),
    );

    if (updated != true || cubit.isClosed) return;

    await cubit.refresh();

    if (!context.mounted) return;

    context.showSoftSuccessSnackbar('Activity updated successfully!');
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ActivityModel activity,
  ) async {
    final cubit = context.read<ActivityDetailCubit>();

    final confirmed = await ActivityDeleteDialog.show(
      context,
      activityTitle: activity.title,
    );

    if (!confirmed || !context.mounted) return;

    final success = await cubit.delete();

    if (!context.mounted) return;

    if (!success) {
      context.showErrorSnackbar('Unable to delete activity. Please try again.');
      return;
    }

    // ASUMSI: pesan setelah hapus belum ada di Figma.
    context.showSoftSuccessSnackbar('Activity deleted.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActivityDetailCubit>();
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppPalette.bg,
      body: BlocBuilder<ActivityDetailCubit, ActivityDetailState>(
        builder: (context, state) {
          final activity = state.activity;

          if (state.status == ActivityDetailStatus.success &&
              activity != null) {
            return Stack(
              children: [
                Positioned.fill(
                  child: ActivityDetailMap(
                    route: activity.route,
                    photoPath: activity.photoPath,
                    bottomOffset:
                        MediaQuery.sizeOf(context).height *
                            ActivityDetailSheet.initialSize -
                        24,
                    onBack: () => Navigator.of(context).maybePop(),
                    onShare: () => _openShare(context, activity),
                    onMenuSelected: (action) =>
                        _onMenuSelected(context, activity, action),
                  ),
                ),
                Positioned.fill(child: ActivityDetailSheet(activity: activity)),
              ],
            );
          }

          return Stack(
            children: [
              Positioned.fill(
                child: state.status == ActivityDetailStatus.failure
                    ? Center(child: ActivityErrorView(onRetry: cubit.load))
                    : const Center(
                        child: CircularProgressIndicator(
                          color: AppPalette.bgFillPrimary,
                        ),
                      ),
              ),
              Positioned(
                top: topInset + 16,
                left: 20,
                child: ActivityCircleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}