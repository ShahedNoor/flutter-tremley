import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../networks/api_acess.dart';
import '../../../helpers/loading_helper.dart';
import '../model/profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  final User? user;
  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name);
    _phoneController = TextEditingController(text: widget.user?.phone);
    _emailController = TextEditingController(text: widget.user?.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Appareil photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
          "Modifier le profil",
          style: TextFontStyle.textStyle24c000000InterTight700
              .copyWith(fontSize: 22.sp),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  Padding(
                    padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          controller: _nameController,
                          label: "Nom complet",
                          hintText: "Entrez votre nom",
                        ),
                        UIHelper.verticalSpace(20.h),
                        CustomTextFormField(
                          controller: _phoneController,
                          label: "Téléphone",
                          hintText: "Entrez votre numéro de téléphone",
                          keyboardType: TextInputType.phone,
                        ),
                        UIHelper.verticalSpace(20.h),
                        CustomTextFormField(
                          controller: _emailController,
                          label: "Adresse e-mail",
                          hintText: "Entrez votre adresse e-mail",
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
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
                  bool success = await postProfileUpdateRxObj
                      .postProfileUpdate(
                        name: _nameController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                        imagePath: _imageFile?.path,
                      )
                      .waitingForFutureWithoutBg();

                  if (success) {
                    getProfileRxObj.fetchProfile();
                    NavigationService.goBack;
                  }
                },
                title: "Enregistrer",
                backgroundColor: AppColors.c1B1B1B,
                foregroundColor: AppColors.cFFFFFF,
                height: 56.h,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      color: AppColors.cFBFBFB,
      child: Column(
        children: [
          Stack(
            children: [
              if (_imageFile != null)
                Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                AppNetworkImage(
                  imageUrl: widget.user?.profileImage ??
                      'https://i.ibb.co/vzG7g7r/barber.png',
                  width: 100.r,
                  height: 100.r,
                  isProfilePicture: true,
                ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          GestureDetector(
            onTap: () => _showPicker(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.cF2F2F2),
              ),
              child: Text(
                "Change Photo",
                style: TextFontStyle.textStyle14cB08D2ARoboto500.copyWith(
                  color: AppColors.cB08D2A,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
