import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tremley_cutomer/features/onboarding/presentation/onboarding_screen.dart';
import 'constants/app_constants.dart';
import 'features/auth/presentation/login_screen.dart';
import 'helpers/di.dart';
import 'navigation_screen.dart';
import 'networks/dio/dio.dart';
import 'welcome_screen.dart';
import 'helpers/helper_methods.dart';
import 'helpers/post_login.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await setInitValue();

    if (appData.read(kKeyIsLoggedIn)) {
      String? token = appData.read(kKeyAccessToken);
      if (token != null && token.isNotEmpty) {
        DioSingleton.instance.update(token);
        await performPostLoginActions();
      }
    }

    if (mounted) {
      if (appData.read(kKeyfirstTime)) {
        OnboardingScreen();
      } else if (appData.read(kKeyIsLoggedIn)) {
        NavigationScreen();
      } else {
        LoginScreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreen();
  }
}
