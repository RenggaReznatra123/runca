class ActivityShareState {
  const ActivityShareState({this.placeName});

  /// Nama tempat awal rute. Null kalau belum ada atau tidak ditemukan.
  final String? placeName;

  ActivityShareState copyWith({String? placeName}) {
    return ActivityShareState(placeName: placeName ?? this.placeName);
  }
}