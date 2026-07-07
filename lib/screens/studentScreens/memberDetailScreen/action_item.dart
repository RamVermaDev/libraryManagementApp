import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ActionItem extends StatelessWidget {
  final double scale;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ActionItem({
    super.key,
    required this.scale,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30 * scale, color: color),

              SizedBox(height: 10 * scale),

              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.bodyText,
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
