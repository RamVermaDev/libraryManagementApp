import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ProfileInfo extends StatelessWidget {
  final double scale;
  final IconData icon;
  final String text;

  const ProfileInfo({
    super.key,
    required this.scale,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 25 * scale,
          child: Icon(icon, size: 22 * scale, color: AppColors.iconMuted),
        ),

        SizedBox(width: 10 * scale),

        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.heading,
              fontSize: 18 * scale,
              height: 1.1,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
