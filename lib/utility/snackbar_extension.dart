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

  /// Sukses versi lembut: latar hijau muda, garis dan teks hijau, ikon centang.
  void showSoftSuccessSnackbar(String message) {
    final textStyle = Theme.of(this).textTheme.bodyMedium?.copyWith(
      fontSize: 15,
      color: AppPalette.textSuccess,
    );

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppPalette.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          duration: const Duration(seconds: 3),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppPalette.bgSurfaceSuccess,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppPalette.textSuccess),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: AppPalette.textSuccess,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(message, style: textStyle)),
              ],
            ),
          ),
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