import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ChartTooltip extends StatelessWidget {
  const ChartTooltip({super.key, required this.amount, required this.date});

  final String amount;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECF2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: AppColors.heading,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.4,
                  height: 1,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                date,
                style: const TextStyle(
                  color: AppColors.caption,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
