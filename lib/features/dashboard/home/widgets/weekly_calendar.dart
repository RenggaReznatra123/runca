import 'package:flutter/material.dart';
import 'package:runca/ui/color.dart';
import 'package:runca/features/dashboard/home/models/home_model.dart';
import 'package:runca/utility/format_utils.dart';

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key, required this.weekDays});

  final List<WeeklyCalendarDay> weekDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: weekDays
          .map((day) {
            final date = day.date;
            final selected = day.isToday;
            return Expanded(
              child: Column(
                children: [
                  Text(
                    AppFormat.weekdayShort(date),
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
                      color: selected
                          ? AppPalette.bgFillPrimary
                          : AppPalette.bg,
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
          })
          .toList(growable: false),
    );
  }
}
