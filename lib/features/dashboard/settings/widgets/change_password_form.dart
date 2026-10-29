import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

import 'change_password_field.dart';

/// Isi halaman Change Password: tiga kolom dan tombol Update Password.
class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({
    super.key,
    required this.isSaving,
    required this.wrongCurrentPassword,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onCurrentPasswordEdited,
  });

  final bool isSaving;

  /// True kalau server menolak password lama.
  final bool wrongCurrentPassword;
  final void Function(String currentPassword, String newPassword) onSubmit;
  final VoidCallback onForgotPassword;

  /// Dipanggil saat password lama diketik ulang setelah ditolak.
  final VoidCallback onCurrentPasswordEdited;

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  static const String _rule =
      'Must be at least 8 characters with numbers and letters';

  static final RegExp _letter = RegExp(r'[A-Za-z]');
  static final RegExp _digit = RegExp(r'\d');

  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _currentController.addListener(_updateCanSubmit);
    _newController.addListener(_updateCanSubmit);
    _confirmController.addListener(_updateCanSubmit);
  }

  @override
  void didUpdateWidget(ChangePasswordForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Pesan "password lama salah" dibaca validator, jadi validasi diulang
    // setelah tampilan diperbarui.
    if (oldWidget.wrongCurrentPassword != widget.wrongCurrentPassword) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _formKey.currentState?.validate();
      });
    }
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// Tombol aktif kalau ketiga kolom sudah terisi.
  void _updateCanSubmit() {
    final canSubmit =
        _currentController.text.isNotEmpty &&
        _newController.text.isNotEmpty &&
        _confirmController.text.isNotEmpty;

    if (canSubmit != _canSubmit) setState(() => _canSubmit = canSubmit);
  }

  String? _validateCurrent(String? value) {
    if ((value ?? '').isEmpty) return 'Enter your current password';
    if (widget.wrongCurrentPassword) return 'Current password is incorrect';
    return null;
  }

  String? _validateNew(String? value) {
    final password = value ?? '';
    final valid =
        password.length >= 8 &&
        _letter.hasMatch(password) &&
        _digit.hasMatch(password);

    return valid ? null : _rule;
  }

  String? _validateConfirm(String? value) {
    return value == _newController.text ? null : 'Passwords do not match';
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    widget.onSubmit(_currentController.text, _newController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChangePasswordField(
              label: 'Current Password',
              hint: 'Enter your current password',
              controller: _currentController,
              validator: _validateCurrent,
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                if (widget.wrongCurrentPassword) {
                  widget.onCurrentPasswordEdited();
                }
              },
              trailing: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: AppTypography.bodyMedium(
                    color: AppPalette.profileAccent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ChangePasswordField(
              label: 'New Password',
              hint: 'Enter new password',
              controller: _newController,
              validator: _validateNew,
              helperText: _rule,
              textInputAction: TextInputAction.next,
            ),
            // Lebih besar dari 24 karena Figma memberi jarak setelah teks bantu.
            const SizedBox(height: 30),
            ChangePasswordField(
              label: 'Confirm Password',
              hint: 'Re-enter new password',
              controller: _confirmController,
              validator: _validateConfirm,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (_canSubmit && !widget.isSaving) _submit();
              },
            ),
            const SizedBox(height: 32),
            _UpdateButton(
              canSubmit: _canSubmit,
              isSaving: widget.isSaving,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdateButton extends StatelessWidget {
  const _UpdateButton({
    required this.canSubmit,
    required this.isSaving,
    required this.onPressed,
  });

  final bool canSubmit;
  final bool isSaving;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Saat menyimpan, tombol nonaktif tapi tetap berwarna aktif.
    final active = canSubmit || isSaving;

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: canSubmit && !isSaving ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.profileAccent,
          foregroundColor: AppPalette.baseWhite,
          disabledBackgroundColor: active
              ? AppPalette.profileAccent
              : AppPalette.profileDisabledFill,
          disabledForegroundColor: active
              ? AppPalette.baseWhite
              : AppPalette.profileMutedIcon,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSaving
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppPalette.baseWhite,
                ),
              )
            : Text('Update Password', style: AppTypography.titleSmall()),
      ),
    );
  }
}
