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

import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController(text: "+33");
  final _postalController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_phoneListener);
  }

  void _phoneListener() {
    if (!_phoneController.text.startsWith("+33")) {
      _phoneController.text = "+33";
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_phoneListener);
    _nameController.dispose();
    _phoneController.dispose();
    _postalController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: AppColors.c191919,
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                UIHelper.verticalSpace(30.h),
                Text(
                  "Créer un compte",
                  style: TextFontStyle.textStyle28c000000InterTight500.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                UIHelper.verticalSpace(12.h),
                Text(
                  "Créez votre compte pour commencer à réserver des services.",
                  style: TextFontStyle.textStyle14c4D4D4DInterTight500,
                ),
                UIHelper.verticalSpace(30.h),
                CustomTextFormField(
                  controller: _nameController,
                  label: "Nom complet",
                  hintText: "Entrez votre nom",
                  prefixIcon: const Icon(Icons.person_outline,
                      color: AppColors.c191919),
                  validator: (value) => value == null || value.isEmpty
                      ? "Veuillez entrer votre nom"
                      : null,
                ),
                UIHelper.verticalSpace(20.h),
                CustomTextFormField(
                  controller: _phoneController,
                  label: "Téléphone",
                  hintText: "Entrez votre numéro de téléphone",
                  keyboardType: TextInputType.phone,
                  maxLength: 12,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[+0-9]')),
                  ],
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: AppColors.c191919),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "+33") {
                      return "Veuillez entrer votre téléphone";
                    }
                    if (value.length < 12) {
                      return "Le numéro doit comporter 9 chiffres après +33";
                    }
                    return null;
                  },
                ),
                UIHelper.verticalSpace(20.h),
                CustomTextFormField(
                  controller: _postalController,
                  label: "Code postal",
                  hintText: "Entrez votre code postal",
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.location_on_outlined,
                      color: AppColors.c191919),
                  validator: (value) => value == null || value.isEmpty
                      ? "Veuillez entrer votre code postal"
                      : null,
                ),
                UIHelper.verticalSpace(20.h),
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
                UIHelper.verticalSpace(20.h),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  label: "Confirmez le mot de passe",
                  hintText: "*************",
                  isPassword: true,
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: AppColors.c191919),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez confirmer votre mot de passe";
                    }
                    if (value != _passwordController.text) {
                      return "Les mots de passe ne correspondent pas";
                    }
                    return null;
                  },
                ),
                UIHelper.verticalSpace(20.h),
                Row(
                  children: [
                    SizedBox(
                      height: 24.w,
                      width: 24.w,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                        activeColor: AppColors.c191919,
                        side: const BorderSide(color: AppColors.c000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpace(8.w),
                    Expanded(
                      child: Text(
                        "J'accepte les conditions générales",
                        style: TextFontStyle.textStyle14c4D4D4DInterTight500,
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(30.h),
                Center(
                  child: CustomRichTextButton(
                    onPressed: () =>
                        NavigationService.navigateTo(Routes.loginScreen),
                    additionalText: "Vous avez déjà un compte ? ",
                    buttonText: "Se connecter",
                  ),
                ),
                UIHelper.verticalSpace(30.h),
                CustomButton(
                  onPressed: _acceptTerms
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            bool success = await postSignupRxObj
                                .postSignup(
                                  name: _nameController.text,
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  passwordConfirmation:
                                      _confirmPasswordController.text,
                                  postalCode: _postalController.text,
                                )
                                .waitingForFutureWithoutBg();

                            if (success) {
                              NavigationService.navigateToReplacement(
                                  Routes.navigationScreen);
                            }
                          }
                        }
                      : null,
                  title: "S'inscrire",
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
