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
          SizedBox(height: 16 * scale),
          _SimpleLegend(
            color: AppColors.primary,
            label: 'Total Earnings',
            scale: scale,
          ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final selector = TrendPeriodSelector(
          selectedPeriod: period,
          onChanged: onPeriodChanged,
          scale: scale,
        );
        final summary = _TrendSummary(
          total: total,
          period: period,
          scale: scale,
        );

        if (constraints.maxWidth < 360) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [summary, const SizedBox(height: 16), selector],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: summary),
            SizedBox(width: 12 * scale),
            selector,
          ],
        );
      },
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
        SectionHeader(
          title: 'Earnings Trend',
          scale: scale,
          fontSize: 16 * scale,
        ),

        SizedBox(height: 8 * scale),
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

class _SimpleLegend extends StatelessWidget {
  const _SimpleLegend({
    required this.color,
    required this.label,
    required this.scale,
  });

  final Color color;
  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16 * scale,
          height: 16 * scale,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 12 * scale),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF747D93),
            fontSize: 13 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
