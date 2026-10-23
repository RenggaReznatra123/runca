import 'package:flutter/material.dart';

/// Central place for custom (non-Material) icons.
///
/// Add custom `IconData` here when a custom icon font is introduced.
/// For now this re-exports semantic aliases of Material icons so
/// call-sites don't scatter raw `Icons.xxx` references.
class CustomIcons {
  const CustomIcons._();

  static const IconData home = Icons.home_outlined;
  static const IconData homeFilled = Icons.home;
  static const IconData profile = Icons.person_outline;
  static const IconData profileFilled = Icons.person;
  static const IconData email = Icons.email_outlined;
  static const IconData password = Icons.lock_outline;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData back = Icons.chevron_left;
  static const IconData logout = Icons.logout_outlined;
  static const IconData refresh = Icons.refresh_outlined;
  static const IconData error = Icons.error_outline;
  static const IconData empty = Icons.inbox_outlined;
  static const IconData imagePlaceholder = Icons.image_outlined;
}
