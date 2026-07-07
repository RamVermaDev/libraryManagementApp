import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

BoxDecoration cardDecoration({required double radius}) {
  return BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: AppColors.border, width: 1),
    boxShadow: const [
      BoxShadow(color: Color(0x0C172554), blurRadius: 24, offset: Offset(0, 7)),
    ],
  );
}