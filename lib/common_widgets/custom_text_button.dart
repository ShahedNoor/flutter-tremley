// lib/widgets/buttons/custom_text_button.dart
import 'package:flutter/material.dart';

import '/constants/text_font_style.dart';

class CustomTexButton extends StatelessWidget {
  const CustomTexButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.textStyle,
    this.padding,
    this.alignment = Alignment.centerRight,
  });

  final VoidCallback onPressed;
  final String title;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
          child: Text(
            title,
            style: textStyle ?? TextFontStyle.textStyle14cB08D2AInterTight600,
          ),
        ),
      ),
    );
  }
}
