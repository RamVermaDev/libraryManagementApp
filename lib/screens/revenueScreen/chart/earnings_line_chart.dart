import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

import 'chart_formatter.dart';
import 'chart_models.dart';

class EarningsLineChart extends StatefulWidget {
  const EarningsLineChart({
    super.key,
    required this.points,
    required this.period,
    this.height = 250,
  });

  final List<ChartPoint> points;
  final TrendPeriod period;
  final double height;

  @override
  State<EarningsLineChart> createState() => _EarningsLineChartState();
}

class _EarningsLineChartState extends State<EarningsLineChart> {
  int _selectedIndex = -1;

  @override
  void didUpdateWidget(covariant EarningsLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_selectedIndex >= widget.points.length) {
      _selectedIndex = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text(
            'No earnings available',
            style: TextStyle(
              color: AppColors.caption,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: LineChart(
        _chartData(),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  LineChartData _chartData() {
    return LineChartData(
      minX: widget.points.first.x - .35,
      maxX: widget.points.last.x + .35,
      minY: -_maxY * .05,
      maxY: _maxY,

      clipData: const FlClipData.none(),

      borderData: FlBorderData(show: false),

      gridData: _gridData(),

      titlesData: _titlesData(),

      lineTouchData: _touchData(),

      lineBarsData: [_lineBar()],

      extraLinesData: const ExtraLinesData(),

      showingTooltipIndicators: _selectedPoint == null
          ? []
          : [
              ShowingTooltipIndicators([
                LineBarSpot(
                  _lineBar(),
                  0,
                  FlSpot(_selectedPoint!.x, _selectedPoint!.y),
                ),
              ]),
            ],
    );
  }

  double get _maxY {
    final highest = widget.points
        .map((e) => e.y)
        .reduce((a, b) => a > b ? a : b);

    return highest <= 0 ? 1 : highest * 1.25;
  }

  ChartPoint? get _selectedPoint {
    if (_selectedIndex < 0 || _selectedIndex >= widget.points.length) {
      return null;
    }

    return widget.points[_selectedIndex];
  }

  LineChartBarData _lineBar() {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: .35,
      isStrokeCapRound: true,
      barWidth: 4,

      color: AppColors.primary,

      spots: widget.points.map((e) => FlSpot(e.x, e.y)).toList(),

      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: .20),
            AppColors.primary.withValues(alpha: .01),
          ],
        ),
      ),

      dotData: FlDotData(
        checkToShowDot: (spot, barData) {
          return spot.x.toInt() == _selectedIndex;
        },

        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 7,
            color: Colors.white,
            strokeWidth: 3,
            strokeColor: AppColors.primary,
          );
        },
      ),
    );
  }

  FlGridData _gridData() {
    return FlGridData(
      drawVerticalLine: false,

      horizontalInterval: _maxY / 4,

      getDrawingHorizontalLine: (_) {
        return FlLine(color: const Color(0xFFEAEFF5), strokeWidth: 1);
      },
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      topTitles: const AxisTitles(),

      rightTitles: const AxisTitles(),

      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 42,
          interval: _maxY / 4,
          getTitlesWidget: (value, meta) {
            return Text(
              ChartFormatter.compact(value),
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.caption,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ),

      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 38,
          interval: 1,
          getTitlesWidget: (value, meta) {
            final index = _pointIndexForX(value);

            if (index == null || !_shouldShowBottomTitle(index)) {
              return const SizedBox();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: widget.period == TrendPeriod.thirtyDays ? 44 : 38,
                child: Text(
                  _bottomLabel(widget.points[index].label),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.15,
                    color: AppColors.caption,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  LineTouchData _touchData() {
    return LineTouchData(
      enabled: true,
      handleBuiltInTouches: true,
      touchSpotThreshold: 32,

      touchCallback: (event, response) {
        if (!mounted) return;

        if (event is FlTapUpEvent ||
            event is FlLongPressEnd ||
            event is FlPanEndEvent ||
            response == null ||
            response.lineBarSpots == null ||
            response.lineBarSpots!.isEmpty) {
          setState(() {
            _selectedIndex = -1;
          });
          return;
        }

        final index = response.lineBarSpots!.first.spotIndex;

        if (index != _selectedIndex) {
          setState(() {
            _selectedIndex = index;
          });
        }
      },

      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: AppColors.primary.withValues(alpha: .20),
                  strokeWidth: 1.5,
                  dashArray: [6, 4],
                ),
                FlDotData(
                  getDotPainter: (spot, percent, bar, index) {
                    return FlDotCirclePainter(
                      radius: 7,
                      color: Colors.white,
                      strokeWidth: 3,
                      strokeColor: AppColors.primary,
                    );
                  },
                ),
              );
            }).toList();
          },

      touchTooltipData: LineTouchTooltipData(
        //tooltipRoundedRadius: 18,
        fitInsideHorizontally: true,

        fitInsideVertically: true,

        tooltipBorder: BorderSide(color: const Color(0xFFE9EDF3)),

        tooltipPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        tooltipMargin: 16,

        getTooltipColor: (_) => Colors.white,

        getTooltipItems: (spots) {
          return spots.map((spot) {
            final point = widget.points[spot.spotIndex];

            return LineTooltipItem(
              "${point.valueLabel}\n",
              const TextStyle(
                color: AppColors.heading,
                fontWeight: FontWeight.w700,
                fontSize: 17,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: point.label,
                  style: const TextStyle(
                    color: AppColors.caption,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList();
        },
      ),
    );
  }

  int? _pointIndexForX(double x) {
    final rounded = x.round();

    if ((x - rounded).abs() > .01 ||
        rounded < 0 ||
        rounded >= widget.points.length) {
      return null;
    }

    return rounded;
  }

  bool _shouldShowBottomTitle(int index) {
    if (widget.period == TrendPeriod.thirtyDays) {
      return index == 0 ||
          index == 7 ||
          index == 14 ||
          index == 21 ||
          index == 29;
    }

    return index.isEven || index == widget.points.length - 1;
  }

  String _bottomLabel(String label) {
    if (widget.period == TrendPeriod.twelveMonths) {
      return label.replaceFirst(' ', '\n');
    }

    return label;
  }
}
