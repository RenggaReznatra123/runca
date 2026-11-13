import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  late bool _canSave = widget.initialTitle.trim().isNotEmpty;

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
    final canSave = _controller.text.trim().isNotEmpty;

    if (canSave != _canSave) setState(() => _canSave = canSave);
  }

  Future<void> _pickPhoto() async {
    final cubit = context.read<EditActivityCubit>();

    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (file == null || cubit.isClosed) return;

      cubit.setPhoto(file.path);
    } catch (_) {
      if (mounted) context.showErrorSnackbar('Unable to open your photos.');
    }
  }

  // ASUMSI: satu foto per aktivitas. Kotak kamera hanya menambah kalau belum
  // ada foto; kalau sudah ada, pengguna diarahkan ke Change Photo.
  void _onAddTap(EditActivityState state) {
    if (state.photoPath != null) {
      context.showInfoSnackbar(
        'One photo per activity. Use Change Photo to replace it.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    _pickPhoto();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditActivityCubit>();

    return BlocListener<EditActivityCubit, EditActivityState>(
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
                                  onChange: _pickPhoto,
                                  onRemove: cubit.removePhoto,
                                  onAdd: () => _onAddTap(state),
                                ),
                              ],
                            ),
                          ),
                        ),
                        EditActivityActions(
                          canSave: _canSave,
                          isSaving: state.status == EditActivityStatus.saving,
                          onSave: () {
                            FocusScope.of(context).unfocus();
                            cubit.save(_controller.text);
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
