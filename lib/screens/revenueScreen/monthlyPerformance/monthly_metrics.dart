import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class MonthlyMetrics extends StatelessWidget {
  const MonthlyMetrics({
    super.key,
    required this.revenue,
    required this.expenses,
    required this.scale,
  });

  final double? revenue;
  final double? expenses;

  final double scale;

  @override
  Widget build(BuildContext context) {
    final double? profit = revenue != null && expenses != null
        ? revenue! - expenses!
        : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: MonthlyMetricItem(
              label: 'Revenue',
              amount: revenue,
              color: AppColors.heading,
              scale: scale,
            ),
          ),

          _OperatorSymbol('-', scale: scale),

          Expanded(
            child: MonthlyMetricItem(
              label: 'Expenses',
              amount: expenses,
              color: AppColors.heading,
              scale: scale,
            ),
          ),

          _OperatorSymbol('=', scale: scale),

          Expanded(
            child: MonthlyMetricItem(
              label: 'Profit',
              amount: profit,
              signed: true,
              color: profit == null
                  ? AppColors.accent
                  : profit >= 0
                  ? const Color.fromARGB(255, 90, 117, 239)
                  : AppColors.error,
              scale: scale,
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
    required this.scale,
  });

  final String label;
  final double? amount;
  final Color color;
  final bool signed;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.body,
            fontSize: 11 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6 * scale),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: amount == null
              ? SpinKitThreeBounce(color: color, size: 14 * scale)
              : Text(
                  CurrencyFormatter.format(amount, signed: signed),
                  style: TextStyle(
                    color: color,
                    fontSize: 15 * scale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ],
    );
  }
}

class _OperatorSymbol extends StatelessWidget {
  const _OperatorSymbol(this.symbol, {required this.scale});

  final String symbol;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8 * scale),
        child: Text(
          symbol,
          style: TextStyle(
            color: AppColors.caption,
            fontSize: 22 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
