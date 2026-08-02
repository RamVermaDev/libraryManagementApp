import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class IconButtonStudent extends StatelessWidget {
  const IconButtonStudent({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.scale,
    this.badgeText,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final double scale;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18 * scale),
          onTap: onTap,
          child: Container(
            height: 100 * scale,
            padding: EdgeInsets.all(16 * scale),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16 * scale),
              border: Border.all(color: AppColors.grey200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 12 * scale,
                  offset: Offset(0, 4 * scale),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row: Icon + Optional Badge on Top Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, color: AppColors.heading, size: 20 * scale),
                    if (badgeText != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * scale,
                          vertical: 3 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(12 * scale),
                          border: Border.all(
                            color: const Color(0xFFDDD6FE),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          badgeText!,
                          style: TextStyle(
                            color: const Color(0xFF7C3AED),
                            fontSize: 11 * scale,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),

                const Spacer(),

                Text(
                  text,
                  style: TextStyle(
                    color: AppColors.heading,
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
