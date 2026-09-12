import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/constants/text_font_style.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';
import 'package:tremley_cutomer/features/home/model/service_list_model.dart';

class PaymentSummaryCard extends StatelessWidget {
  final List<dynamic>? selectedServices;
  final double? totalPrice;

  const PaymentSummaryCard({super.key, this.selectedServices, this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cFFFFFF,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cEEEEEE, width: 1),
      ),
      child: Column(
        children: [
          if (selectedServices != null && selectedServices!.isNotEmpty)
            ...selectedServices!.map((service) {
              if (service is ServiceItem) {
                final double price =
                    double.tryParse(service.servicePrice?.price ?? '0') ?? 0;
                final double discount =
                    double.tryParse(service.servicePrice?.discount ?? '0') ?? 0;
                final double finalPrice = price - discount;

                String priceText =
                    "${finalPrice % 1 == 0 ? finalPrice.toInt() : finalPrice.toStringAsFixed(2)} €";
                if (service.quantity > 1) {
                  priceText = "${service.quantity}x $priceText";
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildSummaryRow(
                      service.serviceName ?? "Service", priceText),
                );
              }
              return const SizedBox.shrink();
            }),
          _buildSummaryRow("Frais de déplacement", "10 €"),
          UIHelper.verticalSpace(12.h),
          const Divider(color: AppColors.cEEEEEE),
          UIHelper.verticalSpace(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total à payer",
                  style: TextFontStyle.textStyle16c1B1B1BInterTight600),
              Text(
                  "${((totalPrice ?? 0) + 10).toStringAsFixed(2)} €", // Assuming 10 is fixed travel fee for now
                  style: TextFontStyle.textStyle16c1B1B1BInterTight600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextFontStyle.textStyle16c9B9B9BInterTight500),
        Text(value, style: TextFontStyle.textStyle16c1B1B1BInterTight700),
      ],
    );
  }
}
