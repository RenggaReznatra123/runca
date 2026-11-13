import 'package:flutter/material.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/typography.dart';

enum ActivityMenuAction { mapStyle, edit, delete }

/// Tombol titik tiga di atas peta detail, dengan popup menu di bawahnya.
class ActivityMoreMenu extends StatelessWidget {
  const ActivityMoreMenu({super.key, required this.onSelected});

  final ValueChanged<ActivityMenuAction> onSelected;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyLarge(color: AppPalette.textNeutralPrimary);

    return Material(
      color: AppPalette.baseWhite,
      elevation: 2,
      shadowColor: AppPalette.baseBlack.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: PopupMenuButton<ActivityMenuAction>(
        tooltip: '',
        position: PopupMenuPosition.under,
        offset: const Offset(0, 12),
        color: AppPalette.baseWhite,
        surfaceTintColor: AppPalette.baseWhite,
        elevation: 8,
        menuPadding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: onSelected,
        itemBuilder: (context) => [
          PopupMenuItem<ActivityMenuAction>(
            value: ActivityMenuAction.mapStyle,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Map Style', style: style),
          ),
          PopupMenuItem<ActivityMenuAction>(
            value: ActivityMenuAction.edit,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Edit Activity', style: style),
          ),
          PopupMenuItem<ActivityMenuAction>(
            value: ActivityMenuAction.delete,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Delete Activity',
              style: style.copyWith(color: AppPalette.textDanger),
            ),
          ),
        ],
        child: const SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            Icons.more_vert_rounded,
            size: 20,
            color: AppPalette.textNeutralPrimary,
          ),
        ),
      ),
    );
  }
}