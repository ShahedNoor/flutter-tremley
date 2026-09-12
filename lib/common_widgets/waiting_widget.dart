import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../gen/colors.gen.dart';

class WaitingWidget extends StatelessWidget {
  final double? size;
  final Color? color;
  final double strokeWidth;

  const WaitingWidget({
    super.key,
    this.size,
    this.color,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    final double indicatorSize = size ?? 40.r;
    return Center(
      child: SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: CircularProgressIndicator(
          color: color ?? AppColors.allPrimaryColor,
          strokeWidth: strokeWidth,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
