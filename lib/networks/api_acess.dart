import 'package:rxdart/rxdart.dart';
import '../features/auth/data/rx_post_signup/rx.dart';
import '../features/auth/data/rx_post_login/rx.dart';
import '../features/auth/data/rx_post_fcm_token/rx.dart';
import '../features/profile/data/rx_post_logout/rx.dart';
import '../features/auth/data/rx_post_forgot_password/rx.dart';
import '../features/auth/data/rx_post_verify_otp/rx.dart';
import '../features/auth/data/rx_post_reset_password/rx.dart';
import '../features/profile/data/rx_post_change_password/rx.dart';
import '../features/profile/data/rx_post_delete_account/rx.dart';
import '../features/profile/data/rx_get_profile/rx.dart';
import '../features/profile/data/rx_post_profile_update/rx.dart';
import '../features/auth/data/rx_post_resend_otp/rx.dart';
import '../features/profile/model/profile_model.dart';
import '../features/profile/model/faq_model.dart';
import '../features/profile/data/rx_get_faq/rx.dart';
import '../features/profile/data/rx_post_support/rx.dart';
import '../features/home/data/rx_get_salon_or_barber/rx.dart';
import '../features/home/data/rx_get_recent_salon_or_barber/rx.dart';
import '../features/home/model/salon_or_barber_model.dart';
import '../features/home/data/rx_get_salon_reviews/rx.dart';
import '../features/home/model/salon_reviews_model.dart';
import '../features/home/data/rx_get_customer_service_list/rx.dart';
import '../features/home/data/rx_get_salon_service_list/rx.dart';
import '../features/home/model/service_list_model.dart';
import '../features/home/data/rx_post_location_update/rx.dart';
import '../features/home/data/rx_get_barber_list/rx.dart';
import '../features/home/model/barber_list_model.dart';
import '../features/home/data/rx_post_booking_slots/rx.dart';
import '../features/home/model/booking_slots_model.dart';
import '../features/home/data/rx_post_customer_booking/rx.dart';
import '../features/home/data/rx_get_payment_status/rx.dart';
import '../features/home/data/rx_post_home_barber_search_list/rx.dart';
import '../features/home/model/home_barber_search_list_model.dart';
import '../features/home/data/rx_post_asap_booking/rx.dart';

import '../features/reservations/data/rx_get_reservations/rx.dart';
import '../features/reservations/model/reservation_model.dart';
import '../features/reservations/data/rx_get_reservation_details/rx.dart';
import '../features/reservations/model/reservation_details_model.dart';
import '../features/reservations/data/rx_get_booking_details/rx.dart';
import '../features/reservations/model/booking_details_model.dart';
import '../features/reservations/data/rx_get_conversation/rx.dart';
import '../features/reservations/data/rx_chat_send/rx.dart';
import '../features/reservations/data/rx_post_review/rx.dart';
import '../features/fidelity/data/rx_get_loyalty_history/rx.dart';
import '../features/fidelity/model/loyalty_history_model.dart';
import '../features/fidelity/data/rx_get_salon_loyalty/rx.dart';
import '../features/fidelity/model/salon_loyalty_model.dart';
import '../features/notifications/data/rx_get_push_notification/rx.dart';
import '../features/notifications/model/push_notification_model.dart';
import '../features/notifications/data/rx_get_read_notification/rx.dart';
import '../features/fidelity/data/rx_post_loyalty_booking/rx.dart';

// Register Rx Objects here
GetReservationsRx getReservationsRxObj = GetReservationsRx(
    empty: ReservationModel(),
    dataFetcher: BehaviorSubject<ReservationModel>());
GetReservationDetailsRx getReservationDetailsRxObj = GetReservationDetailsRx(
    empty: ReservationDetailsModel(),
    dataFetcher: BehaviorSubject<ReservationDetailsModel>());
GetBookingDetailsRx getBookingDetailsRxObj = GetBookingDetailsRx(
    empty: BookingDetailsModel(),
    dataFetcher: BehaviorSubject<BookingDetailsModel>());
PostReviewRx postReviewRxObj =
    PostReviewRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
final GetConversationRx getConversationRxObj =
    GetConversationRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
final ChatSendRx chatSendRxObj =
    ChatSendRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
final GetLoyaltyHistoryRx getLoyaltyHistoryRxObj = GetLoyaltyHistoryRx(
    empty: LoyaltyHistoryModel(),
    dataFetcher: BehaviorSubject<LoyaltyHistoryModel>());
final GetSalonLoyaltyRx getSalonLoyaltyRxObj = GetSalonLoyaltyRx(
    empty: SalonLoyaltyModel(),
    dataFetcher: BehaviorSubject<SalonLoyaltyModel>());
final PostLoyaltyBookingRx postLoyaltyBookingRxObj = PostLoyaltyBookingRx(
    empty: {}, dataFetcher: BehaviorSubject<Map<String, dynamic>>());

PostSignupRx postSignupRxObj =
    PostSignupRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostLoginRx postLoginRxObj =
    PostLoginRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostFcmTokenRx postFcmTokenRxObj =
    PostFcmTokenRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostLogoutRx postLogoutRxObj =
    PostLogoutRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostForgotPasswordRx postForgotPasswordRxObj =
    PostForgotPasswordRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostVerifyOTPRx postVerifyOTPRxObj =
    PostVerifyOTPRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostResetPasswordRx postResetPasswordRxObj =
    PostResetPasswordRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostChangePasswordRx postChangePasswordRxObj =
    PostChangePasswordRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostDeleteAccountRx postDeleteAccountRxObj =
    PostDeleteAccountRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
GetProfileRx getProfileRxObj = GetProfileRx(
    empty: ProfileModel(), dataFetcher: BehaviorSubject<ProfileModel>());
PostProfileUpdateRx postProfileUpdateRxObj =
    PostProfileUpdateRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostResendOtpRx postResendOtpRxObj =
    PostResendOtpRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
GetSalonOrBarberRx getSalonOrBarberRxObj = GetSalonOrBarberRx(
    empty: null, dataFetcher: BehaviorSubject<SalonOrBarberModel?>());
GetRecentSalonOrBarberRx getRecentSalonOrBarberRxObj = GetRecentSalonOrBarberRx(
    empty: null, dataFetcher: BehaviorSubject<SalonOrBarberModel?>());
GetSalonReviewsRx getSalonReviewsRxObj = GetSalonReviewsRx(
    empty: SalonReviewsModel(),
    dataFetcher: BehaviorSubject<SalonReviewsModel>());
GetCustomerServiceListRx getCustomerServiceListRxObj = GetCustomerServiceListRx(
    empty: ServiceListModel(),
    dataFetcher: BehaviorSubject<ServiceListModel>());
GetSalonServiceListRx getSalonServiceListRxObj = GetSalonServiceListRx(
    empty: ServiceListModel(),
    dataFetcher: BehaviorSubject<ServiceListModel>());
GetBarberListRx getBarberListRxObj = GetBarberListRx(
    empty: BarberListModel(), dataFetcher: BehaviorSubject<BarberListModel>());
PostLocationUpdateRx postLocationUpdateRxObj =
    PostLocationUpdateRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
PostBookingSlotsRx postBookingSlotsRxObj = PostBookingSlotsRx(
    empty: BookingSlotsModel(),
    dataFetcher: BehaviorSubject<BookingSlotsModel>());
PostHomeBarberSearchListRx postHomeBarberSearchListRxObj =
    PostHomeBarberSearchListRx(
        empty: HomeBarberSearchListModel(),
        dataFetcher: BehaviorSubject<HomeBarberSearchListModel>());
final PostCustomerBookingRx postCustomerBookingRxObj = PostCustomerBookingRx(
    empty: {}, dataFetcher: BehaviorSubject<Map<String, dynamic>>());

final GetPaymentStatusRx getPaymentStatusRxObj = GetPaymentStatusRx(
    empty: {}, dataFetcher: BehaviorSubject<Map<String, dynamic>>());

final PostAsapBookingRx postAsapBookingRxObj = PostAsapBookingRx(
    empty: {}, dataFetcher: BehaviorSubject<Map<String, dynamic>>());

GetPushNotificationRx getPushNotificationRxObj = GetPushNotificationRx(
    empty: PushNotificationModel(),
    dataFetcher: BehaviorSubject<PushNotificationModel>());

GetReadNotificationRx getReadNotificationRxObj =
    GetReadNotificationRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

GetFaqRx getFaqRxObj = GetFaqRx(
    empty: FaqModel(), dataFetcher: BehaviorSubject<FaqModel>());

PostHelpSupportRx postHelpSupportRxObj =
    PostHelpSupportRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

