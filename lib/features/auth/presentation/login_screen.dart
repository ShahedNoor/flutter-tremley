import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_textform_field.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../common_widgets/custom_rich_text_button.dart';
import '../../../../networks/api_acess.dart';
import '../../../../helpers/loading_helper.dart';
import '../../../../constants/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpace(10.h),
                // Top Bar
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 100.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.cF2F2F2,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: AppColors.c191919,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelper.verticalSpace(30.h),
                Text("Se connecter",
                    style: TextFontStyle.textStyle28c000000InterTight500
                        .copyWith(fontWeight: FontWeight.w700)),
                UIHelper.verticalSpace(12.h),
                Text(
                  "Bienvenue à nouveau. Veuillez saisir vos informations pour continuer.",
                  style: TextFontStyle.textStyle14c4D4D4DInterTight500,
                ),
                UIHelper.verticalSpace(30.h),
                CustomTextFormField(
                  controller: _emailController,
                  label: "Adresse e-mail",
                  hintText: "Entrez votre adresse e-mail",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppColors.c191919),
                  validator: emailValidator,
                ),
                UIHelper.verticalSpace(20.h),
                CustomTextFormField(
                  controller: _passwordController,
                  label: "Mot de passe",
                  hintText: "*************",
                  isPassword: true,
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: AppColors.c191919),
                  validator: passwordValidator,
                ),
                UIHelper.verticalSpace(12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomRichTextButton(
                    onPressed: () {
                      NavigationService.navigateTo(Routes.forgotPasswordScreen);
                    },
                    additionalText: "",
                    buttonText: "Mot de passe oublié",
                  ),
                ),
                UIHelper.verticalSpace(30.h),
                Center(
                  child: CustomRichTextButton(
                    onPressed: () =>
                        NavigationService.navigateTo(Routes.signupScreen),
                    additionalText: "Vous n'avez pas de compte ? ",
                    buttonText: "S'inscrire",
                  ),
                ),
                UIHelper.verticalSpace(30.h),
                CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool success = await postLoginRxObj
                          .postLogin(
                            email: _emailController.text,
                            password: _passwordController.text,
                          )
                          .waitingForFutureWithoutBg();

                      if (success) {
                        NavigationService.navigateToReplacement(
                            Routes.navigationScreen);
                      }
                    }
                  },
                  title: "Se connecter",
                  height: 55.h,
                ),
                UIHelper.verticalSpace(30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconPath;
  final String title;

  const SocialButton({
    super.key,
    required this.onPressed,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55.h,
        decoration: BoxDecoration(
          color: AppColors.cEEEEEE,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 24.h),
            UIHelper.horizontalSpace(12.w),
            Text(
              title,
              style: TextFontStyle.textStyle16c191919InterTight600,
            ),
          ],
        ),
      ),
    );
  }
}
