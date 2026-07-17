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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xffF5F9FF) : AppColors.grey50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const SizedBox(width: 6),
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.event_seat_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Text(
            "$seats",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),

          const Spacer(),

          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, size: 12, color: AppColors.primary),

                  SizedBox(width: 3),

                  Text(
                    "Current",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(width: 6),

          Transform.scale(
            scale: .62,
            child: Switch.adaptive(
              value: isCurrent,
              //activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
