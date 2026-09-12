import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/waiting_widget.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/reservations/presentation/reservations_screen.dart';
import 'features/fidelity/presentation/fidelity_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'gen/assets.gen.dart';
import 'gen/colors.gen.dart';
import 'common_widgets/location_permission_screen.dart';
import 'common_widgets/notification_priming_bottom_sheet.dart';
import 'helpers/helper_methods.dart';
import 'constants/text_font_style.dart';
import 'helpers/ui_helpers.dart';
import 'helpers/location_service.dart';
import 'helpers/di.dart';
import 'constants/app_constants.dart';
import 'networks/api_acess.dart';

class NavigationScreen extends StatefulWidget {
  final int initialIndex;
  const NavigationScreen({super.key, this.initialIndex = 0});

  static NavigationScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<NavigationScreenState>();
  }

  static final GlobalKey<NavigationScreenState> globalKey =
      GlobalKey<NavigationScreenState>();

  @override
  State<NavigationScreen> createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  final LocationService _locationService = LocationService.instance;
  bool _isOpeningSettings = false;
  bool _isInitializingLocation = true;
  StreamSubscription? _locationSub;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addObserver(this);
    _screens = [
      const HomeScreen(),
      ReservationsScreen(),
      FidelityScreen(),
      const ProfileScreen(),
    ];
    _locationSub = _locationService.locationStream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
    _initLocation();
  }

  void _showNotificationPromptIfEligible() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && _locationService.hasLocation) {
        NotificationPrimingBottomSheet.checkAndShow(context);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Only refresh if we are currently blocked by the location gate
      if (!_locationService.isLocationPermissionGranted) {
        await _refreshLocationAfterResume();
      }
    }
  }

  Future<void> _refreshLocationAfterResume() async {
    if (mounted) {
      setState(() {
        _isInitializingLocation = true;
      });
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));

    final bool wasGranted = _locationService.isLocationPermissionGranted;

    await _locationService.initialize(
      requestPermission: false,
      updateLocation: false,
    );

    if (!wasGranted && _locationService.isLocationPermissionGranted) {
      await _locationService.initialize(
        requestPermission: false,
        updateLocation: true,
      );
    }

    await _syncLocationToBackend();

    if (mounted) {
      setState(() {
        _isInitializingLocation = false;
      });
      if (_locationService.hasLocation) {
        _showNotificationPromptIfEligible();
      }
    }
  }

  Future<void> _initLocation() async {
    await _locationService.initialize(
      requestPermission: true,
      updateLocation: true,
    );

    await _syncLocationToBackend();

    if (mounted) {
      setState(() {
        _isInitializingLocation = false;
      });
      if (_locationService.hasLocation) {
        _showNotificationPromptIfEligible();
      }
    }
  }

  Future<void> _syncLocationToBackend() async {
    if (appData.read(kKeyIsLoggedIn) != true) {
      return;
    }

    final double? latitude = appData.read(kKeySelectedLat);
    final double? longitude = appData.read(kKeySelectedLng);

    if (latitude == null || longitude == null) {
      return;
    }

    await postLocationUpdateRxObj.postLocationUpdate(
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<void> _handleGpsRequest() async {
    if (_locationService.isLocationPermissionPermanentlyDenied ||
        !_locationService.isLocationServiceEnabled) {
      await _openLocationSettings();
      return;
    }

    setState(() {
      _isOpeningSettings = true;
    });

    await _locationService.initialize(
      requestPermission: true,
      updateLocation: true,
    );

    await _syncLocationToBackend();

    if (mounted) {
      setState(() {
        _isOpeningSettings = false;
      });
      if (_locationService.hasLocation) {
        _showNotificationPromptIfEligible();
      }
    }
  }

  Future<void> _openLocationSettings() async {
    setState(() {
      _isOpeningSettings = true;
    });

    final bool opened = _locationService.isLocationServiceEnabled
        ? await Geolocator.openAppSettings()
        : await Geolocator.openLocationSettings();

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Impossible d\'ouvrir les paramètres. Veuillez les activer manuellement.'),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isOpeningSettings = false;
      });
    }
  }

  void switchTab(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationSub?.cancel();
    super.dispose();
  }

  Widget _buildLocationGate() {
    if (_isInitializingLocation &&
        !_locationService.isLocationPermissionChecked) {
      return const Center(child: WaitingWidget());
    }

    // If on Home tab and no location has been selected or granted yet:
    if (_currentIndex == 0 && !_locationService.hasLocation) {
      return LocationPermissionScreen(
        gpsButtonTitle: _locationService.isLocationServiceEnabled &&
                !_locationService.isLocationPermissionPermanentlyDenied
            ? 'Activer la localisation GPS'
            : 'Ouvrir les paramètres',
        isLoading: _isOpeningSettings,
        onGpsPressed: _handleGpsRequest,
        onLocationSelected: () {
          if (mounted) {
            setState(() {});
            if (_locationService.hasLocation) {
              _showNotificationPromptIfEligible();
            }
          }
        },
      );
    }

    return IndexedStack(
      index: _currentIndex,
      children: _screens,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (didPop) return;
        showMaterialDialog(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.cFFFFFF,
        body: _buildLocationGate(),
        bottomNavigationBar: ColoredBox(
          color: AppColors.cFFFFFF,
          child: SafeArea(
            child: Container(
              height: 68.h,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.cF2F2F2, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavItem(
                    0,
                    Assets.icons.navigationBarHomeGolden.path,
                    Assets.icons.navigationBarHomeGrey.path,
                    "Accueil",
                  ),
                  _buildNavItem(
                    1,
                    Assets.icons.navigationBarCalendarGolden.path,
                    Assets.icons.navigationBarCalendarGrey.path,
                    "Réservations",
                  ),
                  _buildNavItem(
                    2,
                    Assets.icons.navigationBarStarGolden.path,
                    Assets.icons.navigationBarStarGrey.path,
                    "Fidélité",
                  ),
                  _buildNavItem(
                    3,
                    Assets.icons.navigationBarProfileGolden.path,
                    Assets.icons.navigationBarProfileGrey.path,
                    "Compte",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String selectedAsset,
    String unselectedAsset,
    String label,
  ) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 1 && _currentIndex != 1) {
            ReservationsScreenState.instance?.fetchData();
          } else if (index == 2 && _currentIndex != 2) {
            FidelityScreenState.instance?.fetchData();
          }
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Perfect vertical centering
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Image.asset(
                  isSelected ? selectedAsset : unselectedAsset,
                  key: ValueKey<bool>(isSelected),
                  height: 24.r,
                  width: 24.r,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            UIHelper.verticalSpace(4.h),
            Text(
              label,
              maxLines: 1,
              style: TextFontStyle.textStyle14c4D4D4DInterTight500.copyWith(
                color:
                    isSelected ? AppColors.allPrimaryColor : AppColors.c737373,
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
