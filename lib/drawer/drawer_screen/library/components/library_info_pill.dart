import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class LibraryInfoPill extends StatelessWidget {
  const LibraryInfoPill({
    super.key,
    required this.seats,
    required this.isCurrent,
    required this.onChanged,
    this.scale = 1,
  });

  final int seats;
  final bool isCurrent;
  final ValueChanged<bool> onChanged;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primarySoft : AppColors.background,
        borderRadius: BorderRadius.circular(14 * scale),
      ),
      child: Row(
        children: [
          // Simple minimal seat icon without heavy 3D background box
          Icon(
            Icons.event_seat_outlined,
            color: isCurrent ? AppColors.primary : AppColors.caption,
            size: 20 * scale,
          ),

          SizedBox(width: 8 * scale),

          Text(
            '$seats Seats',
            style: TextStyle(
              fontSize: 14 * scale,
              fontWeight: FontWeight.bold,
              color: AppColors.heading,
            ),
          ),

          const Spacer(),

          // Minimal "Active" status badge using AppColors and few words
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11 * scale,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(width: 6 * scale),

          // Clean switch toggle
          Transform.scale(
            scale: 0.75 * scale,
            child: Switch.adaptive(
              value: isCurrent,
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
