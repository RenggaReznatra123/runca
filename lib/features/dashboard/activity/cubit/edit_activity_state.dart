enum EditActivityStatus { idle, saving, saved, failure }

enum EditActivityNotice { none, photoLimit, pickFailed }

class EditActivityState {
  const EditActivityState({
    this.status = EditActivityStatus.idle,
    this.photoPath,
    this.title = '',
    this.notice = EditActivityNotice.none,
  });

  final EditActivityStatus status;

  /// Foto yang dipilih. Null berarti tanpa foto.
  final String? photoPath;
  final String title;
  final EditActivityNotice notice;

  bool get canSave => title.trim().isNotEmpty;

  EditActivityState copyWith({
    EditActivityStatus? status,
    String? photoPath,
    String? title,
    EditActivityNotice? notice,
    bool clearPhoto = false,
  }) {
    return EditActivityState(
      status: status ?? this.status,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
      title: title ?? this.title,
      notice: notice ?? this.notice,
    );
  }
}
