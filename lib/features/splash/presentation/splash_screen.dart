import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../helpers/navigation_service.dart';
import '../../../helpers/all_routes.dart';
import '../../../helpers/helper_methods.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/di.dart';
import '../../../constants/app_constants.dart';
import '../../../networks/dio/dio.dart';
import '../../../helpers/post_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Start initialization logic
    final initFuture = setInitValue();

    // Initialize video player
    _controller = VideoPlayerController.asset(Assets.videos.splash);
    await _controller.initialize();
    await _controller.setPlaybackSpeed(1.35);

    if (mounted) {
      setState(() {});
      _controller.play();
    }

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        if (_isInitialized) {
          _navigateToNext();
        }
      }
    });

    // Wait for setInitValue to complete
    await initFuture;
    _isInitialized = true;

    // Check if video already finished
    if (_controller.value.position >= _controller.value.duration) {
      _navigateToNext();
    }
  }

  void _navigateToNext() {
    if (mounted && !_hasNavigated) {
      _hasNavigated = true;
      _handleNavigation();
    }
  }

  Future<void> _handleNavigation() async {
    if (appData.read(kKeyIsLoggedIn)) {
      String? token = appData.read(kKeyAccessToken);
      if (token != null && token.isNotEmpty) {
        DioSingleton.instance.update(token);
        await performPostLoginActions();
      }
    }

    if (mounted) {
      if (appData.read(kKeyfirstTime)) {
        NavigationService.navigateToReplacement(Routes.onboardingScreen);
      } else if (appData.read(kKeyIsLoggedIn)) {
        NavigationService.navigateToReplacement(Routes.navigationScreen);
      } else {
        NavigationService.navigateToReplacement(Routes.loginScreen);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c000000,
      body: Center(
        child: _controller.value.isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
