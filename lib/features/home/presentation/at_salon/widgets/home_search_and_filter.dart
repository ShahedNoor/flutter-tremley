import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common_widgets/custom_textform_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../../networks/api_acess.dart';
import '../../../../../../constants/app_constants.dart';
import '../../../../../../helpers/di.dart';
import '../../../data/rx_get_salon_or_barber/rx.dart';
import 'filter_bottom_sheet.dart';

class HomeSearchAndFilter extends StatefulWidget {
  const HomeSearchAndFilter({super.key});

  @override
  State<HomeSearchAndFilter> createState() => _HomeSearchAndFilterState();
}

class _HomeSearchAndFilterState extends State<HomeSearchAndFilter> {
  Timer? _debounce;
  String _searchText = '';
  double _radius = 5.0; // default radius

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = query;
      });
      _fetchData(HomeLoadingState.search);
    });
  }

  void _fetchData(HomeLoadingState state) {
    final double? lat = appData.read(kKeySelectedLat);
    final double? lng = appData.read(kKeySelectedLng);

    if (lat != null && lng != null) {
      getSalonOrBarberRxObj.fetchSalonOrBarbers(
        latitude: lat,
        longitude: lng,
        type: "salon",
        search: _searchText,
        radius: _radius,
        state: state,
      );
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.cFFFFFF,
      builder: (context) {
        return FilterBottomSheet(
          initialRadius: _radius,
          onApply: (newRadius) {
            setState(() {
              _radius = newRadius;
            });
            _fetchData(HomeLoadingState.filter);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              hintText: "Rechercher une ville ou un salon",
              drawLabel: false,
              onChanged: _onSearchChanged,
              prefixIcon: Assets.icons.searchGolden.image(
                width: 20.r,
                height: 20.r,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          UIHelper.horizontalSpace(12.w),
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.cE3E3E3),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Assets.icons.filterGolden.image(
                width: 20.r,
                height: 20.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
