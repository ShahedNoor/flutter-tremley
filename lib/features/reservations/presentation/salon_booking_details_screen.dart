import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_back_app_bar.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import 'widgets/reservation_summary_card.dart';
import 'widgets/reservation_location_card.dart';

import '../../../common_widgets/app_network_image.dart';
import 'widgets/review_card.dart';
import '../../../networks/api_acess.dart';
import '../model/booking_details_model.dart';
import 'widgets/shimmers/reservation_shimmer.dart';
import '../../../helpers/di.dart';
import '../../../constants/app_constants.dart';
import '../../../../common_widgets/custom_toast.dart';
import '../../../networks/dio/dio.dart';
import '../../../networks/endpoints.dart';
import 'package:tremley_cutomer/common_widgets/waiting_widget.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'reservations_screen.dart';

class SalonBookingDetailsScreen extends StatefulWidget {
  final bool isCompleted;
  final int? id;
  const SalonBookingDetailsScreen(
      {super.key, this.isCompleted = false, this.id});

  @override
  State<SalonBookingDetailsScreen> createState() =>
      _SalonBookingDetailsScreenState();
}

class _SalonBookingDetailsScreenState extends State<SalonBookingDetailsScreen> {
  final _salonCommentController = TextEditingController();
  final _barberCommentController = TextEditingController();
  int _salonRating = 0;
  int _barberRating = 0;
  bool _isRated = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      getBookingDetailsRxObj.clean();
      getBookingDetailsRxObj.fetchBookingDetails(widget.id!);
    }
  }

  @override
  void dispose() {
    _salonCommentController.dispose();
    _barberCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: const CustomBackAppBar(title: "Détails de la réservation"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<BookingDetailsModel>(
                stream: getBookingDetailsRxObj.getBookingDetailsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ReservationShimmer();
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Une erreur s'est produite."));
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data!.status == null) {
                      return const ReservationShimmer();
                    }

                    final data = snapshot.data!.data;
                    if (data == null) {
                      return const Center(
                          child: Text("Aucune donnée trouvée."));
                    }

                    bool isReviewed =
                        _isRated || (data.bookingInfo?.isReviewed ?? false);
                    int displaySalonRating = _salonRating > 0
                        ? _salonRating
                        : (double.tryParse(
                                    data.salonReview?.rating?.toString() ??
                                        '0') ??
                                0.0)
                            .toInt();
                    int displayBarberRating = _barberRating > 0
                        ? _barberRating
                        : (double.tryParse(
                                    data.barberReview?.rating?.toString() ??
                                        '0') ??
                                0.0)
                            .toInt();
                    String displaySalonReview =
                        _salonCommentController.text.isNotEmpty
                            ? _salonCommentController.text
                            : (data.salonReview?.review ?? "Avis soumis");
                    String displayBarberReview =
                        _barberCommentController.text.isNotEmpty
                            ? _barberCommentController.text
                            : (data.barberReview?.review ?? "Avis soumis");

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UIHelper.verticalSpace(20.h),
                                Text("Résumé de la réservation",
                                    style: TextFontStyle
                                        .textStyle20c222222InterTight600),
                                UIHelper.verticalSpace(16.h),
                                ReservationSummaryCard(
                                  status: widget.isCompleted
                                      ? "Terminé"
                                      : UIHelper.translateStatus(
                                          data.bookingInfo?.status ??
                                              "Confirmée"),
                                  serviceName:
                                      data.bookingInfo?.serviceName ?? "",
                                  locationType:
                                      data.bookingInfo?.locationType ??
                                          "Au salon",
                                  salonName: data.barber?.name ?? "Salon",
                                  dateTime: data.bookingInfo?.dateTime ?? "",
                                  price: data.bookingInfo?.totalToPay ?? "0",
                                ),
                                UIHelper.verticalSpace(32.h),
                                Text("Lieu du rendez-vous",
                                    style: TextFontStyle
                                        .textStyle20c222222InterTight600),
                                UIHelper.verticalSpace(16.h),
                                ReservationLocationCard(
                                  address:
                                      data.bookingInfo?.locationName ?? "N/A",
                                  lat: data.bookingInfo?.locationLat,
                                  lng: data.bookingInfo?.locationLon,
                                ),
                                UIHelper.verticalSpace(20.h),
                                if (widget.isCompleted) ...[
                                  UIHelper.verticalSpace(12.h),
                                  Text(
                                    isReviewed
                                        ? "Merci pour votre retour !"
                                        : "Vos commentaires",
                                    style: TextFontStyle
                                        .textStyle20c222222InterTight600,
                                  ),
                                  UIHelper.verticalSpace(8.h),
                                  Text(
                                    isReviewed
                                        ? "Vous avez déjà envoyé un retour pour ce service."
                                        : "Ce service est terminé. Veuillez évaluer le salon et le barbier séparément.",
                                    style: TextFontStyle
                                        .textStyle14c8A8A8AInter500
                                        .copyWith(
                                      color: AppColors.c737373,
                                    ),
                                  ),
                                  UIHelper.verticalSpace(24.h),

                                  // Salon Review
                                  ReviewCard(
                                    title: "Évaluez le salon",
                                    subtitle: data.barber?.name ?? "Salon",
                                    badgeText: "Salon",
                                    isRated: isReviewed,
                                    currentRating: displaySalonRating,
                                    onRatingChanged: (rating) =>
                                        setState(() => _salonRating = rating),
                                    commentController: _salonCommentController,
                                    feedbackText:
                                        isReviewed ? displaySalonReview : null,
                                  ),
                                  UIHelper.verticalSpace(20.h),

                                  // Barber Review
                                  ReviewCard(
                                    title: "Évaluez le barbier",
                                    subtitle: data.barber?.name ?? "Barbier",
                                    badgeText: "Barbier",
                                    isRated: isReviewed,
                                    currentRating: displayBarberRating,
                                    onRatingChanged: (rating) =>
                                        setState(() => _barberRating = rating),
                                    commentController: _barberCommentController,
                                    leading: AppNetworkImage(
                                      imageUrl: data.barber?.image ?? "",
                                      height: 48,
                                      width: 48,
                                      isProfilePicture: true,
                                    ),
                                    feedbackText:
                                        isReviewed ? displayBarberReview : null,
                                  ),
                                  UIHelper.verticalSpace(40.h),
                                ],
                              ],
                            ),
                          ),
                        ),
                        if (data.bookingInfo?.status != 'Cancelled' &&
                            data.bookingInfo?.status != 'Customer_absent' &&
                            (!widget.isCompleted || !isReviewed))
                          Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!widget.isCompleted) ...[
                                  CustomButton(
                                    onPressed: () {
                                      NavigationService.navigateToWithArgs(
                                        Routes.rescheduleSalonBookingScreen,
                                        {
                                          'bookingId': widget.id,
                                          'salonId': data.salonDetails?.id ?? 0,
                                          'salonName':
                                              data.salonDetails?.name ?? '',
                                          'barberId': data.barberDetails?.id ??
                                              data.barber?.id ??
                                              data.bookingInfo?.barbarId,
                                          'barberName':
                                              data.barberDetails?.name ??
                                                  data.barber?.name,
                                        },
                                      ).then((_) {
                                        if (widget.id != null) {
                                          getBookingDetailsRxObj.clean();
                                          getBookingDetailsRxObj
                                              .fetchBookingDetails(widget.id!);
                                        }
                                      });
                                    },
                                    title: "Modifier le rendez-vous",
                                    backgroundColor: AppColors.c191919,
                                    height: 55.h,
                                  ),
                                  if (!widget.isCompleted &&
                                      !_isAppointmentAccepted(data) &&
                                      (data.bookingInfo?.status?.toLowerCase() ==
                                              'pending' ||
                                          data.bookingInfo?.status?.toLowerCase() ==
                                              'en attente'))
                                    UIHelper.verticalSpace(16.h),
                                ],
                                if (widget.isCompleted ||
                                    (!_isAppointmentAccepted(data) &&
                                        (data.bookingInfo?.status?.toLowerCase() ==
                                                'pending' ||
                                            data.bookingInfo?.status?.toLowerCase() ==
                                                'en attente')))
                                  CustomButton(
                                    onPressed: () async {
                                      if (widget.isCompleted) {
                                        if (_salonRating == 0 ||
                                            _barberRating == 0) {
                                          customToastMessage("Erreur",
                                              "Veuillez évaluer le salon et le barbier.");
                                          return;
                                        }

                                        Map<String, dynamic> reviewData = {
                                          "barbar_id":
                                              data.bookingInfo?.barbarId ??
                                                  data.barberDetails?.id ??
                                                  data.barber?.id ??
                                                  data.chatId ??
                                                  0,
                                          "barber_id":
                                              data.bookingInfo?.barbarId ??
                                                  data.barberDetails?.id ??
                                                  data.barber?.id ??
                                                  data.chatId ??
                                                  0,
                                          "salon_id":
                                              data.bookingInfo?.salonId ??
                                                  data.salonDetails?.id ??
                                                  0,
                                          "type": ["salon", "barber"],
                                          "customer_id":
                                              appData.read(kKeyUserID),
                                          "booking_id": widget.id,
                                          "review": [
                                            _salonCommentController.text,
                                            _barberCommentController.text
                                          ],
                                          "rating": [
                                            _salonRating,
                                            _barberRating
                                          ]
                                        };

                                        await postReviewRxObj
                                            .postReview(reviewData);
                                        if (postReviewRxObj
                                                .dataFetcher.valueOrNull !=
                                            null) {
                                          setState(() => _isRated = true);
                                          customToastMessage("Succès",
                                              "Avis soumis avec succès !");
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) =>
                                              const WaitingWidget(),
                                        );

                                        try {
                                          final response = await postHttp(
                                              Endpoints.cancelReservation(
                                                  widget.id!));
                                          if (context.mounted) {
                                            Navigator.pop(
                                                context); // close dialog
                                          }
                                          if (response.data['status'] == true) {
                                            customToastMessage(
                                                "Succès",
                                                response.data['message'] ??
                                                    "Réservation annulée.");
                                            ReservationsScreenState.instance
                                                ?.fetchData();
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
                                            Navigator.pop(
                                                context); // close dialog
                                          }
                                          customToastMessage("Erreur",
                                              "Échec de l'annulation.");
                                        }
                                      }
                                    },
                                    title: widget.isCompleted
                                        ? "Soumettre les commentaires"
                                        : "Annuler la réservation",
                                    backgroundColor: widget.isCompleted
                                        ? AppColors.c191919
                                        : AppColors.cD70000,
                                    height: 55.h,
                                  ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }
                  return const ReservationShimmer();
                },
              ),
            ),
          ],
        ),
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
}

