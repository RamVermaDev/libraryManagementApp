import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ChartLegend extends StatelessWidget {
  const ChartLegend({
    super.key,
    required this.totalEarnings,
    required this.growthPercentage,
    required this.isPositive,
  });

  final String totalEarnings;
  final double growthPercentage;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final growthColor = isPositive
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);

    final growthIcon = isPositive
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32, color: Color(0xFFE9EDF3)),

        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 8),

            const Text(
              "Total Earnings",
              style: TextStyle(
                color: AppColors.body,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Text(
          totalEarnings,
          style: const TextStyle(
            color: AppColors.heading,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -.8,
            height: 1,
          ),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: growthColor.withOpacity(.08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(growthIcon, color: growthColor, size: 14),

                  const SizedBox(width: 4),

                  Text(
                    "${growthPercentage.abs().toStringAsFixed(1)}%",
                    style: TextStyle(
                      color: growthColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            const Expanded(
              child: Text(
                "Compared to previous period",
                style: TextStyle(
                  color: AppColors.caption,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
