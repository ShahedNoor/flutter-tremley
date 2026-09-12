import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../features/fidelity/presentation/loyalty_overview_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/reservations/presentation/salon_booking_details_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/verify_otp_screen.dart';
import '../features/auth/presentation/reset_password_screen.dart';
import '../navigation_screen.dart';
import '../features/home/presentation/at_home/service_selection/prestations_screen.dart';
import '../features/home/presentation/at_home/service_selection/choose_time_screen.dart';
import '../features/home/presentation/at_home/service_selection/choose_barber_slot_screen.dart';
import '../features/home/presentation/at_home/service_selection/choose_barber_screen.dart';
import '../features/home/presentation/at_home/service_selection/payment_screen.dart';
import '../features/home/presentation/at_home/service_selection/waiting_screen.dart';
import '../features/home/presentation/at_home/service_selection/booking_success_screen.dart'
    as home_success;
import '../features/home/presentation/at_salon/salon_details_screen.dart';
import '../features/home/presentation/at_salon/service_selection_screen.dart';
import '../features/home/presentation/at_salon/booking_schedule_screen.dart';
import '../features/home/presentation/at_salon/booking_confirmation_screen.dart';
import '../features/home/presentation/at_salon/booking_success_screen.dart'
    as salon_success;
import '../features/reservations/presentation/barber_booking_tracking_screen.dart';
import '../features/reservations/presentation/chat_screen.dart';
import '../features/reservations/presentation/barber_booking_details_screen.dart';
import '../features/reservations/presentation/reschedule_salon_booking_screen.dart';
import '../features/fidelity/presentation/qr_code_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/profile/presentation/settings_screen.dart';
import '../features/profile/presentation/change_password_screen.dart';
import '../features/profile/presentation/support_screen.dart';
import '../features/profile/presentation/legal_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/home/presentation/payment/stripe_payment_launch_screen.dart';
import '../features/profile/presentation/faq_screen.dart';

import '../features/profile/model/profile_model.dart';
import '../features/home/model/salon_or_barber_model.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  static const String onboardingScreen = '/onboardingScreen';
  static const String splashScreen = '/splashScreen';
  static const String loginScreen = '/loginScreen';
  static const String signupScreen = '/signupScreen';
  static const String navigationScreen = '/navigationScreen';
  static const String prestationsScreen = '/prestationsScreen';
  static const String chooseTimeScreen = '/chooseTimeScreen';
  static const String chooseBarberSlotScreen = '/chooseBarberSlotScreen';
  static const String chooseBarberScreen = '/chooseBarberScreen';
  static const String paymentScreen = '/paymentScreen';
  static const String waitingScreen = '/waitingScreen';
  static const String bookingSuccessScreen = '/bookingSuccessScreen';
  static const String salonDetailsScreen = '/salonDetailsScreen';
  static const String serviceSelectionScreen = '/serviceSelectionScreen';
  static const String bookingScheduleScreen = '/bookingScheduleScreen';
  static const String bookingConfirmationScreen = '/bookingConfirmationScreen';
  static const String atSalonBookingSuccessScreen =
      '/atSalonBookingSuccessScreen';
  static const String bookingDetailsScreen = '/bookingDetailsScreen';
  static const String barberBookingTrackingScreen = '/barberBookingTrackingScreen';
  static const String rescheduleSalonBookingScreen = '/rescheduleSalonBookingScreen';
  static const String chatScreen = '/chatScreen';
  static const String bookingReviewScreen = '/bookingReviewScreen';
  static const String qrCodeScreen = '/qrCodeScreen';
  static const String loyaltyOverviewScreen = '/loyaltyOverviewScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String supportScreen = '/supportScreen';
  static const String legalScreen = '/legalScreen';
  static const String notificationsScreen = '/notificationsScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String verifyOtpScreen = '/verifyOtpScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String stripePaymentLaunchScreen = '/stripePaymentLaunchScreen';
  static const String faqScreen = '/faqScreen';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboardingScreen:
        return _buildRoute(const OnboardingScreen(), settings: settings);

      case Routes.splashScreen:
        return _buildRoute(const SplashScreen(), settings: settings);

      case Routes.loginScreen:
        return _buildRoute(const LoginScreen(), settings: settings);

      case Routes.signupScreen:
        return _buildRoute(const SignupScreen(), settings: settings);

      case Routes.navigationScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            NavigationScreen(
                initialIndex: args?['initialIndex'] ?? 0),
            settings: settings);

      case Routes.prestationsScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            PrestationsScreen(
              isLoyalty: args?['isLoyalty'] ?? false,
              loyaltyServiceId: args?['loyaltyServiceId'],
              loyaltyServiceName: args?['loyaltyServiceName'],
              loyaltyServiceDuration: args?['loyaltyServiceDuration'],
              barberId: args?['barberId'],
              barberName: args?['barberName'],
              barberImage: args?['barberImage'],
            ),
            settings: settings);

      case Routes.chooseTimeScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            ChooseTimeScreen(
              salonId: args?['salonId'],
              providerType: args?['providerType'] ?? "salon",
              bookingData: args?['bookingData'],
            ),
            settings: settings);

      case Routes.chooseBarberSlotScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            ChooseBarberSlotScreen(
              selectedDate: args?['selectedDate'],
              barberId: args?['barberId'],
              barberName: args?['barberName'],
              barberImage: args?['barberImage'],
              bookingData: args?['bookingData'] ?? {},
            ),
            settings: settings);

      case Routes.waitingScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            WaitingScreen(
              isASAP: args?['isASAP'] ?? true,
              selectedDate: args?['selectedDate'],
              selectedTime: args?['selectedTime'],
              bookingData: args?['bookingData'],
            ),
            settings: settings);

      case Routes.chooseBarberScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            ChooseBarberScreen(
              selectedDate: args?['selectedDate'],
              selectedTime: args?['selectedTime'],
              bookingData: args?['bookingData'],
            ),
            settings: settings);

      case Routes.paymentScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            PaymentScreen(
              bookingData: args?['bookingData'],
            ),
            settings: settings);

      case Routes.bookingSuccessScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            home_success.BookingSuccessScreen(
                apiResponse: args?['apiResponse'],
                isPaymentCompleted: args?['isPaymentCompleted'] ?? false),
            settings: settings);

      case Routes.salonDetailsScreen:
        final salon = settings.arguments as SalonOrBarber;
        return _buildRoute(SalonDetailsScreen(salon: salon),
            settings: settings);

      case Routes.serviceSelectionScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          ServiceSelectionScreen(
            salonId: args['salonId'],
            providerType: args['providerType'] ?? "salon",
            salonName: args['salonName'] ?? "",
            rating: args['rating'] ?? 0.0,
            distance: args['distance'] ?? 0.0,
            address: args['address'] ?? "",
            isLoyalty: args['isLoyalty'] ?? false,
            loyaltyServiceId: args['loyaltyServiceId'],
            loyaltyServiceName: args['loyaltyServiceName'],
            loyaltyServiceDuration: args['loyaltyServiceDuration'],
          ),
          settings: settings,
        );

      case Routes.bookingScheduleScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          BookingScheduleScreen(
            salonId: args['salonId'],
            barberId: args['barberId'],
            providerType: args['providerType'] ?? "salon",
            salonName: args['salonName'],
            serviceName: args['serviceName'],
            duration: args['duration'],
            price: args['price'],
            barberName: args['barberName'],
            barberImage: args['barberImage'],
            barberRating: args['barberRating'],
            bookingData: args['bookingData'],
            isLoyalty: args['isLoyalty'] ?? false,
            loyaltyServiceId: args['loyaltyServiceId'],
          ),
          settings: settings,
        );

      case Routes.bookingConfirmationScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          BookingConfirmationScreen(
            salonName: args['salonName'],
            serviceName: args['serviceName'],
            duration: args['duration'],
            dateTime: args['dateTime'],
            price: args['price'],
            bookingData: args['bookingData'],
            isLoyalty: args['isLoyalty'] ?? false,
            loyaltyServiceId: args['loyaltyServiceId'],
          ),
          settings: settings,
        );

      case Routes.atSalonBookingSuccessScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          salon_success.BookingSuccessScreen(
            salonName: args['salonName'],
            serviceName: args['serviceName'],
            duration: args['duration'],
            dateTime: args['dateTime'],
          ),
          settings: settings,
        );

      case Routes.bookingDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            SalonBookingDetailsScreen(
              isCompleted: args?['isCompleted'] ?? false,
              id: args?['id'],
            ),
            settings: settings);

      case Routes.barberBookingTrackingScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            BarberBookingTrackingScreen(
              id: args?['id'],
            ),
            settings: settings);

      case Routes.rescheduleSalonBookingScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            RescheduleSalonBookingScreen(
              bookingId: args?['bookingId'] ?? 0,
              salonId: args?['salonId'] ?? 0,
              salonName: args?['salonName'] ?? '',
              providerType: args?['providerType'] ?? 'salon',
              barberId: args?['barberId'],
              barberName: args?['barberName'],
            ),
            settings: settings);

      case Routes.chatScreen:
        return _buildRoute(const ChatScreen(), settings: settings);

      case Routes.bookingReviewScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          BarberBookingDetailsScreen(
            initialIsRated: args?['initialIsRated'] ?? false,
            isCompleted: args?['isCompleted'] ?? false,
            id: args?['id'],
          ),
          settings: settings,
        );

      case Routes.qrCodeScreen:
        return _buildRoute(const QRCodeScreen(), settings: settings);

      case Routes.loyaltyOverviewScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final salonId = args?['id'] as int?;
        final name = args?['name'] as String?;
        return _buildRoute(LoyaltyOverviewScreen(salonId: salonId, name: name),
            settings: settings);

      case Routes.editProfileScreen:
        final user = settings.arguments as User?;
        return _buildRoute(EditProfileScreen(user: user), settings: settings);

      case Routes.settingsScreen:
        return _buildRoute(const SettingsScreen(), settings: settings);

      case Routes.changePasswordScreen:
        return _buildRoute(const ChangePasswordScreen(), settings: settings);

      case Routes.supportScreen:
        return _buildRoute(const SupportScreen(), settings: settings);

      case Routes.legalScreen:
        return _buildRoute(const LegalScreen(), settings: settings);

      case Routes.notificationsScreen:
        return _buildRoute(const NotificationsScreen(), settings: settings);

      case Routes.forgotPasswordScreen:
        return _buildRoute(const ForgotPasswordScreen(), settings: settings);

      case Routes.verifyOtpScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(VerifyOtpScreen(email: args['email']),
            settings: settings);

      case Routes.resetPasswordScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
            ResetPasswordScreen(email: args['email'], otp: args['otp']),
            settings: settings);

      case Routes.stripePaymentLaunchScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          StripePaymentLaunchScreen(
              paymentUrl: args['paymentUrl'], bookingId: args['bookingId']),
          settings: settings,
        );

      case Routes.faqScreen:
        return _buildRoute(const FaqScreen(), settings: settings);

      default:
        return null;
    }
  }

  static Route<dynamic> _buildRoute(Widget widget, {RouteSettings? settings}) {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoPageRoute(builder: (context) => widget, settings: settings)
        : MaterialPageRoute(builder: (context) => widget, settings: settings);
  }
}
