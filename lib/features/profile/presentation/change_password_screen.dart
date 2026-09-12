import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/api_acess.dart';
import '../../../helpers/loading_helper.dart';
import '../../../constants/validator.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
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
        centerTitle: true,
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
        title: Text(
          "Modifier le mot de passe",
          style: TextFontStyle.textStyle24c000000InterTight700.copyWith(fontSize: 22.sp),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: _currentPasswordController,
                      label: "Mot de passe actuel",
                      hintText: "************",
                      isPassword: true,
                      validator: passwordValidator,
                    ),
                    UIHelper.verticalSpace(20.h),
                    CustomTextFormField(
                      controller: _newPasswordController,
                      label: "Nouveau mot de passe",
                      hintText: "************",
                      isPassword: true,
                      validator: passwordValidator,
                    ),
                    UIHelper.verticalSpace(20.h),
                    CustomTextFormField(
                      controller: _confirmPasswordController,
                      label: "Confirmez le mot de passe",
                      hintText: "************",
                      isPassword: true,
                      validator: (value) =>
                          confirmPasswordValidator(value, _newPasswordController.text),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: true,
              child: Padding(
                padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
                child: CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String email = appData.read(kEmail) ?? "";
                      bool success = await postChangePasswordRxObj
                          .postChangePassword(
                            currentPassword: _currentPasswordController.text,
                            newPassword: _newPasswordController.text,
                            email: email,
                          )
                          .waitingForFutureWithoutBg();

                      if (success) {
                        NavigationService.goBackCall();
                      }
                    }
                  },
                  title: "Mettre à jour le mot de passe",
                  backgroundColor: AppColors.c1B1B1B,
                  foregroundColor: AppColors.cFFFFFF,
                  height: 56.h,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
