import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import '../gen/colors.gen.dart';
import '../gen/assets.gen.dart';
import '../constants/text_font_style.dart';
import 'custom_button.dart';
import 'app_network_image.dart';

class ServiceCompletedDialog extends StatefulWidget {
  const ServiceCompletedDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ServiceCompletedDialog(),
    );
  }

  @override
  State<ServiceCompletedDialog> createState() => _ServiceCompletedDialogState();
}

class _ServiceCompletedDialogState extends State<ServiceCompletedDialog> {
  int _rating = 4;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      insetPadding:
          EdgeInsets.symmetric(horizontal: UIHelper.kDefaulutPadding()),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F4EA), // Success green light
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.c16A34A,
                  size: 50.r,
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                "Service terminé avec succès",
                style: TextFontStyle.textStyle24c1B1B1BInterTight700,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                "Nous espérons que vous êtes satisfait du service",
                style: TextFontStyle.textStyle16c7F7F7FInterTight500,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),

              // Fidelity Point Banner
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.cFBF4E0,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Row(
                  children: [
                    Assets.icons.reviewStarGolden
                        .image(width: 24.w, height: 24.w),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        "Vous avez gagné 1 point de fidélité",
                        style: TextFontStyle.textStyle16cB08D2AInterTight600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Barber Details Card
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cF2F2F2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppNetworkImage(
                          imageUrl:
                              "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000", // Placeholder for Thomas Dubois
                          height: 48,
                          width: 48,
                          isProfilePicture: true,
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Thomas Dubois",
                              style: TextFontStyle.textStyle16c222222Inter700,
                            ),
                            UIHelper.verticalSpace(4.h),
                            Text(
                              "+33********** 78",
                              style: TextFontStyle.textStyle13c8A8A8AInter400,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoRow(
                      Assets.icons.scissorsOutlinedGolden
                          .image(width: 20.w, height: 20.w),
                      "Coupe + Barbe (60 min)",
                    ),
                    SizedBox(height: 12.h),
                    _buildInfoRow(
                      Assets.icons.calendarSimpleOutlinedGolden
                          .image(width: 20.w, height: 20.w),
                      "Jeu. 10 Nov 2023 - 10:30",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Rating Section
              Text(
                "Notez votre expérience",
                style: TextFontStyle.textStyle20c222222InterTight600,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: (index < _rating)
                          ? Assets.icons.reviewStarGolden
                              .image(width: 32.w, height: 32.w)
                          : Assets.icons.navigationBarStarGrey
                              .image(width: 32.w, height: 32.w),
                    ),
                  );
                }),
              ),
              SizedBox(height: 24.h),

              // Comment Section
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Laissez un commentaire...",
                  hintStyle: TextFontStyle.textStyle14c8A8A8AInter400,
                  contentPadding: EdgeInsets.all(16.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.cE3E3E3),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.cE3E3E3),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Buttons
              CustomButton(
                onPressed: () => Navigator.pop(context),
                title: "Retour à l'accueil",
              ),
              SizedBox(height: 12.h),
              CustomButton(
                onPressed: () => Navigator.pop(context),
                title: "Voir l'historique",
                backgroundColor: AppColors.cF2F2F2,
                foregroundColor: AppColors.c191919,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(Widget icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cF2F2F2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: icon,
        ),
        UIHelper.horizontalSpace(12.w),
        Expanded(
          child: Text(
            text,
            style: TextFontStyle.textStyle16c1B1B1BInterTight500,
          ),
        ),
      ],
    );
  }
}
