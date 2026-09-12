import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../networks/api_acess.dart';
import '../../../helpers/loading_helper.dart';
import '../../../helpers/di.dart';
import '../../../networks/dio/dio.dart';
import '../model/profile_model.dart';
import 'widgets/profile_shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    getProfileRxObj.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: AppBar(
        backgroundColor: AppColors.cFFFFFF,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Compte",
          style: TextFontStyle.textStyle24c000000InterTight700
              .copyWith(fontSize: 22.sp),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.allPrimaryColor,
        backgroundColor: AppColors.cFFFFFF,
        onRefresh: () async {
          await getProfileRxObj.fetchProfile();
        },
        child: StreamBuilder<ProfileModel>(
          stream: getProfileRxObj.dataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.data?.data?.user == null) {
              return const ProfileShimmer();
            }

            final user = snapshot.data?.data?.user;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserCard(user),
                  UIHelper.verticalSpace(30.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cFFFFFF,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.cF2F2F2),
                    ),
                    child: Column(
                      children: [
                        _buildProfileItem(
                          icon: Assets.icons.profileOutlinedBlack,
                          title: "Profil",
                          onTap: () {
                            NavigationService.navigateToWithObject(
                                Routes.editProfileScreen, user);
                          },
                          showBorder: false,
                        ),
                        Divider(
                            color: AppColors.cF2F2F2,
                            height: 1,
                            indent: 16.w,
                            endIndent: 16.w),
                        _buildProfileItem(
                          icon: Assets.icons.settingsOutlinedBlack,
                          title: "Paramètres",
                          onTap: () {
                            NavigationService.navigateTo(Routes.settingsScreen);
                          },
                          showBorder: false,
                        ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpace(16.h),
                  _buildProfileItem(
                    icon: Assets.icons.supportOutlinedBlack,
                    title: "Aide / Support",
                    onTap: () {
                      NavigationService.navigateTo(Routes.supportScreen);
                    },
                  ),
                  UIHelper.verticalSpace(16.h),
                  _buildProfileItem(
                    icon: Assets.icons.legalOutlinedBlack,
                    title: "Légal",
                    onTap: () {
                      NavigationService.navigateTo(Routes.legalScreen);
                    },
                  ),
                  UIHelper.verticalSpace(16.h),
                  _buildProfileItem(
                    icon: Assets.icons.supportOutlinedBlack,
                    title: "Questions fréquentes",
                    onTap: () {
                      NavigationService.navigateTo(Routes.faqScreen);
                    },
                  ),
                  UIHelper.verticalSpace(30.h),
                  Text(
                    "Suivez-nous",
                    style: TextFontStyle.textStyle15c222222InterTight500,
                  ),
                  UIHelper.verticalSpace(16.h),
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.cFFFFFF,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.cF2F2F2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSocialItem(
                                Assets.icons.tiktokOutlinedBlack, "Tiktok"),
                            _buildSocialItem(
                                Assets.icons.instagramOutlinedBlack,
                                "Instagram"),
                          ],
                        ),
                        UIHelper.verticalSpace(16.h),
                        CustomButton(
                          onPressed: () {
                            // launch whatsapp
                          },
                          title: "Contactez-nous sur WhatsApp",
                          backgroundColor: AppColors.cFFFFFF,
                          foregroundColor: AppColors.c191919,
                          borderColor: AppColors.cF2F2F2,
                          icon: Assets.icons.whatsappOutlinedBlack
                              .image(width: 20.w, height: 20.w),
                        ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpace(30.h),
                  CustomButton(
                    onPressed: () async {
                      bool success = await postLogoutRxObj
                          .postLogout()
                          .waitingForFutureWithoutBg();

                      if (success) {
                        await appData.write(kKeyAccessToken, "");
                        await appData.write(kKeyIsLoggedIn, false);
                        await appData.remove(kKeyUserID);
                        await appData.remove(kKeyUser);
                        await appData.remove(kKeyFirstName);
                        await appData.remove(kKeyLastName);
                        getProfileRxObj.clean();

                        DioSingleton.instance
                            .create(); // Re-initialize Dio without token
                        NavigationService.navigateToUntilReplacement(
                            Routes.loginScreen);
                      }
                    },
                    title: "Déconnexion",
                    backgroundColor: AppColors.cFFFFFF,
                    foregroundColor: AppColors.cFF4D4F,
                    borderColor: AppColors.cF2F2F2,
                    icon: Icon(
                      Icons.logout_outlined,
                      color: AppColors.cFF4D4F,
                      size: 20.sp,
                    ),
                  ),
                  UIHelper.verticalSpace(30.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserCard(User? user) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cF2F2F2),
      ),
      child: Row(
        children: [
          AppNetworkImage(
            imageUrl:
                user?.profileImage ?? 'https://i.ibb.co/vzG7g7r/barber.png',
            width: 60.r,
            height: 60.r,
            isProfilePicture: true,
          ),
          UIHelper.horizontalSpace(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? "...",
                  style: TextFontStyle.textStyle16c191919InterTight600
                      .copyWith(fontSize: 18.sp),
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  user?.email ?? "...",
                  style: TextFontStyle.textStyle14c8A8A8AInter400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required AssetGenImage icon,
    required String title,
    required VoidCallback onTap,
    bool showBorder = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: showBorder ? BorderRadius.circular(12.r) : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          borderRadius: showBorder ? BorderRadius.circular(12.r) : null,
          border: showBorder ? Border.all(color: AppColors.cF2F2F2) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.cF7F5F0,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: icon.image(width: 24.w, height: 24.w),
            ),
            UIHelper.horizontalSpace(16.w),
            Expanded(
              child: Text(
                title,
                style: TextFontStyle.textStyle15c222222InterTight500,
              ),
            ),
            Assets.icons.arrowRightBlack.image(width: 14.w, height: 14.w),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialItem(AssetGenImage icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.cF7F5F0,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: icon.image(width: 20.w, height: 20.w),
        ),
        UIHelper.verticalSpace(8.h),
        Text(
          label,
          style: TextFontStyle.textStyle14c4D4D4DInterTight500
              .copyWith(fontSize: 12.sp),
        ),
      ],
    );
  }
}
