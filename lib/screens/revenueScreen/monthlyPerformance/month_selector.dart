import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime selectedMonth;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MonthArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: canGoPrevious,
            onTap: onPrevious,
          ),
          SizedBox(
            width: 55,
            child: Text(
              DateFormatter.shortMonthYear(selectedMonth),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          MonthArrowButton(
            icon: Icons.chevron_right_rounded,
            enabled: canGoNext,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class MonthArrowButton extends StatelessWidget {
  const MonthArrowButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary.withValues(alpha: 0.08)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 24,
          color: enabled ? AppColors.primary : const Color(0xFFC6CCD8),
        ),
      ),
    );
  }
}
