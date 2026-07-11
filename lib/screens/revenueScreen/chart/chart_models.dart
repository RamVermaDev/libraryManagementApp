import 'package:flutter/material.dart';

@immutable
class ChartPoint {
  const ChartPoint({
    required this.x,
    required this.y,
    required this.label,
    required this.valueLabel,
  });

  final double x;
  final double y;

  /// Example:
  /// 30 Jun
  final String label;

  /// Example:
  /// ₹1,400
  final String valueLabel;
}

enum TrendPeriod { thirtyDays, twelveMonths }

extension TrendPeriodExtension on TrendPeriod {
  String get title {
    switch (this) {
      case TrendPeriod.thirtyDays:
        return "30 Days";

      case TrendPeriod.twelveMonths:
        return "12 Months";
    }
  }
}
