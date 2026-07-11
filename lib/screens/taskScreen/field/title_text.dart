import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.title,
    this.fontSize,
    this.fontColor,
    this.weight,
  });

  final String title;
  final double? fontSize;
  final Color? fontColor;
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize ?? 14,
        fontWeight: weight ?? FontWeight.w600,
        color: fontColor ?? Color(0xFF344054),
      ),
    );
  }
}
