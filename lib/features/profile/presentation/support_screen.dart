import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../common_widgets/custom_toast.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/loading_helper.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  final List<String> _subjects = [
    "Problème avec une réservation",
    "Question sur le paiement",
    "Problème technique de l'application",
    "Question sur les points de fidélité",
    "Autre demande",
  ];

  @override
  void initState() {
    super.initState();
    final profile = getProfileRxObj.dataFetcher.hasValue
        ? getProfileRxObj.dataFetcher.value.data?.user
        : null;
    if (profile != null) {
      if (profile.name != null && profile.name!.isNotEmpty) {
        _nameController.text = profile.name!;
      }
      if (profile.email != null && profile.email!.isNotEmpty) {
        _emailController.text = profile.email!;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showSubjectPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cFFFFFF,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: UIHelper.kDefaulutPadding(), vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sélectionner un sujet",
                  style: TextFontStyle.textStyle18c191919Inter700,
                ),
                UIHelper.verticalSpace(16.h),
                ...List.generate(_subjects.length, (index) {
                  final subj = _subjects[index];
                  final isSelected = _subjectController.text == subj;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _subjectController.text = subj;
                      });
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 14.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.allPrimaryColor.withValues(alpha: 0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subj,
                            style: TextFontStyle.textStyle15c222222InterTight500
                                .copyWith(
                              color: isSelected
                                  ? AppColors.allPrimaryColor
                                  : AppColors.c191919,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check,
                                color: AppColors.allPrimaryColor, size: 20.sp),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      bool success = await postHelpSupportRxObj
          .postSupport(
            subject: _subjectController.text.trim(),
            message: _messageController.text.trim(),
            email: _emailController.text.trim(),
            name: _nameController.text.trim(),
          )
          .waitingForFutureWithoutBg();

      if (success) {
        customToastMessage(
            "Succès", "Votre message a été envoyé avec succès !");
        NavigationService.goBackCall();
      }
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
          "Aide & Support",
          style: TextFontStyle.textStyle24c000000InterTight700
              .copyWith(fontSize: 22.sp),
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
                    Text(
                      "Besoin d’aide ? Contactez-nous.",
                      style: TextFontStyle.textStyle16cA5A5A5InterTight600,
                    ),
                    UIHelper.verticalSpace(24.h),
                    CustomTextFormField(
                      controller: _nameController,
                      label: "Nom",
                      hintText: "Entrez votre nom",
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? "Le nom est requis"
                          : null,
                    ),
                    UIHelper.verticalSpace(20.h),
                    CustomTextFormField(
                      controller: _emailController,
                      label: "Adresse e-mail",
                      hintText: "Entrez votre adresse e-mail",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "L'adresse e-mail est requise";
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value.trim())) {
                          return "Veuillez entrer une adresse e-mail valide";
                        }
                        return null;
                      },
                    ),
                    UIHelper.verticalSpace(20.h),
                    CustomTextFormField(
                      controller: _subjectController,
                      label: "Sujet",
                      hintText: "Sélectionner un sujet",
                      readOnly: true,
                      onTap: _showSubjectPicker,
                      suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.c191919),
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? "Le sujet est requis"
                          : null,
                    ),
                    UIHelper.verticalSpace(20.h),
                    CustomTextFormField(
                      controller: _messageController,
                      label: "Message",
                      hintText:
                          "Je vous contacte car je rencontre un problème avec...",
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      contentPadding: EdgeInsets.all(16.r),
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? "Le message est requis"
                          : null,
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
                  onPressed: _handleSubmit,
                  title: "Envoyer",
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
