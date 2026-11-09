import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/run_cubit.dart';
import 'cubit/run_state.dart';

/// Pesan SnackBar untuk masalah izin dan layanan lokasi di layar lari.
extension RunLocationMessages on BuildContext {
  void showRunLocationMessage(RunLocationStatus status) {
    final cubit = BlocProvider.of<RunCubit>(this, listen: false);

    switch (status) {
      case RunLocationStatus.permissionDenied:
        _showAction(
          'Location permission is needed to track your run.',
          'Allow',
          cubit.startLocation,
        );
      case RunLocationStatus.permissionDeniedForever:
        _showAction(
          'Location permission is blocked. Enable it in app settings.',
          'Settings',
          cubit.openAppSettings,
        );
      case RunLocationStatus.serviceDisabled:
        _showAction(
          'Turn on location services to track your run.',
          'Settings',
          cubit.openLocationSettings,
        );
      case RunLocationStatus.failure:
        _showAction(
          'Unable to read your location. Please try again.',
          'Retry',
          cubit.startLocation,
        );
      case RunLocationStatus.checking:
      case RunLocationStatus.ready:
        break;
    }
  }

  void _showAction(String message, String label, VoidCallback onPressed) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: label, onPressed: onPressed),
        ),
      );
  }
}
