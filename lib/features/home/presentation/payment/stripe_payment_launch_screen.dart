import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_back_app_bar.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/all_routes.dart';
import 'package:tremley_cutomer/helpers/navigation_service.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tremley_cutomer/common_widgets/custom_toast.dart';

class StripePaymentLaunchScreen extends StatefulWidget {
  final String paymentUrl;
  final int? bookingId;

  const StripePaymentLaunchScreen({
    super.key,
    required this.paymentUrl,
    this.bookingId,
  });

  @override
  State<StripePaymentLaunchScreen> createState() =>
      _StripePaymentLaunchScreenState();
}

class _StripePaymentLaunchScreenState extends State<StripePaymentLaunchScreen>
    with WidgetsBindingObserver {
  bool isLoadingStatus = false;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listen only to newly incoming stream deep links
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      if (mounted) {
        debugPrint("Deep Link Received in Payment Screen: $uri");
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    debugPrint("Handling deep link: $uri");
    final urlStr = uri.toString().toLowerCase();

    if (urlStr.contains('success') ||
        uri.path.contains('success') ||
        uri.host == 'success') {
      customToastMessage("Succès", "Paiement réussi.");
      NavigationService.navigateToReplacementWithArgs(
          Routes.bookingSuccessScreen, {'isPaymentCompleted': true});
    } else if (urlStr.contains('cancel') ||
        uri.path.contains('cancel') ||
        uri.host == 'cancel' ||
        urlStr.contains('fail') ||
        uri.path.contains('fail') ||
        uri.host == 'fail') {
      customToastMessage("Erreur", "Le paiement a été annulé ou a échoué.");
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("App Resumed - Manual return or deep link incoming.");
      // Cannot use API since backend doesn't return booking_id.
      // We rely entirely on _handleDeepLink() to navigate to success.
    }
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(widget.paymentUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: CustomBackAppBar(
        title: "Paiement",
        onBack: () =>
            NavigationService.navigateToReplacement(Routes.navigationScreen),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: 80.r, color: AppColors.cB08D2A),
            UIHelper.verticalSpace(24.h),
            Text(
              "Veuillez procéder au paiement",
              style: TextFontStyle.textStyle20c222222InterTight600,
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpace(16.h),
            Text(
              "Pour confirmer votre réservation, veuillez cliquer sur le bouton ci-dessous pour payer via Stripe.",
              style: TextFontStyle.textStyle14c8A8A8AInter400,
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpace(48.h),
            CustomButton(
              onPressed: _launchUrl,
              title: "Payer maintenant",
              height: 55.h,
              isLoading: isLoadingStatus,
            ),
            UIHelper.verticalSpace(16.h),
            TextButton(
              onPressed: () {
                NavigationService.navigateToReplacement(
                    Routes.navigationScreen);
              },
              child: Text(
                "Annuler",
                style: TextFontStyle.textStyle16c191919Inter600
                    .copyWith(color: AppColors.cFF3B30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
