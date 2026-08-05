import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ActiveStatusBanner extends StatelessWidget {
  const ActiveStatusBanner({
    super.key,
    required this.isTrial,
    required this.daysRemaining,
    required this.expiryDateText,
  });

  final bool isTrial;
  final int daysRemaining;
  final String expiryDateText;

  @override
  Widget build(BuildContext context) {
    final isExpired = daysRemaining <= 0;
    final badgeColor = isExpired
        ? const Color(0xFFEF4444)
        : isTrial
            ? AppColors.primary
            : const Color(0xFF10B981);

    final badgeText = isExpired
        ? 'TRIAL EXPIRED'
        : isTrial
            ? 'TRIAL ACTIVE'
            : 'PRO PLAN ACTIVE';

    final bgTint = isExpired
        ? const Color(0xFFFEF2F2)
        : AppColors.primary.withValues(alpha: 0.08);

    final borderColor = isExpired
        ? const Color(0xFFFCA5A5)
        : AppColors.primary.withValues(alpha: 0.2);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                isExpired ? '0 Days Left' : '$daysRemaining Days Left',
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isExpired ? 'Trial Expired' : 'Full Access to All Features',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isExpired
                ? 'Your free trial has expired. Upgrade to keep using all features.'
                : 'Your free trial is valid until $expiryDateText.',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.caption,
            ),
          ),
        ],
      ),
    );
  }
}
