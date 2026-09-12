import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_back_app_bar.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import 'widgets/reservation_summary_card.dart';
import 'widgets/reservation_location_card.dart';
import 'widgets/review_card.dart';
import '../../../networks/api_acess.dart';
import '../model/booking_details_model.dart';
import 'widgets/shimmers/reservation_shimmer.dart';
import '../../../helpers/di.dart';
import '../../../constants/app_constants.dart';
import '../../../../common_widgets/custom_toast.dart';
import '../../../networks/dio/dio.dart';
import '../../../networks/endpoints.dart';
import '../../../common_widgets/waiting_widget.dart';
import 'reservations_screen.dart';

class BarberBookingDetailsScreen extends StatefulWidget {
  final bool initialIsRated;
  final bool isCompleted;
  final int? id;

  const BarberBookingDetailsScreen({
    super.key,
    this.initialIsRated = false,
    this.isCompleted = false,
    this.id,
  });

  @override
  State<BarberBookingDetailsScreen> createState() =>
      _BarberBookingDetailsScreenState();
}

class _BarberBookingDetailsScreenState
    extends State<BarberBookingDetailsScreen> {
  late bool _isRated;
  int salonRating = 0;
  int barberRating = 0;
  final _salonCommentController = TextEditingController();
  final _barberCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isRated = widget.initialIsRated;
    if (_isRated == false) {
      salonRating = 4;
      barberRating = 4;
    }
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

                    bool isReviewed = _isRated || (data.bookingInfo?.isReviewed ?? false);
                    int displayBarberRating = barberRating > 0 ? barberRating : (double.tryParse(data.barberReview?.rating?.toString() ?? '0') ?? 0.0).toInt();
                    String displayBarberReview = _barberCommentController.text.isNotEmpty ? _barberCommentController.text : (data.barberReview?.review ?? "Avis soumis");

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UIHelper.verticalSpace(20.h),
                                Text(
                                  "Résumé de la réservation",
                                  style: TextFontStyle
                                      .textStyle20c222222InterTight600,
                                ),
                                UIHelper.verticalSpace(16.h),
                                ReservationSummaryCard(
                                  status: widget.isCompleted
                                      ? "Terminé"
                                      : UIHelper.translateStatus(data.bookingInfo?.status ?? "Confirmée"),
                                  serviceName:
                                      data.bookingInfo?.serviceName ?? "",
                                  locationType:
                                      data.bookingInfo?.locationType ??
                                          "À domicile",
                                  salonName: data.barber?.name ?? "Barbier",
                                  dateTime: data.bookingInfo?.dateTime ?? "",
                                  price: data.bookingInfo?.totalToPay ?? "0",
                                ),
                                UIHelper.verticalSpace(32.h),
                                Text(
                                  "Lieu du rendez-vous",
                                  style: TextFontStyle
                                      .textStyle20c222222InterTight600,
                                ),
                                UIHelper.verticalSpace(16.h),
                                ReservationLocationCard(
                                  address:
                                      data.bookingInfo?.locationName ?? "N/A",
                                  lat: data.bookingInfo?.locationLat,
                                  lng: data.bookingInfo?.locationLon,
                                ),
                                UIHelper.verticalSpace(32.h),
                                if (widget.isCompleted) ...[
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

                                  // Barber Review
                                  ReviewCard(
                                    title: "Évaluez le barbier",
                                    subtitle: data.barber?.name ?? "Barbier",
                                    badgeText: "Barbier",
                                    isRated: isReviewed,
                                    currentRating: displayBarberRating,
                                    onRatingChanged: (rating) =>
                                        setState(() => barberRating = rating),
                                    commentController: _barberCommentController,
                                    leading: AppNetworkImage(
                                      imageUrl: data.barber?.image ??
                                          "https://images.unsplash.com/photo-1503951914875-452162b0f3f1",
                                      height: 48,
                                      width: 48,
                                      isProfilePicture: true,
                                    ),
                                    feedbackText: isReviewed
                                        ? displayBarberReview
                                        : null,
                                  ),
                                  UIHelper.verticalSpace(40.h),
                                ],
                              ],
                            ),
                          ),
                        ),
                        if (!isReviewed &&
                            widget.isCompleted &&
                            data.bookingInfo?.status != 'Cancelled' &&
                            data.bookingInfo?.status != 'Customer_absent')
                          Padding(
                            padding: EdgeInsets.all(20.r),
                            child: CustomButton(
                              onPressed: () async {
                                if (barberRating == 0) {
                                  customToastMessage(
                                      "Erreur", "Veuillez évaluer le barbier.");
                                  return;
                                }

                                Map<String, dynamic> reviewData = {
                                  "barbar_id": data.bookingInfo?.barbarId ??
                                      data.barber?.id ??
                                      data.chatId ??
                                      0,
                                  "barber_id": data.bookingInfo?.barbarId ??
                                      data.barber?.id ??
                                      data.chatId ??
                                      0,
                                  "type": ["barber"],
                                  "customer_id": appData.read(kKeyUserID),
                                  "booking_id": widget.id,
                                  "review": [_barberCommentController.text],
                                  "rating": [barberRating]
                                };

                                await postReviewRxObj.postReview(reviewData);
                                if (postReviewRxObj.dataFetcher.valueOrNull !=
                                    null) {
                                  setState(() => _isRated = true);
                                  customToastMessage(
                                      "Succès", "Avis soumis avec succès !");
                                }
                              },
                              title: "Soumettre les commentaires",
                              backgroundColor: AppColors.c191919,
                              height: 55.h,
                            ),
                          ),
                        if (!widget.isCompleted &&
                            !_isAppointmentAccepted(data) &&
                            (data.bookingInfo?.status?.toLowerCase() ==
                                    'pending' ||
                                data.bookingInfo?.status?.toLowerCase() ==
                                    'en attente'))
                          Padding(
                            padding: EdgeInsets.all(20.r),
                            child: CustomButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const WaitingWidget(),
                                );

                                try {
                                  final response = await postHttp(Endpoints.cancelReservation(widget.id!));
                                  if (context.mounted) Navigator.pop(context); // close dialog
                                  if (response.data['status'] == true) {
                                    customToastMessage("Succès", response.data['message'] ?? "Réservation annulée.");
                                    ReservationsScreenState.instance?.fetchData();
                                    if (context.mounted) Navigator.pop(context); // go back
                                  } else {
                                    customToastMessage("Erreur", response.data['message'] ?? "Échec de l'annulation.");
                                  }
                                } catch (e) {
                                  if (context.mounted) Navigator.pop(context); // close dialog
                                  customToastMessage("Erreur", "Échec de l'annulation.");
                                }
                              },
                              title: "Annuler la réservation",
                              backgroundColor: AppColors.cD70000,
                              height: 55.h,
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

