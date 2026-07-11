import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.fontSize,
    this.weight,
  });

  final String title;
  final Widget? trailing;
  final double? fontSize;
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFF101B33),
              fontSize: fontSize ?? 20,
              fontWeight: weight ?? FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),

        if (trailing != null) trailing!,
      ],
    );
  }
}
