import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_textform_field.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../networks/api_acess.dart';
import '../../../../helpers/loading_helper.dart';
import '../../../../constants/validator.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Text("Nouveau mot de passe",
                    style: TextFontStyle.textStyle28c000000InterTight500
                        .copyWith(fontWeight: FontWeight.w700)),
                UIHelper.verticalSpace(12.h),
                Text(
                  "Veuillez créer un nouveau mot de passe pour votre compte.",
                  style: TextFontStyle.textStyle14c4D4D4DInterTight500,
                ),
                UIHelper.verticalSpace(40.h),
                CustomTextFormField(
                  controller: _passwordController,
                  label: "Nouveau mot de passe",
                  hintText: "*************",
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.c191919),
                  validator: passwordValidator,
                ),
                UIHelper.verticalSpace(20.h),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  label: "Confirmer le mot de passe",
                  hintText: "*************",
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.c191919),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Les mots de passe ne correspondent pas";
                    }
                    return null;
                  },
                ),
                UIHelper.verticalSpace(40.h),
                CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Get the token from verifyOtp response
                      final verifyResponse = postVerifyOTPRxObj.dataFetcher.value;
                      String token = verifyResponse['data']['reset_password_token'] ?? "";

                      bool success = await postResetPasswordRxObj
                          .postResetPassword(
                            token: token,
                            email: widget.email,
                            password: _passwordController.text,
                            passwordConfirmation: _confirmPasswordController.text,
                          )
                          .waitingForFutureWithoutBg();

                      if (success) {
                        NavigationService.navigateToUntilReplacement(Routes.loginScreen);
                      }
                    }
                  },
                  title: "Réinitialiser",
                  height: 55.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
