import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/assets.gen.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import '../../../../model/barber_list_model.dart';
import '../../../../../../networks/api_acess.dart';
import 'barber_card.dart';

class ServiceSelectionHeader extends StatelessWidget {
  final String salonName;
  final double rating;
  final double distance;
  final String address;
  final Barber? selectedBarber;
  final Function(Barber?) onBarberSelected;
  final bool isLoyalty;
  final bool hideAutoOption;

  const ServiceSelectionHeader({
    super.key,
    required this.salonName,
    required this.rating,
    required this.distance,
    required this.address,
    required this.selectedBarber,
    required this.onBarberSelected,
    this.isLoyalty = false,
    this.hideAutoOption = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIHelper.verticalSpace(12.h),
        Text(
          salonName,
          style: TextFontStyle.textStyle32c191919InterTight700
              .copyWith(fontSize: 28.sp),
        ),
        UIHelper.verticalSpace(8.h),
        Row(
          children: [
            Assets.icons.reviewStarGolden.image(width: 16.r, height: 16.r),
            UIHelper.horizontalSpace(6.w),
            Text(
              rating.toString(),
              style: TextFontStyle.textStyle14c4D4D4DInterTight500.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.c191919,
              ),
            ),
            UIHelper.horizontalSpace(12.w),
            Assets.icons.locationOutlinedGrey.image(width: 16.r, height: 16.r),
            UIHelper.horizontalSpace(6.w),
            Expanded(
              child: Text(
                "$distance km • $address",
                style: TextFontStyle.textStyle14c8A8A8AInter400.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(24.h),
        InkWell(
          onTap: () {
            _showBarberSelection(context);
          },
          child: Container(
            height: 56.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.cEEEEEE),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedBarber?.name ??
                      (isLoyalty
                          ? "Choisir avec qui ?"
                          : "Choisir avec qui ? (optionnel)"),
                  style: selectedBarber != null
                      ? TextFontStyle.textStyle16c191919Inter600
                      : TextFontStyle.textStyle14c8A8A8AInter400.copyWith(
                          fontSize: 16.sp,
                        ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.cB08D2A,
                  size: 28.r,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showBarberSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 0.6.sh,
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Choisir votre barbier",
                      style: TextFontStyle.textStyle20c1B1B1BInterTight600,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(16.h),
                Expanded(
                  child: StreamBuilder<BarberListModel>(
                    stream: getBarberListRxObj.dataStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData ||
                          (snapshot.data?.data?.isEmpty ?? true)) {
                        return const Center(child: Text("No barbers found"));
                      }

                      final barbers = snapshot.data!.data!;
                      final hasAutoOption = !isLoyalty && !hideAutoOption;
                      final itemCount =
                          barbers.length + (hasAutoOption ? 1 : 0);

                      return ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          if (hasAutoOption && index == 0) {
                            final isAutoSelected = selectedBarber == null;
                            return _buildAutomatiqueOption(
                                context, isAutoSelected);
                          }
                          final barber =
                              barbers[hasAutoOption ? index - 1 : index];
                          return BarberCard(
                            barber: barber,
                            isSelected: selectedBarber?.id == barber.id,
                            onTap: () {
                              onBarberSelected(barber);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAutomatiqueOption(BuildContext context, bool isAutoSelected) {
    return GestureDetector(
      onTap: () {
        onBarberSelected(null);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.cFFFFFF,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isAutoSelected ? AppColors.cB08D2A : AppColors.cEEEEEE,
            width: isAutoSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.r,
              height: 50.r,
              decoration: BoxDecoration(
                color: AppColors.cFAF5EE,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.autorenew,
                  color: AppColors.cB08D2A,
                  size: 24.r,
                ),
              ),
            ),
            UIHelper.horizontalSpace(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Votre barbier",
                    style: TextFontStyle.textStyle14c8A8A8AInter400.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.c8A8A8A,
                    ),
                  ),
                  Text(
                    "Automatique",
                    style: TextFontStyle.textStyle16c191919Inter600.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.c191919,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
