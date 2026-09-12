import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../networks/api_acess.dart';
import '../../../../helpers/loading_helper.dart';
import '../../../../common_widgets/custom_rich_text_button.dart';

import 'package:pinput/pinput.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
          _timer?.cancel();
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 55.h,
      textStyle: TextFontStyle.textStyle16c191919InterTight600,
      decoration: BoxDecoration(
        color: AppColors.cF2F2F2,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.c191919),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.cFFFFFF,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: IconButton(
            onPressed: () => NavigationService.goBackCall(),
            padding: EdgeInsets.zero,
            icon: Assets.icons.arrowBackBlack.image(
              width: 24.r,
              height: 24.r,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpace(20.h),
                Text("Vérification OTP",
                    style: TextFontStyle.textStyle28c000000InterTight500
                        .copyWith(fontWeight: FontWeight.w700)),
                UIHelper.verticalSpace(12.h),
                Text(
                  "Veuillez saisir le code de vérification envoyé à ${widget.email}",
                  style: TextFontStyle.textStyle14c4D4D4DInterTight500,
                ),
                UIHelper.verticalSpace(40.h),
                Center(
                  child: Pinput(
                    length: 6,
                    controller: _otpController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Veuillez saisir un code OTP valide";
                      }
                      return null;
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 9.h),
                          width: 22.w,
                          height: 1.h,
                          color: AppColors.c191919,
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelper.verticalSpace(40.h),
                CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool success = await postVerifyOTPRxObj
                          .postVerifyOTP(
                            email: widget.email,
                            otp: _otpController.text,
                          )
                          .waitingForFutureWithoutBg();

                      if (success) {
                        NavigationService.navigateToWithArgs(
                          Routes.resetPasswordScreen,
                          {
                            "email": widget.email,
                            "otp": _otpController.text,
                          },
                        );
                      }
                    }
                  },
                  title: "Vérifier",
                  height: 55.h,
                ),
                UIHelper.verticalSpace(20.h),
                Center(
                  child: _canResend
                      ? CustomRichTextButton(
                          onPressed: () async {
                            bool success = await postResendOtpRxObj
                                .postResendOtp(email: widget.email)
                                .waitingForFutureWithoutBg();
                            if (success) {
                              _startTimer();
                            }
                          },
                          additionalText: "Vous n'avez pas reçu de code ? ",
                          buttonText: "Renvoyer",
                        )
                      : Text(
                          "Renvoyer le code dans ${_formatTime(_secondsRemaining)}",
                          style: TextFontStyle.textStyle14c4D4D4DInterTight500,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
