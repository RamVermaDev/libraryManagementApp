import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/chart/chart_models.dart';
import 'package:library_management/screens/revenueScreen/chart/earnings_line_chart.dart';
import 'package:library_management/screens/revenueScreen/chart/trend_period_selector.dart';
import 'package:library_management/screens/revenueScreen/revenue_card_decoration.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';
import 'package:library_management/screens/revenueScreen/section_header.dart';

class EarningsTrendCard extends StatelessWidget {
  const EarningsTrendCard({
    super.key,
    required this.points,
    required this.period,
    required this.onPeriodChanged,
    required this.scale,
  });

  final List<ChartPoint> points;
  final TrendPeriod period;
  final ValueChanged<TrendPeriod> onPeriodChanged;

  final double scale;

  @override
  Widget build(BuildContext context) {
    final total = points.fold<double>(0, (sum, point) => sum + point.y);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: AppCardDecoration.standard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TrendHeader(
            total: total,
            period: period,
            onPeriodChanged: onPeriodChanged,
            scale: scale,
          ),
          SizedBox(height: 24 * scale),
          EarningsLineChart(points: points, period: period, height: 250),
        ],
      ),
    );
  }
}

class _TrendHeader extends StatelessWidget {
  const _TrendHeader({
    required this.total,
    required this.period,
    required this.onPeriodChanged,
    required this.scale,
  });

  final double total;
  final TrendPeriod period;
  final ValueChanged<TrendPeriod> onPeriodChanged;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final selector = TrendPeriodSelector(
      selectedPeriod: period,
      onChanged: onPeriodChanged,
      scale: scale,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SectionHeader(
                title: 'Earnings Trend',
                scale: scale,
                fontSize: 16 * scale,
              ),
            ),
            SizedBox(width: 8 * scale),
            selector,
          ],
        ),
        SizedBox(height: 4 * scale),
        _TrendSummary(
          total: total,
          period: period,
          scale: scale,
        ),
      ],
    );
  }
}

class _TrendSummary extends StatelessWidget {
  const _TrendSummary({
    required this.total,
    required this.period,
    required this.scale,
  });

  final double total;
  final TrendPeriod period;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            CurrencyFormatter.format(total),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18 * scale,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 3 * scale),
        Text(
          period == TrendPeriod.thirtyDays
              ? 'Last 30 days income'
              : 'Last 12 months income',
          style: TextStyle(
            color: AppColors.caption,
            fontSize: 9 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
