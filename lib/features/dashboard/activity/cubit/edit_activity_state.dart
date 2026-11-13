enum EditActivityStatus { idle, saving, saved, failure }

class EditActivityState {
  const EditActivityState({
    this.status = EditActivityStatus.idle,
    this.photoPath,
  });

  final EditActivityStatus status;

  /// Foto yang dipilih. Null berarti tanpa foto.
  final String? photoPath;

  EditActivityState copyWith({
    EditActivityStatus? status,
    String? photoPath,
    bool clearPhoto = false,
  }) {
    return EditActivityState(
      status: status ?? this.status,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
    );
  }
}
