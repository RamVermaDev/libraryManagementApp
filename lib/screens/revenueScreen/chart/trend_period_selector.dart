import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

import 'chart_models.dart';

class TrendPeriodSelector extends StatelessWidget {
  const TrendPeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
    required this.scale,
  });

  final TrendPeriod selectedPeriod;
  final ValueChanged<TrendPeriod> onChanged;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TrendButton(
            title: TrendPeriod.thirtyDays.title,
            selected: selectedPeriod == TrendPeriod.thirtyDays,
            onTap: () => onChanged(TrendPeriod.thirtyDays),
            scale: scale,
          ),
          const SizedBox(width: 0.5),
          _TrendButton(
            title: TrendPeriod.twelveMonths.title,
            selected: selectedPeriod == TrendPeriod.twelveMonths,
            onTap: () => onChanged(TrendPeriod.twelveMonths),
            scale: scale,
          ),
        ],
      ),
    );
  }
}

class _TrendButton extends StatelessWidget {
  const _TrendButton({
    required this.title,
    required this.selected,
    required this.onTap,
    required this.scale,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected ? AppColors.activeButtonText : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Color(0x221E3A8A),
                  blurRadius: 14 * scale,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF747D93),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 9 * scale,
              ),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }
}
