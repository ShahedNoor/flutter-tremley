import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/api_acess.dart';
import '../model/loyalty_history_model.dart';
import '../../fidelity/widgets/shimmers/loyalty_history_shimmer.dart';

class FidelityScreen extends StatefulWidget {
  const FidelityScreen({super.key});

  @override
  State<FidelityScreen> createState() => FidelityScreenState();
}

class FidelityScreenState extends State<FidelityScreen> {
  static FidelityScreenState? instance;

  @override
  void initState() {
    super.initState();
    instance = this;
    fetchData();
  }

  @override
  void dispose() {
    if (instance == this) {
      instance = null;
    }
    super.dispose();
  }

  Future<void> fetchData({bool clean = true}) async {
    if (clean) {
      getLoyaltyHistoryRxObj.clean();
    }
    try {
      await getLoyaltyHistoryRxObj.fetchLoyaltyHistory();
    } catch (_) {}
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
          "Fidélité",
          style: TextFontStyle.textStyle24c000000InterTight700
              .copyWith(fontSize: 22.sp),
        ),
      ),
      body: StreamBuilder<LoyaltyHistoryModel>(
        stream: getLoyaltyHistoryRxObj.getLoyaltyHistoryStream,
        builder: (context, snapshot) {
          Widget sliverHistory;

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data?.status == null) {
            sliverHistory = const SliverToBoxAdapter(
              child: LoyaltyHistoryShimmer(),
            );
          } else if (snapshot.hasError) {
            sliverHistory = SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Center(
                  child: Text("Une erreur s'est produite",
                      style: TextFontStyle.textStyle16c191919InterTight600),
                ),
              ),
            );
          } else {
            final data = snapshot.data?.data;
            if (data == null ||
                ((data.salonHistory?.isEmpty ?? true) &&
                    (data.homeBarberHistory?.isEmpty ?? true))) {
              sliverHistory = SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: Text("Aucun historique",
                        style: TextFontStyle.textStyle16c191919InterTight600),
                  ),
                ),
              );
            } else {
              List<dynamic> combinedHistory = [];
              if (data.salonHistory != null) {
                combinedHistory.addAll(data.salonHistory!);
              }
              if (data.homeBarberHistory != null) {
                combinedHistory.addAll(data.homeBarberHistory!);
              }

              sliverHistory = SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = combinedHistory[index];
                      String title = "Salon / Barbier";
                      String dateStr = "";
                      String pointsStr = "+0 pts";
                      int? targetId;

                      if (item is SalonHistory) {
                        title = item.salonName ?? "Salon";
                        dateStr = item.date ?? "";
                        targetId = item.salonId ?? item.id;
                        pointsStr = item.points != null
                            ? "+${double.tryParse(item.points!)?.toInt() ?? 0} pts"
                            : "+0 pts";
                      } else if (item is HomeBarberHistory) {
                        title = item.barberName ?? "Barbier";
                        dateStr = item.date ?? "";
                        targetId = item.barberId ?? item.id;
                        pointsStr = item.points != null
                            ? "+${double.tryParse(item.points!)?.toInt() ?? 0} pts"
                            : "+0 pts";
                      }

                      return Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              if (targetId != null) {
                                await NavigationService.navigateToWithArgs(
                                  Routes.loyaltyOverviewScreen,
                                  {'id': targetId, 'name': title},
                                );
                                fetchData();
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextFontStyle
                                            .textStyle16c191919InterTight600,
                                      ),
                                      UIHelper.verticalSpace(6.h),
                                      Text(
                                        dateStr,
                                        style: TextFontStyle
                                            .textStyle14c8A8A8AInter400,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.cF2F2F2,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(pointsStr,
                                      style: TextFontStyle
                                          .textStyle14c191919InterTight600),
                                ),
                              ],
                            ),
                          ),
                          if (index < combinedHistory.length - 1)
                            Divider(
                              color: AppColors.cF2F2F2,
                              height: 32.h,
                            ),
                        ],
                      );
                    },
                    childCount: combinedHistory.length,
                  ),
                ),
              );
            }
          }

          return RefreshIndicator(
            color: AppColors.allPrimaryColor,
            backgroundColor: AppColors.cFFFFFF,
            onRefresh: () => fetchData(clean: false),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        UIHelper.verticalSpace(20.h),
                        _buildFastCheckinCard(),
                        UIHelper.verticalSpace(30.h),
                      ],
                    ),
                  ),
                ),
                sliverHistory,
                SliverToBoxAdapter(
                  child: UIHelper.verticalSpace(30.h),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFastCheckinCard() {
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
          Text(
            "Enregistrement",
            style: TextFontStyle.textStyle22cFFFFFFInterTight600
                .copyWith(fontSize: 20.sp),
          ),
          Text(
            "rapide",
            style: TextFontStyle.textStyle22cFFFFFFInterTight600
                .copyWith(fontSize: 20.sp),
          ),
          UIHelper.verticalSpace(8.h),
          Text(
            "Scannez votre ID dans n'importe quel BarberStar.",
            style: TextFontStyle.textStyle14cFFFFFFInterTight500
                .copyWith(color: AppColors.cFFFFFF.withValues(alpha: 0.80)),
          ),
          UIHelper.verticalSpace(24.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                NavigationService.navigateTo(Routes.qrCodeScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cFFFFFF,
                foregroundColor: AppColors.c1B1B1B,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.qrCodeBlack.image(width: 20.w, height: 20.w),
                  UIHelper.horizontalSpace(12.w),
                  Text(
                    "Ouvrir mon QR Code",
                    style:
                        TextFontStyle.textStyle16c191919InterTight600.copyWith(
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
  }
}
