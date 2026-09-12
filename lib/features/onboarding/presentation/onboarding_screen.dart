import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/ui_helpers.dart';

import '../../../../helpers/di.dart';
import '../../../../constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "RDV au salon",
      "description":
          "Trouvez un salon près de vous et réservez en quelques clics.",
      "image": Assets.images.onboardingOne.path,
    },
    {
      "title": "Barbier à domicile",
      "description":
          "Pour le service à domicile, le paiement en ligne est obligatoire. Suivez votre barbier en temps réel pendant le trajet.",
      "image": Assets.images.onboardingTwo.path,
    },
    {
      "title": "Récompenses de fidélité",
      "description":
          "Scannez votre code QR personnel en salon pour cumuler des points et débloquer des récompenses exclusives.",
      "image": Assets.images.onboardingThree.path,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      UIHelper.verticalSpace(20.h),
                      // Image Container
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              _onboardingData[index]["image"]!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      UIHelper.verticalSpace(20.h),
                      // Title
                      Text(
                        _onboardingData[index]["title"]!,
                        style:
                            TextFontStyle.textStyle28c000000PlayfairDisplay500,
                        textAlign: TextAlign.center,
                      ),
                      UIHelper.verticalSpace(16.h),
                      // Subtitle
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          _onboardingData[index]["description"]!,
                          style: TextFontStyle.textStyle20c7F7F7FInterTight500
                              .copyWith(height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      UIHelper.verticalSpace(40.h),
                    ],
                  );
                },
              ),
            ),
            // Bottom Section: Progress + Next Button + Passer
            SizedBox(
              height: 140.h,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 70.w,
                        height: 70.w,
                        child: CircularProgressIndicator(
                          value: (_currentIndex + 1) / _onboardingData.length,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.cB08D2A),
                          backgroundColor: AppColors.cF3F3F3,
                          strokeWidth: 2.w,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_currentIndex < _onboardingData.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          } else {
                            await appData.write(kKeyfirstTime, false);
                            NavigationService.navigateToReplacement(
                                Routes.loginScreen);
                          }
                        },
                        child: Container(
                          width: 55.w,
                          height: 55.w,
                          decoration: const BoxDecoration(
                            color: AppColors.cB08D2A,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: AppColors.cFFFFFF,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(12.h),
                  GestureDetector(
                    onTap: () async {
                      await appData.write(kKeyfirstTime, false);
                      NavigationService.navigateToReplacement(
                          Routes.loginScreen);
                    },
                    child: Text(
                      "Passer",
                      style: TextFontStyle.textStyle14cB08D2AInterTight500,
                    ),
                  )
                ],
              ),
            ),
            UIHelper.verticalSpace(20.h),
          ],
        ),
      ),
    );
  }
}
