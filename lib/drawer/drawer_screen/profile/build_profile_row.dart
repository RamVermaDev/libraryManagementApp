import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

Widget buildProfileRow({
  required String title,
  required Widget child,
  double scale = 1,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: 13 * scale,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Align(alignment: Alignment.centerRight, child: child),
        ),
      ],
    ),
  );
}
