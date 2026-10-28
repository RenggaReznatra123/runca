import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

/// Convenience SnackBar helpers on [BuildContext]/[ScaffoldMessengerState].
extension SnackbarExtension on BuildContext {
  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppPalette.textSuccess,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppPalette.textDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void showInfoSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    bool hideCurrent = true,
  }) {
    final messenger = ScaffoldMessenger.of(this);
    if (hideCurrent) messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }

  void showUnavailableSnackbar(
    String page, {
    Duration duration = const Duration(seconds: 4),
    bool hideCurrent = true,
  }) {
    showInfoSnackbar(
      '$page belum tersedia.',
      duration: duration,
      hideCurrent: hideCurrent,
    );
  }
}
