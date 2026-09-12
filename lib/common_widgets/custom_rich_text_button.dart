// lib/widgets/buttons/custom_rich_text_button.dart
import 'package:flutter/material.dart';
import '../gen/colors.gen.dart';
import '/constants/text_font_style.dart';

class CustomRichTextButton extends StatelessWidget {
  const CustomRichTextButton({
    super.key,
    required this.onPressed,
    required this.additionalText,
    required this.buttonText,
    this.textAlign = TextAlign.center,
  });

  final VoidCallback onPressed;
  final String additionalText;
  final String buttonText;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          children: [
            TextSpan(
              text: additionalText,
              style: TextFontStyle.textStyle14c1B1B1BInterTight400,
            ),
            TextSpan(
              text: buttonText,
              style: TextFontStyle.textStyle14cB08D2AInterTight400
                  .copyWith(color: AppColors.cB08D2A),
            ),
          ],
        ),
      ),
    );
  }
}
