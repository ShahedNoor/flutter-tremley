import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/text_font_style.dart';
import '../../../constants/app_constants.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/di.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../networks/api_acess.dart';
import '../model/salon_loyalty_model.dart';
import '../../fidelity/widgets/shimmers/loyalty_overview_shimmer.dart';
import '../../../common_widgets/custom_toast.dart';

class LoyaltyOverviewScreen extends StatefulWidget {
  final int? salonId;
  final String? name;
  const LoyaltyOverviewScreen({super.key, this.salonId, this.name});

  @override
  State<LoyaltyOverviewScreen> createState() => _LoyaltyOverviewScreenState();
}

class _LoyaltyOverviewScreenState extends State<LoyaltyOverviewScreen> {
  @override
  void initState() {
    super.initState();
    getSalonLoyaltyRxObj.clean();
    if (widget.salonId != null) {
      getSalonLoyaltyRxObj.fetchSalonLoyalty(widget.salonId.toString());
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
          padding: EdgeInsets.only(left: 20.w),
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
          "Fidélité",
          style: TextFontStyle.textStyle24c000000InterTight700
              .copyWith(fontSize: 22.sp),
        ),
      ),
      body: StreamBuilder<SalonLoyaltyModel>(
        stream: getSalonLoyaltyRxObj.getSalonLoyaltyStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data?.status == null) {
            return const LoyaltyOverviewShimmer();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Une erreur s'est produite",
                  style: TextFontStyle.textStyle16c191919InterTight600),
            );
          }

          final data = snapshot.data;
          final reach = double.tryParse(data?.reachLoyality ?? '10') ?? 10.0;
          final current =
              double.tryParse(data?.customerLoyalityPoint ?? '0') ?? 0.0;
          final remaining = (reach - current).toInt();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                UIHelper.verticalSpace(20.h),
                _buildLoyaltyCard(
                    current.toInt(), reach.toInt(), data?.loyalityDescription),
                UIHelper.verticalSpace(20.h),
                Text(
                  remaining > 0
                      ? "Encore $remaining visites pour une coupe gratuite"
                      : "Vous avez gagné une coupe gratuite !",
                  style: TextFontStyle.textStyle15c8A8A8AInter500,
                ),
                UIHelper.verticalSpace(30.h),
                CustomButton(
                  onPressed: () {
                    if (remaining > 0) {
                      customToastMessage("Oups", "Vous n'avez pas encore assez de points.");
                      return;
                    }
                    if (data?.salonDetails?.role == 'home_barbar' || data?.salonDetails?.role == 'home_barber') {
                      NavigationService.navigateToWithArgs(
                        Routes.prestationsScreen,
                        {
                           'isLoyalty': true,
                           'loyaltyServiceId': data?.serviceId,
                           'loyaltyServiceName': data?.serviceName,
                           'loyaltyServiceDuration': data?.serviceDuration,
                           'barberId': data?.salonDetails?.id,
                           'barberName': data?.salonDetails?.name,
                           'barberImage': data?.salonDetails?.image,
                        }
                      );
                    } else if (data?.salonDetails?.role == 'salon') {
                      NavigationService.navigateToWithArgs(
                        Routes.serviceSelectionScreen,
                        {
                           'salonId': data?.salonDetails?.id,
                           'providerType': 'salon',
                           'salonName': data?.salonDetails?.name,
                           'isLoyalty': true,
                           'loyaltyServiceId': data?.serviceId,
                           'loyaltyServiceName': data?.serviceName,
                           'loyaltyServiceDuration': data?.serviceDuration,
                        }
                      );
                    }
                  },
                  title: "Réclamer un service gratuit",
                  backgroundColor: remaining > 0 ? AppColors.c8A8A8A : AppColors.c1B1B1B,
                  foregroundColor: AppColors.cFFFFFF,
                  height: 56.h,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                UIHelper.verticalSpace(20.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      NavigationService.navigateTo(Routes.qrCodeScreen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5E5E5), // Light grey
                      foregroundColor: AppColors.c1B1B1B,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.qrCodeBlack.image(
                          width: 24.w,
                          height: 24.w,
                          color: AppColors.c1B1B1B,
                        ),
                        UIHelper.horizontalSpace(10.w),
                        Text(
                          "Voir mon QR",
                          style: TextFontStyle.textStyle16c191919InterTight600
                              .copyWith(
                            color: AppColors.c1B1B1B,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoyaltyCard(
      int currentPoints, int reachLoyalty, String? description) {
    String firstName = appData.read(kKeyFirstName) ?? "Alexandre";
    String lastName = appData.read(kKeyLastName) ?? "Dupont";
    String fullName = "$firstName $lastName";
    double progress = reachLoyalty > 0 ? (currentPoints / reachLoyalty) : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.c1B1B1B,
            AppColors.c222222,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.c000000.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (widget.name ?? "LE BARBERSTAR").toUpperCase(),
                style: TextFontStyle.textStyle14cFFFFFFInterTight600.copyWith(
                    color: AppColors.cFFFFFF.withValues(alpha: 0.70),
                    letterSpacing: 1.5),
              ),
              Icon(
                Icons.star_outline_rounded,
                color: AppColors.cFFFFFF,
                size: 32.sp,
              ),
            ],
          ),
          UIHelper.verticalSpace(8.h),
          Text(fullName, style: TextFontStyle.textStyle22cFFFFFFInterTight600),
          UIHelper.verticalSpace(30.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("$currentPoints",
                  style: TextFontStyle.textStyle24cFFFFFFInterTight700),
              UIHelper.horizontalSpace(4.w),
              Text(
                "/ $reachLoyalty visites",
                style: TextFontStyle.textStyle14cFFFFFFInterTight500
                    .copyWith(color: AppColors.cFFFFFF.withValues(alpha: 0.60)),
              ),
            ],
          ),
          UIHelper.verticalSpace(12.h),
          Stack(
            children: [
              Container(
                height: 8.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cFFFFFF.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.cFFFFFF,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          Text(
            description ?? "Aucun message spécial du salon",
            style: TextFontStyle.textStyle14cFFFFFFInterTight500.copyWith(
              color: AppColors.cFFFFFF.withValues(alpha: 0.80),
            ),
          ),
        ],
      ),
    );
  }
}
