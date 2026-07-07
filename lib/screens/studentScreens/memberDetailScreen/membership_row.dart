import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class MembershipRow extends StatelessWidget {
  final double scale;
  final IconData icon;
  final String label;
  final String value;

  const MembershipRow({
    super.key,
    required this.scale,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28 * scale,
          child: Icon(icon, size: 24 * scale, color: AppColors.primarys),
        ),

        SizedBox(width: 14 * scale),

        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.bodyText,
              fontSize: 16 * scale,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(width: 10 * scale),

        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 16 * scale,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
