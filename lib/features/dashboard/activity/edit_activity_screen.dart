import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_page_header.dart';
import 'package:runca/ui/shared_view/custom_text_form_field.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/edit_activity_cubit.dart';
import 'cubit/edit_activity_state.dart';
import 'models/activity_model.dart';
import 'widgets/edit_activity_actions.dart';
import 'widgets/edit_activity_photo_section.dart';

/// Layar Edit Activity: nama dan foto. Menutup dengan hasil `true` kalau
/// berhasil disimpan.
class EditActivityScreen extends StatelessWidget {
  const EditActivityScreen({super.key, required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditActivityCubit(activity: activity),
      child: _EditActivityView(initialTitle: activity.title),
    );
  }
}

class _EditActivityView extends StatefulWidget {
  const _EditActivityView({required this.initialTitle});

  final String initialTitle;

  @override
  State<_EditActivityView> createState() => _EditActivityViewState();
}

class _EditActivityViewState extends State<_EditActivityView> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialTitle,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    context.read<EditActivityCubit>().updateTitle(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditActivityCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<EditActivityCubit, EditActivityState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case EditActivityStatus.saved:
                Navigator.of(context).pop(true);
              case EditActivityStatus.failure:
                context.showErrorSnackbar(
                  'Unable to update activity. Please try again.',
                );
                cubit.clearStatus();
              case EditActivityStatus.idle:
              case EditActivityStatus.saving:
                break;
            }
          },
        ),
        BlocListener<EditActivityCubit, EditActivityState>(
          listenWhen: (previous, current) =>
              previous.notice != current.notice &&
              current.notice != EditActivityNotice.none,
          listener: (context, state) {
            switch (state.notice) {
              case EditActivityNotice.photoLimit:
                context.showInfoSnackbar(
                  'One photo per activity. Use Change Photo to replace it.',
                  duration: const Duration(seconds: 2),
                );
              case EditActivityNotice.pickFailed:
                context.showErrorSnackbar('Unable to open your photos.');
              case EditActivityNotice.none:
                break;
            }

            cubit.clearNotice();
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppPalette.baseWhite,
        body: SafeArea(
          child: Column(
            children: [
              const AppPageHeader(title: 'Edit Activity'),
              Expanded(
                child: BlocBuilder<EditActivityCubit, EditActivityState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextFormField(
                                  label: 'Activity name',
                                  controller: _controller,
                                  textInputAction: TextInputAction.done,
                                ),
                                const SizedBox(height: 24),
                                EditActivityPhotoSection(
                                  photoPath: state.photoPath,
                                  onChange: cubit.pickPhoto,
                                  onRemove: cubit.removePhoto,
                                  onAdd: cubit.addPhotoRequested,
                                ),
                              ],
                            ),
                          ),
                        ),
                        EditActivityActions(
                          canSave: state.canSave,
                          isSaving: state.status == EditActivityStatus.saving,
                          onSave: () {
                            FocusScope.of(context).unfocus();
                            cubit.save();
                          },
                          onCancel: () => Navigator.of(context).maybePop(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
