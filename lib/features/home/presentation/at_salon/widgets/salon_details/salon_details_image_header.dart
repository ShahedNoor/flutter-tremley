import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/app_network_image.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/features/home/model/salon_or_barber_model.dart';

class SalonDetailsImageHeader extends StatefulWidget {
  final SalonOrBarber salon;

  const SalonDetailsImageHeader({
    super.key,
    required this.salon,
  });

  @override
  State<SalonDetailsImageHeader> createState() =>
      _SalonDetailsImageHeaderState();
}

class _SalonDetailsImageHeaderState extends State<SalonDetailsImageHeader> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build list of image URLs from gallery images, profile image, and cover image
    final List<String> images = [];
    if (widget.salon.galleryImages != null &&
        widget.salon.galleryImages!.isNotEmpty) {
      for (var img in widget.salon.galleryImages!) {
        if (img.image != null && img.image!.isNotEmpty) {
          images.add(img.image!);
        }
      }
    }
    if (images.isEmpty &&
        widget.salon.profileImage != null &&
        widget.salon.profileImage!.isNotEmpty) {
      images.add(widget.salon.profileImage!);
    }
    if (widget.salon.coverImage != null &&
        widget.salon.coverImage!.isNotEmpty) {
      images.add(widget.salon.coverImage!);
    }
    // Fallback default image in case there are none
    if (images.isEmpty) {
      images.add(
          "https://images.unsplash.com/photo-1512690199101-8dfa66a30960?q=80&w=2070");
    }

    return Stack(
      children: [
        // Image Carousel
        SizedBox(
          height: 300.h,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return AppNetworkImage(
                imageUrl: images[index],
                height: 300.h,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),

        // Carousel Indicator Dots
        if (images.length > 1)
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  height: 8.h,
                  width: _currentIndex == index ? 24.w : 8.w,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppColors.c191919
                        : AppColors.cFFFFFF.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ),

        // Back Button
        Positioned(
          top: 50.h,
          left: 20.w,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 44.w,
              width: 44.w,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                border: Border.all(color: AppColors.cEEEEEE),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Assets.icons.arrowBackGolden.image(
                width: 24.r,
                height: 24.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
