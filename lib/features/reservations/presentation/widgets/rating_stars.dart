import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/assets.gen.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final Function(int)? onRatingChanged;
  final double starSize;

  const RatingStars({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.starSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: onRatingChanged != null ? () => onRatingChanged!(index + 1) : null,
          child: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: (index < rating)
                ? Assets.icons.reviewStarGolden.image(width: starSize.w, height: starSize.w)
                : Assets.icons.navigationBarStarGrey.image(width: starSize.w, height: starSize.w),
          ),
        );
      }),
    );
  }
}
