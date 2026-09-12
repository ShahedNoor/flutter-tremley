import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/features/home/model/booking_slots_model.dart';

class BookingTimeSlotsSection extends StatelessWidget {
  final List<Slot> slots;
  final Slot? selectedSlot;
  final Function(Slot) onSlotSelected;

  const BookingTimeSlotsSection({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Heure disponible",
            style: TextFontStyle.textStyle20c191919Inter600,
          ),
          UIHelper.verticalSpace(16.h),
          Center(
            child: Text(
              "Aucun créneau disponible pour cette date",
              style: TextFontStyle.textStyle14c8A8A8AInter500,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Heure disponible",
          style: TextFontStyle.textStyle20c191919Inter600,
        ),
        UIHelper.verticalSpace(16.h),
        LayoutBuilder(builder: (context, constraints) {
          double width = (constraints.maxWidth - 24.w) / 3;

          return Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: List.generate(slots.length, (index) {
              final slot = slots[index];
              final startTime = slot.startTime;
              final endTime = slot.endTime;

              String timeRange = "";
              if (startTime != null && endTime != null) {
                timeRange =
                    "${DateFormat('HH:mm').format(startTime.toUtc())} - ${DateFormat('HH:mm').format(endTime.toUtc())}";
              }

              final isSelected = selectedSlot?.slotId == slot.slotId;

              return GestureDetector(
                onTap: () => onSlotSelected(slot),
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF222222)
                        : AppColors.cFFFFFF,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color:
                          isSelected ? Colors.transparent : AppColors.cF0F0F0,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      timeRange,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.cFFFFFF
                            : const Color(0xFF222222),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
