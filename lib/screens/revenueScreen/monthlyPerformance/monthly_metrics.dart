import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class MonthlyMetrics extends StatelessWidget {
  const MonthlyMetrics({
    super.key,
    required this.revenue,
    required this.expenses,
    required this.profit,
  });

  final double revenue;
  final double expenses;
  final double profit;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: MonthlyMetricItem(
              label: 'Revenue',
              amount: revenue,
              color: AppColors.heading,
            ),
          ),

          const _OperatorSymbol('-'),

          Expanded(
            child: MonthlyMetricItem(
              label: 'Expenses',
              amount: expenses,
              color: AppColors.heading,
            ),
          ),

          const _OperatorSymbol('='),

          Expanded(
            child: MonthlyMetricItem(
              label: 'Profit',
              amount: profit,
              signed: true,
              color: profit >= 0 ? AppColors.primary : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

class MonthlyMetricItem extends StatelessWidget {
  const MonthlyMetricItem({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    this.signed = false,
  });

  final String label;
  final double amount;
  final Color color;
  final bool signed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.body,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            CurrencyFormatter.format(amount, signed: signed),
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _OperatorSymbol extends StatelessWidget {
  const _OperatorSymbol(this.symbol);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          symbol,
          style: const TextStyle(
            color: AppColors.caption,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
