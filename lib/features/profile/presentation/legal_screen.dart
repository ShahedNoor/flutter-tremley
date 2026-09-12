import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common_widgets/custom_toast.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  Future<void> _openUrl(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        customToastMessage("Erreur", "Impossible d'ouvrir le lien");
      }
    } catch (_) {
      customToastMessage("Erreur", "Impossible d'ouvrir le lien");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.cFFFFFF,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: UIHelper.kDefaulutPadding()),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            icon: Assets.icons.arrowBackBlack.image(
              width: 24.r,
              height: 24.r,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Légal",
          style: TextFontStyle.textStyle24c000000InterTight700
              .copyWith(fontSize: 22.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: UIHelper.kDefaulutPadding(), vertical: 12.h),
        child: Column(
          children: [
            _buildLegalItem(
              "Politique de confidentialité",
              () => _openUrl("https://tremley.com/privacy-policy"),
            ),
            _buildLegalItem(
              "Conditions générales d'utilisation (CGU)",
              () => _openUrl("https://tremley.com/terms-and-conditions"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalItem(String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.cFFFFFF,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.cF2F2F2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextFontStyle.textStyle15c222222InterTight500.copyWith(
                    color: AppColors.c191919,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Assets.icons.arrowRightBlack.image(width: 14.w, height: 14.w),
            ],
          ),
        ),
      ),
    );
  }
}
