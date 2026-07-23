import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class PaymentRow extends StatelessWidget {
  final double scale;
  final String label;
  final String value;
  final Color labelColor;
  final Color? valueColor;
  final Color? backgroundColor;

  const PaymentRow({
    super.key,
    required this.scale,
    required this.label,
    required this.value,
    required this.labelColor,
    this.valueColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 * scale,
      padding: EdgeInsets.symmetric(horizontal: 17 * scale),
      color: backgroundColor ?? Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 15 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.heading,
              fontSize: 16 * scale,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
