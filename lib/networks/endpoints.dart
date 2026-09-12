// ignore_for_file: constant_identifier_names
const String url = "https://backend.tremley.com/api";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();
  //backend_url
  static String signup() => "/signup";
  static String salonOrBarber() => "/salon-or-barber";
  static String salonOrBarberRecent() => "/salon-or-barber/recent";
  static String salonReviews(int id, int perPage) =>
      "/salon-or-barber/$id/reviews?per_page=$perPage";
  static String logIn() => "/user-login";
  static String logout() => "/user-logout";
  static String forgotPassword() => "/forget/password";
  static String verifyOTP({required String email, required String otp}) =>
      "/otp/check?email=$email&otp=$otp";
  static String resetPassword() => "/reset/password";
  static String changePassword() => "/change/password";
  static String deleteAccount() => "/delete/account";
  static String getProfile() => "/user/profile/get";
  static String updateProfile() => "/profile/update";
  static String updateLocation() => "/user/location/update";
  static String resendOtp() => "/resend/otp";
  static String getCustomerServiceList() => "/customer/service/list";
  static String getCustomerBarberServiceList() =>
      "/customer/barber/service/list";
  static String customerBooking() => "/customer/booking/slots";
  static String asSoonAsPossible() => "/customer/booking/as-soon-as-possible";
  static String salonServiceList(int salonId) =>
      "/customer/salon/service/list/$salonId";
  static String barberList(int salonId) => "/salon/barber/list/$salonId";

  ///profile
  static String profile() => "/user/profile";
  static String bookingSlots() => "/booking/barber/slots";
  static String homeBarberSearchList() => "/home/barber/search/list";
  static String paymentStatus(int id) => "/barber/booking/payment/status/$id";
  static String reservations(String type) => type.isEmpty
      ? "/customer/reservation"
      : "/customer/reservation?type=$type";
  static String cancelReservation(int id) => "/customer/reservation/cancel/$id";
  static String rescheduleBooking(int id) => "/customer/reservation/reschedule/$id";
  static String reservationDetails(int id) =>
      "/customer/reservation/details/$id";
  static String bookingDetails(int id) => "/customer/booking/details/$id";
  static String postReview() => "/customer/review/rating";

  // static String getShopByCategories(String slug) =>
  //     "/api/shop-categories/$slug/";

  static String example() => "/api/";

  static String products(int pageNum, int perPage) =>
      "/products?page=$pageNum&per_page=$perPage";
  static String productDetails(int id) => "/products/$id";

  // Chat
  static String chatSend() => "/chat/send";
  static String chatGet(String conversationId) => "/chat/get/$conversationId";
  static String loyaltyHistory() => "/loyalty/point/get/history";
  static String salonLoyalty(String salonId) =>
      "/salon/wise/loyalty/point/get/$salonId";
  static String loyaltyBooking() => "/loyalty/booking";

  static String fcmToken() => "/fcm/token";
  static String getPushNotification() => "/get/push/notification";
  static String readNotification(String id) => "/read/notification/$id";

  // Help & Support / FAQ
  static String helpSupport() => "/help/support";
  static String faqData() => "/faq/data";
}
