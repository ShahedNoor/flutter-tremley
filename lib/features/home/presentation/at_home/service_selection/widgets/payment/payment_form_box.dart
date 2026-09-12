import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tremley_cutomer/common_widgets/custom_textform_field.dart';
import 'package:tremley_cutomer/gen/colors.gen.dart';
import 'package:tremley_cutomer/helpers/ui_helpers.dart';

class PaymentFormBox extends StatefulWidget {
  const PaymentFormBox({super.key});

  @override
  State<PaymentFormBox> createState() => _PaymentFormBoxState();
}

class _PaymentFormBoxState extends State<PaymentFormBox> {
  final TextEditingController _expiryController = TextEditingController();
  String _previousValue = '';

  @override
  void initState() {
    super.initState();
    _expiryController.addListener(_formatExpiryDate);
  }

  @override
  void dispose() {
    _expiryController.removeListener(_formatExpiryDate);
    _expiryController.dispose();
    super.dispose();
  }

  void _formatExpiryDate() {
    String value = _expiryController.text;

    // Detect if the user is backspacing over the separator
    if (value.length < _previousValue.length) {
      if (value.endsWith('/')) {
        _previousValue = value;
        return;
      }
    }

    // Only format if we are adding characters and reached the threshold
    String cleanValue = value.replaceAll(RegExp(r'\D'), '');

    if (cleanValue.length > 4) {
      cleanValue = cleanValue.substring(0, 4);
    }

    String formattedValue = '';
    if (cleanValue.length >= 2) {
      // If we have at least 2 digits, ensure the slash is present
      formattedValue = cleanValue.substring(0, 2);
      if (cleanValue.length > 2) {
        formattedValue += '/${cleanValue.substring(2)}';
      } else {
        // If we just reached 2 digits, add the slash automatically
        formattedValue += '/';
      }
    } else {
      formattedValue = cleanValue;
    }

    // Update if different and we're not currently deleting exactly the slash
    if (formattedValue != value && value.length >= _previousValue.length) {
      _expiryController.value = TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    }

    _previousValue = _expiryController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cF6F6F6,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cEEEEEE, width: 1),
      ),
      child: Column(
        children: [
          const CustomTextFormField(
            hintText: "Numéro de carte",
            drawLabel: false,
            fillColor: AppColors.cFFFFFF,
            borderColor: AppColors.cEEEEEE,
          ),
          UIHelper.verticalSpace(16.h),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: _expiryController,
                  hintText: "MM/AA",
                  drawLabel: false,
                  fillColor: AppColors.cFFFFFF,
                  borderColor: AppColors.cEEEEEE,
                  keyboardType: TextInputType.number,
                ),
              ),
              UIHelper.horizontalSpace(16.w),
              const Expanded(
                child: CustomTextFormField(
                  hintText: "CVC",
                  drawLabel: false,
                  fillColor: AppColors.cFFFFFF,
                  borderColor: AppColors.cEEEEEE,
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          const CustomTextFormField(
            hintText: "Nom sur la carte",
            drawLabel: false,
            fillColor: AppColors.cFFFFFF,
            borderColor: AppColors.cEEEEEE,
          ),
        ],
      ),
    );
  }
}
