import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ActionItem extends StatelessWidget {
  final double scale;
  final IconData? icon;
  final String? iconImage;
  final String label;
  final Color color;
  final Color? labelColor;
  final VoidCallback? onTap;

  const ActionItem({
    super.key,
    required this.scale,
    this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.iconImage,
    this.labelColor,
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
              icon != null
                  ? Icon(icon, size: 24 * scale, color: color)
                  : Image.asset(
                      iconImage!,
                      width: 24 * scale,
                      height: 24 * scale,
                      color: color, // Optional: tints monochrome images
                    ),

              SizedBox(height: 8 * scale),

              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    color: labelColor ?? AppColors.body,
                    fontSize: 10 * scale,
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
