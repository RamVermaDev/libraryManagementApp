import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ChartIndicator extends StatelessWidget {
  const ChartIndicator({super.key, this.size = 14});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: AppColors.primary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.25),
            blurRadius: 16,
            spreadRadius: 3,
          ),
        ],
      ),
    );
  }
}
