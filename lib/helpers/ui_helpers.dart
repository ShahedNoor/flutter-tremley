import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/colors.gen.dart';
import 'navigation_service.dart';

/// Contains useful consts to reduce boilerplate and duplicate code
final class UIHelper {
  UIHelper._();
  // Vertical spacing constants. Adjust to your liking.
  static final double _verticalSpaceSmall = 10.0.w;
  static final double _verticalSpaceMedium = 20.0.w;
  // ignore: unused_field
  static final double _verticalSpaceMediumLarge = 25.0.w;
  static final double _verticalSpaceSemiLarge = 40.0.w;
  static final double _verticalSpaceLarge = 60.0.w;
  static final double _verticalSpaceExtraLarge = 100.0.w;

  // Vertical spacing constants. Adjust to your liking.
  static final double _horizontalSpaceSmall = 10.0.h;
  static final double _horizontalSpaceMedium = 20.0.h;
  static final double _horizontalSpaceSemiLarge = 40.0.h;
  static final double _horizontalSpaceLarge = 60.0.h;

  static Widget verticalSpaceSmall = SizedBox(height: _verticalSpaceSmall);
  static Widget verticalSpaceMedium = SizedBox(height: _verticalSpaceMedium);
  static Widget verticalSpaceMediumLarge =
      SizedBox(height: _verticalSpaceMediumLarge);
  static Widget verticalSpaceSemiLarge =
      SizedBox(height: _verticalSpaceSemiLarge);
  static Widget verticalSpaceLarge = SizedBox(height: _verticalSpaceLarge);
  static Widget verticalSpaceExtraLarge =
      SizedBox(height: _verticalSpaceExtraLarge);

  static Widget horizontalSpaceSmall = SizedBox(width: _horizontalSpaceSmall);
  static Widget horizontalSpaceMedium = SizedBox(width: _horizontalSpaceMedium);
  static Widget horizontalSpaceSemiLarge =
      SizedBox(width: _horizontalSpaceSemiLarge);
  static Widget horizontalSpaceLarge = SizedBox(width: _horizontalSpaceLarge);

  static Widget horizontalSpace(double width) => SizedBox(width: width);
  static Widget verticalSpace(double height) => SizedBox(height: height);

  static double safePadding() =>
      MediaQuery.of(NavigationService.context!).padding.top;

  // static Widget customDivider() => Container(
  //       height: .6.h,
  //       color: AppColors.c000000.withOpacity(.3),
  //       width: double.infinity,
  //     );
  static double kDefaulutPadding() => 20.sp;

  static String translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'accepté':
        return 'Accepté';
      case 'pending':
        return 'En attente';
      case 'rejected':
        return 'Rejeté';
      case 'customer_absent':
      case 'absente':
        return 'Absente';
      case 'cancelled':
        return 'Annulé';
      case 'completed':
      case 'terminé':
        return 'Terminé';
      case 'confirmed':
      case 'confirmé':
        return 'Confirmé';
      case 'on_the_way':
      case 'on the way':
        return 'En route';
      case 'arrived':
      case 'arrivé':
        return 'Arrivé';
      case 'search_barber':
        return 'Envoyée';
      case 'waiting_for_payment':
        return 'En attente de paiement';
      default:
        return status;
    }
  }

  static Color getStatusColor(String status) {
    String lower = status.toLowerCase();
    if (lower == 'pending' || lower == 'en attente') {
      return AppColors.cFFA500;
    } else if (lower == 'cancelled' || lower == 'annulé' || lower == 'rejected' || lower == 'rejeté' || lower == 'customer_absent' || lower == 'absente') {
      return AppColors.cFF4D4F;
    } else if (lower == 'completed' || lower == 'terminé') {
      return const Color(0xFF43A047);
    } else if (lower == 'accepted' || lower == 'accepté') {
      return AppColors.c222222;
    } else if (lower == 'confirmed' || lower == 'confirmé') {
      return const Color(0xFF1976D2);
    } else if (lower == 'on_the_way' || lower == 'on the way' || lower == 'en route') {
      return const Color(0xFFB58D3F);
    } else if (lower == 'arrived' || lower == 'arrivé') {
      return const Color.fromARGB(255, 142, 25, 210);
    } else if (lower == 'search_barber' || lower == 'envoyée') {
      return const Color(0xFF1976D2);
    } else if (lower == 'waiting_for_payment' || lower == 'en attente de paiement') {
      return AppColors.cFFA500;
    }
    return AppColors.c16A34A;
  }

  static Color getStatusBgColor(String status) {
    String lower = status.toLowerCase();
    if (lower == 'pending' || lower == 'en attente') {
      return AppColors.cFFA500.withValues(alpha: 0.12);
    } else if (lower == 'cancelled' || lower == 'annulé' || lower == 'rejected' || lower == 'rejeté' || lower == 'customer_absent' || lower == 'absente') {
      return AppColors.cFF4D4F.withValues(alpha: 0.12);
    } else if (lower == 'completed' || lower == 'terminé') {
      return const Color(0xFFE8F5E9);
    } else if (lower == 'accepted' || lower == 'accepté') {
      return const Color(0xFFF5F5F5);
    } else if (lower == 'confirmed' || lower == 'confirmé') {
      return const Color(0xFFE3F2FD);
    } else if (lower == 'on_the_way' || lower == 'on the way' || lower == 'en route') {
      return const Color(0xFFFDF7E5);
    } else if (lower == 'arrived' || lower == 'arrivé') {
      return const Color(0xFFE3F2FD);
    } else if (lower == 'search_barber' || lower == 'envoyée') {
      return const Color(0xFFE3F2FD);
    } else if (lower == 'waiting_for_payment' || lower == 'en attente de paiement') {
      return AppColors.cFFA500.withValues(alpha: 0.12);
    }
    return AppColors.c16A34A.withValues(alpha: 0.12);
  }

  static String translateTrackingTitle(String title) {
    switch (title.toLowerCase()) {
      case 'request sent':
        return 'Demande envoyée';
      case 'request accepted':
        return 'Demande acceptée';
      case 'on the way':
        return 'En route';
      case 'arrived':
        return 'Arrivé';
      case 'terminée':
      case 'completed':
        return 'Terminée';
      default:
        return title;
    }
  }

  static String translateTrackingSubTitle(String subtitle) {
    if (subtitle
        .toLowerCase()
        .contains('request has been successfully submitted')) {
      return 'Votre demande a été soumise avec succès.';
    }
    if (subtitle.toLowerCase().contains('has accepted your booking')) {
      return 'Le barbier a accepté votre réservation.';
    }
    if (subtitle.toLowerCase().contains('heading to your address')) {
      return 'Le barbier se dirige vers votre adresse.';
    }
    if (subtitle.toLowerCase().contains('has arrived on site')) {
      return 'Le barbier est arrivé sur place.';
    }
    if (subtitle.toLowerCase().contains('has been completed')) {
      return 'La prestation est terminée.';
    }
    return subtitle;
  }
}
