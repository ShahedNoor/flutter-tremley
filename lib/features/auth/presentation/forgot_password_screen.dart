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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
                Text("Mot de passe oublié",
                    style: TextFontStyle.textStyle28c000000InterTight500
                        .copyWith(fontWeight: FontWeight.w700)),
                UIHelper.verticalSpace(12.h),
                Text(
                  "Veuillez saisir votre adresse e-mail pour recevoir un code de vérification.",
                  style: TextFontStyle.textStyle14c4D4D4DInterTight500,
                ),
                UIHelper.verticalSpace(40.h),
                CustomTextFormField(
                  controller: _emailController,
                  label: "Adresse e-mail",
                  hintText: "Entrez votre adresse e-mail",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.c191919),
                  validator: emailValidator,
                ),
                UIHelper.verticalSpace(40.h),
                CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool success = await postForgotPasswordRxObj
                          .postForgotPassword(_emailController.text)
                          .waitingForFutureWithoutBg();

                      if (success) {
                        NavigationService.navigateToWithArgs(
                          Routes.verifyOtpScreen,
                          {"email": _emailController.text},
                        );
                      }
                    }
                  },
                  title: "Envoyer le code",
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
