import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common_widgets/custom_button.dart';
import '../../../../../../gen/colors.gen.dart';
import '../../../../../../helpers/ui_helpers.dart';

class FilterBottomSheet extends StatefulWidget {
  final double initialRadius;
  final Function(double) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialRadius,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double _tempRadius;

  @override
  void initState() {
    super.initState();
    _tempRadius = widget.initialRadius;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filtre de distance",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c191919,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.c191919),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          UIHelper.verticalSpace(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rayon de recherche",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.c191919,
                ),
              ),
              Text(
                "${_tempRadius.toInt()} km",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.cB08D2A,
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(10.h),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.cB08D2A,
              inactiveTrackColor: AppColors.cF2F2F2,
              thumbColor: AppColors.cB08D2A,
              overlayColor: AppColors.cB08D2A.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _tempRadius,
              min: 1,
              max: 100,
              divisions: 99,
              onChanged: (value) {
                setState(() {
                  _tempRadius = value;
                });
              },
            ),
          ),
          UIHelper.verticalSpace(30.h),
          CustomButton(
            title: "Appliquer",
            onPressed: () {
              widget.onApply(_tempRadius);
              Navigator.pop(context);
            },
            backgroundColor: AppColors.cB08D2A,
          ),
        ],
      ),
    );
  }
}
