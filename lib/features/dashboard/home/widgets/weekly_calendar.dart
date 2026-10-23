import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key});

  static const List<String> days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    return Row(
      children: List.generate(7, (index) {
        final date = monday.add(Duration(days: index));
        final selected = index == now.weekday - 1;

        return Expanded(
          child: Column(
            children: [
              Text(
                days[index],
                style: const TextStyle(
                  fontSize: 12,
                  color: AppPalette.textNeutralSecondary,
                ),
              ),
              const SizedBox(height: 9),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 40,
                height: 72,
                decoration: BoxDecoration(
                  color: selected ? AppPalette.bgFillPrimary : AppPalette.bg,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? AppPalette.baseWhite
                            : AppPalette.textNeutralPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (selected)
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppPalette.baseWhite,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
