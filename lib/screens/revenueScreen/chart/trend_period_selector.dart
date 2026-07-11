import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

import 'chart_models.dart';

class TrendPeriodSelector extends StatelessWidget {
  const TrendPeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  final TrendPeriod selectedPeriod;
  final ValueChanged<TrendPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
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
          ),
          const SizedBox(width: 4),
          _TrendButton(
            title: TrendPeriod.twelveMonths.title,
            selected: selectedPeriod == TrendPeriod.twelveMonths,
            onTap: () => onChanged(TrendPeriod.twelveMonths),
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
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x221E3A8A),
                  blurRadius: 14,
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF747D93),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 14,
              ),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }
}
