import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../gen/colors.gen.dart';
import '../constants/text_font_style.dart';
import '../helpers/ui_helpers.dart';

import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool drawLabel;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool readOnly;
  final Color? fillColor;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final VoidCallback? onTap;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.label,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.drawLabel = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.focusNode,
    this.readOnly = false,
    this.fillColor,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.contentPadding,
    this.hintStyle,
    this.textStyle,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onTap,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.drawLabel && widget.label != null) ...[
          Text(
            widget.label!,
            style: TextFontStyle.textStyle14c1B1B1BInterTight600,
          ),
          UIHelper.verticalSpace(8.h),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          style:
              widget.textStyle ?? TextFontStyle.textStyle14c1B1B1BInterTight400,
          validator: widget.validator,
          decoration: InputDecoration(
            counterText: "",
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ??
                TextFontStyle.textStyle14c9B9B9BInterTight400,
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            filled: true,
            fillColor: widget.fillColor ?? AppColors.cFFFFFF,
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.all(12.r),
                    child: widget.prefixIcon,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.c191919,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.r),
              borderSide:
                  BorderSide(color: widget.borderColor ?? AppColors.cE3E3E3),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.r),
              borderSide:
                  BorderSide(color: widget.borderColor ?? AppColors.cE3E3E3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.r),
              borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? AppColors.c191919),
            ),
          ),
        ),
      ],
    );
  }
}
