import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_back_app_bar.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../../../networks/api_acess.dart';
import '../model/booking_details_model.dart';
import 'widgets/shimmers/reservation_shimmer.dart';
import 'widgets/reservation_summary_card.dart';
import '../../../../common_widgets/custom_toast.dart';
import '../../../networks/dio/dio.dart';
import '../../../networks/endpoints.dart';
import '../../../common_widgets/waiting_widget.dart';
import 'reservations_screen.dart';

class BarberBookingTrackingScreen extends StatefulWidget {
  final int? id;
  const BarberBookingTrackingScreen({super.key, this.id});

  @override
  State<BarberBookingTrackingScreen> createState() =>
      _BarberBookingTrackingScreenState();
}

class _BarberBookingTrackingScreenState
    extends State<BarberBookingTrackingScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      getBookingDetailsRxObj.clean();
      getBookingDetailsRxObj.fetchBookingDetails(widget.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: const CustomBackAppBar(title: "Détails de la réservation"),
      body: StreamBuilder<BookingDetailsModel>(
        stream: getBookingDetailsRxObj.getBookingDetailsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ReservationShimmer();
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Une erreur s'est produite."));
          }

          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.status == null) {
              return const ReservationShimmer();
            }

            final data = snapshot.data!.data;
            if (data == null) {
              return const Center(child: Text("Aucune donnée trouvée."));
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.verticalSpace(20.h),
                        _buildBarberCard(data),
                        UIHelper.verticalSpace(20.h),
                        _buildChatButton(data),
                        UIHelper.verticalSpace(32.h),
                        ReservationSummaryCard(
                          status: UIHelper.translateStatus(
                              data.bookingInfo?.status ?? "Confirmée"),
                          serviceName: data.bookingInfo?.serviceName ?? "",
                          locationType:
                              data.bookingInfo?.locationType ?? "At home",
                          salonName: data.barber?.name ?? "Salon",
                          dateTime: data.bookingInfo?.dateTime ?? "",
                          price: data.bookingInfo?.totalToPay ?? "0",
                        ),
                        UIHelper.verticalSpace(32.h),
                        Text("Suivi de la réservation",
                            style:
                                TextFontStyle.textStyle20c222222InterTight600),
                        UIHelper.verticalSpace(16.h),
                        _buildTrackingSection(data.tracking ?? []),
                        UIHelper.verticalSpace(20.h),
                      ],
                    ),
                  ),
                ),
                if (data.bookingInfo?.status != 'Cancelled' &&
                    !_isAppointmentAccepted(data))
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(20.r),
                      child: CustomButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const WaitingWidget(),
                          );
                          try {
                            final response = await postHttp(
                                Endpoints.cancelReservation(widget.id!));
                            if (context.mounted) {
                              Navigator.pop(context); // close dialog
                            }
                            if (response.data['status'] == true) {
                              customToastMessage(
                                  "Succès",
                                  response.data['message'] ??
                                      "Réservation annulée.");
                              ReservationsScreenState.instance?.fetchData();
                              if (context.mounted) {
                                Navigator.pop(context); // go back
                              }
                            } else {
                              customToastMessage(
                                  "Erreur",
                                  response.data['message'] ??
                                      "Échec de l'annulation.");
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.pop(context); // close dialog
                            }
                            customToastMessage(
                                "Erreur", "Échec de l'annulation.");
                          }
                        },
                        title: "Annuler la réservation",
                        backgroundColor: AppColors.cD70000,
                        height: 55.h,
                      ),
                    ),
                  ),
              ],
            );
          }
          return const ReservationShimmer();
        },
      ),
    );
  }

  bool _isAppointmentAccepted(BookingDetailsData data) {
    final tracking = data.tracking ?? [];
    final hasAcceptedStep = tracking.any((t) {
      final title = (t.title ?? '').toLowerCase().trim();
      return (title.contains('accept') ||
              title.contains('en route') ||
              title.contains('on the way') ||
              title.contains('arriv') ||
              title.contains('termin')) &&
          (t.isCompleted == true);
    });
    if (hasAcceptedStep) return true;

    final status = (data.bookingInfo?.status ?? '').toLowerCase().trim();
    if (status.isEmpty) return false;
    if (status == 'pending' ||
        status == 'en attente' ||
        status == 'search_barber' ||
        status == 'envoyée') {
      return false;
    }
    return true;
  }


  Widget _buildBarberCard(BookingDetailsData data) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cF2F2F2),
        boxShadow: [
          BoxShadow(
            color: AppColors.c000000.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AppNetworkImage(
            imageUrl: data.barber?.image ?? '',
            width: 60.r,
            height: 60.r,
            isProfilePicture: true,
          ),
          UIHelper.horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Votre barbier",
                  style: TextFontStyle.textStyle12c9B9B9BInter400
                      .copyWith(fontSize: 13.sp),
                ),
                Text(
                  data.barber?.name ?? "Barbier",
                  style: TextFontStyle.textStyle16c191919Inter600
                      .copyWith(fontSize: 18.sp),
                ),
                Text(
                  data.bookingInfo?.serviceName ?? "",
                  style: TextFontStyle.textStyle14c8A8A8AInter400
                      .copyWith(fontSize: 14.sp),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Assets.icons.starYellow.image(width: 16.w, height: 16.w),
              UIHelper.horizontalSpace(4.w),
              Text(
                data.barber?.rating ?? "0.0",
                style: TextFontStyle.textStyle16c191919InterTight600
                    .copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton(BookingDetailsData data) {
    return SizedBox(
      height: 54.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          NavigationService.navigateToWithArgs(Routes.chatScreen, {
            'barber_name': data.barber?.name ?? "Barbier",
            'barber_image': data.barber?.image ?? "",
            'receiver_id': data.chatId ?? "",
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.c1B1B1B,
          foregroundColor: AppColors.cFFFFFF,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.chatOutlinedWhite.image(width: 20.w, height: 20.w),
            UIHelper.horizontalSpace(12.w),
            Text(
              "Discutez avec ${data.barber?.name ?? 'Barbier'}",
              style: TextFontStyle.textStyle16cFFFFFFInterTight700
                  .copyWith(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingSection(List<BookingTracking> trackingList) {
    if (trackingList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: trackingList.asMap().entries.map((entry) {
        int idx = entry.key;
        BookingTracking track = entry.value;
        return _buildTrackingStep(
          title: UIHelper.translateTrackingTitle(track.title ?? ""),
          description: UIHelper.translateTrackingSubTitle(track.subTitle ?? ""),
          isCompleted: track.isCompleted ?? false,
          isLast: idx == trackingList.length - 1,
        );
      }).toList(),
    );
  }

  Widget _buildTrackingStep({
    required String title,
    required String description,
    required bool isCompleted,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 14.r,
                height: 14.r,
                margin: EdgeInsets.only(top: 4.h),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.cB08D2A : AppColors.cF2F2F2,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    color: isCompleted
                        ? AppColors.cD86700.withValues(alpha: 0.3)
                        : AppColors.cF2F2F2,
                  ),
                ),
            ],
          ),
          UIHelper.horizontalSpace(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextFontStyle.textStyle16c191919Inter600.copyWith(
                    color: isCompleted ? AppColors.c191919 : AppColors.c8A8A8A,
                    fontSize: 16.sp,
                  ),
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  description,
                  style: TextFontStyle.textStyle14c8A8A8AInter400.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.cA5A5A5,
                  ),
                ),
                UIHelper.verticalSpace(20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
