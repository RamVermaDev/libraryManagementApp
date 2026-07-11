import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/chart/chart_models.dart';
import 'package:library_management/screens/revenueScreen/chart/earnings_line_chart.dart';
import 'package:library_management/screens/revenueScreen/chart/trend_period_selector.dart';
import 'package:library_management/screens/revenueScreen/revenue_card_decoration.dart';

class EarningsTrendCard extends StatelessWidget {
  const EarningsTrendCard({
    super.key,
    required this.points,
    required this.period,
    required this.onPeriodChanged,
  });

  final List<ChartPoint> points;
  final TrendPeriod period;
  final ValueChanged<TrendPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: AppCardDecoration.standard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Earnings Trend',
                  style: TextStyle(
                    color: Color(0xFF101B33),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TrendPeriodSelector(
                selectedPeriod: period,
                onChanged: onPeriodChanged,
              ),
            ],
          ),
          const SizedBox(height: 28),
          EarningsLineChart(points: points, period: period, height: 250),
          const SizedBox(height: 16),
          const _SimpleLegend(
            color: AppColors.primary,
            label: 'Total Earnings',
          ),
        ],
      ),
    );
  }
}

class _SimpleLegend extends StatelessWidget {
  const _SimpleLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF747D93),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
