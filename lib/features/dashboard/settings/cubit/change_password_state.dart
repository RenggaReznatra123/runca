enum ChangePasswordStatus {
  idle,
  saving,
  success,
  wrongCurrentPassword,
  failure,
}

class ChangePasswordState {
  const ChangePasswordState({this.status = ChangePasswordStatus.idle});

  final ChangePasswordStatus status;
}
