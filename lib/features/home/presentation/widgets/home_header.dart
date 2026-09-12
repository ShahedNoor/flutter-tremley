import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common_widgets/address_search_bottom_sheet.dart';
import '../../../../../common_widgets/app_network_image.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/di.dart';
import '../../../../../helpers/location_service.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../../navigation_screen.dart';
import '../../../../features/profile/model/profile_model.dart';
import '../../../../../networks/api_acess.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfileModel>(
      stream: getProfileRxObj.dataStream,
      builder: (context, snapshot) {
        final user = snapshot.data?.data?.user;
        final String userName =
            user != null ? "Bon retour ! 👋" : "Bon retour ! 👋";
        final String displayName = user?.name != null
            ? "Salut, ${user!.name!.split('@').first} 👋"
            : userName;
        final String profilePic = user?.profileImage ?? "";

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextFontStyle.textStyle20c191919Inter600
                          .copyWith(fontSize: 20.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    UIHelper.verticalSpace(4.h),
                    StreamBuilder<Map<String, dynamic>?>(
                      stream: LocationService.instance.locationStream,
                      builder: (context, _) {
                        final String locationName =
                            appData.read(kKeySelectedLocation) ??
                                "Choisir une adresse";
                        return GestureDetector(
                          onTap: () {
                            AddressSearchBottomSheet.show(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 14.sp,
                                color: AppColors.allPrimaryColor,
                              ),
                              UIHelper.horizontalSpace(4.w),
                              Flexible(
                                child: Text(
                                  locationName,
                                  style: TextFontStyle
                                      .textStyle12c737373Inter400
                                      .copyWith(
                                    color: AppColors.c191919,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              UIHelper.horizontalSpace(2.w),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16.sp,
                                color: AppColors.allPrimaryColor,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  NavigationService.navigateTo(Routes.notificationsScreen);
                },
                child: Container(
                  height: 44.r,
                  width: 44.r,
                  decoration: const BoxDecoration(
                    color: AppColors.cF4F4F4,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Assets.icons.notificationOutlinedGolden.image(
                      width: 24.r,
                      height: 24.r,
                    ),
                  ),
                ),
              ),
              UIHelper.horizontalSpace(16.w),
              GestureDetector(
                onTap: () {
                  (NavigationScreen.of(context) ??
                          NavigationScreen.globalKey.currentState)
                      ?.switchTab(3);
                },
                child: AppNetworkImage(
                  imageUrl: profilePic,
                  height: 44.r,
                  width: 44.r,
                  isProfilePicture: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
