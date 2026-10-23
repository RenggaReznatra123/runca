import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runca/ui/dimension.dart';
import 'package:runca/ui/color.dart';

/// Row of single-digit boxes driven by one hidden text field.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.controller,
    this.length = 5,
    this.hasError = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final int length;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  static const double _boxHeight = 48;
  static const double _boxGap = 12;

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color _borderColor(ColorScheme scheme, int index, String code) {
    if (widget.hasError) {
      return scheme.error;
    }

    final isFilled = index < code.length;
    final activeIndex = code.length.clamp(0, widget.length - 1);
    final isActive = _focusNode.hasFocus && index == activeIndex;

    return isFilled || isActive ? scheme.primary : scheme.outline;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Verification code',
      textField: true,
      child: SizedBox(
        height: _boxHeight,
        child: ListenableBuilder(
          listenable: Listenable.merge([widget.controller, _focusNode]),
          builder: (context, _) {
            final code = widget.controller.text;

            return Stack(
              children: [
                Row(
                  children: [
                    for (var i = 0; i < widget.length; i++) ...[
                      if (i > 0) const SizedBox(width: _boxGap),
                      Expanded(
                        child: _OtpBox(
                          digit: i < code.length ? code[i] : '',
                          borderColor: _borderColor(scheme, i, code),
                        ),
                      ),
                    ],
                  ],
                ),
                // Invisible field on top: it receives taps and keyboard input.
                Positioned.fill(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(widget.length),
                    ],
                    showCursor: false,
                    enableInteractiveSelection: false,
                    cursorColor: AppPalette.baseBlack.withValues(alpha: 0),
                    style: TextStyle(
                      color: AppPalette.baseBlack.withValues(alpha: 0),
                    ),
                    decoration: const InputDecoration(
                      filled: false,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                    onChanged: widget.onChanged,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.digit, required this.borderColor});

  final String digit;
  final Color borderColor;

  static const double _borderWidth = 1.5;
  static const double _digitFontSize = 20;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: borderColor, width: _borderWidth),
      ),
      child: Center(
        child: Text(
          digit,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: _digitFontSize,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
