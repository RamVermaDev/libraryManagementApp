import 'package:library_management/models/chart_point_model.dart';
import 'package:library_management/models/monthly_revenue_model.dart';
import 'package:library_management/models/payemnt_model.dart';
import 'package:library_management/models/revenue_summary_model.dart';

class RevenueDashboardModel {
  final RevenueSummaryModel summary;

  final MonthlyRevenueModel monthSummary;

  final List<PaymentModel> recentPayments;

  final List<ChartPointModel> trend30Days;

  final List<ChartPointModel> trend12Months;

  const RevenueDashboardModel({
    required this.summary,
    required this.monthSummary,
    required this.recentPayments,
    required this.trend30Days,
    required this.trend12Months,
  });

  factory RevenueDashboardModel.fromMap(Map<String, dynamic> map) {
    return RevenueDashboardModel(
      summary: RevenueSummaryModel.fromMap(map['summary']),

      monthSummary: MonthlyRevenueModel.fromMap(map['monthSummary']),
      recentPayments: (map['recentPayments'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(PaymentModel.fromMap)
          .toList(),

      trend30Days: (map['trend30Days'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(ChartPointModel.fromMap)
          .toList(),

      trend12Months: (map['trend12Months'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(ChartPointModel.fromMap)
          .toList(),
    );
  }
}
