import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';
import 'package:runca/utility/snackbar_extension.dart';

/// Judul aktivitas dengan ikon pensil. Ditekan, judul berubah menjadi
/// kolom isian di tempat yang sama.
class RunSummaryTitle extends StatefulWidget {
  const RunSummaryTitle({
    super.key,
    required this.title,
    required this.onRename,
  });

  final String title;

  /// Mengembalikan true kalau judul berhasil diganti.
  final Future<bool> Function(String title) onRename;

  @override
  State<RunSummaryTitle> createState() => _RunSummaryTitleState();
}

class _RunSummaryTitleState extends State<RunSummaryTitle> {
  static const int _maxLength = 40;

  final TextEditingController _controller = TextEditingController();
  bool _editing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startEdit() {
    _controller.text = widget.title;
    setState(() => _editing = true);
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();

    setState(() => _editing = false);

    if (text.isEmpty || text == widget.title) return;

    final success = await widget.onRename(text);

    if (!mounted || success) return;

    context.showErrorSnackbar('Failed to rename activity.');
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.titleLarge(
      color: AppPalette.textNeutralPrimary,
    );

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: _editing
                ? TextField(
                    controller: _controller,
                    autofocus: true,
                    maxLength: _maxLength,
                    style: style,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      counterText: '',
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppPalette.borderNeutral),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppPalette.profileAccent),
                      ),
                    ),
                  )
                : Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
          ),
          IconButton(
            onPressed: _editing ? _submit : _startEdit,
            icon: Icon(
              _editing ? Icons.check_rounded : Icons.edit_outlined,
              color: _editing
                  ? AppPalette.profileAccent
                  : AppPalette.profileMutedIcon,
            ),
          ),
        ],
      ),
    );
  }
}