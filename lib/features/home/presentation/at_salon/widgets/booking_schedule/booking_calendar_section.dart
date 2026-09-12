import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

class BookingCalendarSection extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const BookingCalendarSection({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<BookingCalendarSection> createState() => _BookingCalendarSectionState();
}

class _BookingCalendarSectionState extends State<BookingCalendarSection> {
  late DateTime _focusedDate;

  @override
  void initState() {
    super.initState();
    _focusedDate = widget.selectedDate;
  }

  void _previousMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy', 'fr_FR')
                  .format(_focusedDate)
                  .capitalize(),
              style: TextFontStyle.textStyle20c191919Inter600,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: _previousMonth,
                  child: Icon(Icons.keyboard_arrow_left_rounded,
                      size: 28.r, color: AppColors.c191919),
                ),
                UIHelper.horizontalSpace(16.w),
                GestureDetector(
                  onTap: _nextMonth,
                  child: Icon(Icons.keyboard_arrow_right_rounded,
                      size: 28.r, color: AppColors.c191919),
                ),
              ],
            ),
          ],
        ),
        UIHelper.verticalSpace(20.h),
        // Weekdays Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ["LUN", "MAR", "MER", "JEU", "VEN", "SAM", "DIM"]
              .map((day) => Expanded(
                    child: Center(
                      child: Text(day,
                          style: TextFontStyle.textStyle12c8A8A8AInter500),
                    ),
                  ))
              .toList(),
        ),
        UIHelper.verticalSpace(12.h),
        // Days Grid
        _buildDaysGrid(),
      ],
    );
  }

  Widget _buildDaysGrid() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0);

    // Adjust for Monday start (Dart DateTime.weekday: 1 = Mon, 7 = Sun)
    int firstWeekday = firstDayOfMonth.weekday; // 1 to 7
    int leadingEmptyDays = firstWeekday - 1;

    final daysInMonth = lastDayOfMonth.day;
    final List<DateTime?> calendarDays = [];

    // Prev month days
    final prevMonthLastDay = DateTime(_focusedDate.year, _focusedDate.month, 0);
    for (int i = leadingEmptyDays - 1; i >= 0; i--) {
      calendarDays.add(DateTime(prevMonthLastDay.year, prevMonthLastDay.month,
          prevMonthLastDay.day - i));
    }

    // Current month days
    for (int i = 1; i <= daysInMonth; i++) {
      calendarDays.add(DateTime(_focusedDate.year, _focusedDate.month, i));
    }

    // Remaining slots to fill the last row (up to 42 total slots like most calendars)
    int remaining = 42 - calendarDays.length;
    for (int i = 1; i <= remaining; i++) {
      calendarDays.add(DateTime(_focusedDate.year, _focusedDate.month + 1, i));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: calendarDays.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final date = calendarDays[index];
        if (date == null) return const SizedBox.shrink();

        final bool isSelected = date.year == widget.selectedDate.year &&
            date.month == widget.selectedDate.month &&
            date.day == widget.selectedDate.day;

        final bool isCurrentMonth = date.month == _focusedDate.month;
        final bool isPast =
            date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

        return GestureDetector(
          onTap: isPast
              ? null
              : () {
                  widget.onDateChanged(date);
                },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.c222222 : AppColors.cFFFFFF,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected ? AppColors.c222222 : AppColors.cEEEEEE,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.cFFFFFF
                      : (isCurrentMonth && !isPast
                          ? AppColors.c191919
                          : AppColors.cA5A5A5),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
