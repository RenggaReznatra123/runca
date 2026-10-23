import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/ui/dimension.dart';

/// Horizontal divider with a centered label, e.g. "Or".
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.label = 'Or'});

  final String label;

  static const double _lineInset = 28;
  static const double _lineHeight = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _lineInset),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: AppPalette.borderNeutral,
              height: _lineHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.s12),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppPalette.textNeutralSecondary,
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              color: AppPalette.borderNeutral,
              height: _lineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
