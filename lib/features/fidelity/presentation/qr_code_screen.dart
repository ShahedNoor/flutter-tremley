import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_button.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.cFFFFFF,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
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
          "Scanner par le barbier",
          style: TextFontStyle.textStyle22c191919InterTight700,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              UIHelper.verticalSpace(10.h),
              Text(
                "Présentez ce code à la caisse",
                textAlign: TextAlign.center,
                style: TextFontStyle.textStyle15c8A8A8AInter500,
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 220.w,
                  height: 220.w,
                  child: PrettyQrView.data(
                    data: appData.read(kKeyUserID)?.toString() ?? "no-user-id",
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                onPressed: () => Navigator.pop(context),
                title: "Retour",
                backgroundColor: AppColors.cF2F2F2,
                foregroundColor: AppColors.c1B1B1B,
                height: 56.h,
                borderRadius: BorderRadius.circular(16.r),
              ),
              UIHelper.verticalSpace(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
