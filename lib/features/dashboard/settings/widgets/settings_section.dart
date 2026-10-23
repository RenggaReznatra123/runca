import 'package:flutter/material.dart';
import 'package:runca/ui/typography.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  static const Color _panelColor = Color(0xFFF8F8F8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1, bottom: 8),
          child: Text(
            title,
            style: AppTypography.bodySmall(
              color: const Color(0xFF8293AD),
            ).copyWith(fontSize: 12),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _panelColor,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }
}
