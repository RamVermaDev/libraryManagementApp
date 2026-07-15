import 'package:library_management/models/chart_point_model.dart';
import 'package:library_management/models/monthly_revenue_model.dart';
import 'package:library_management/models/payemnt_model.dart';
import 'package:library_management/models/revenue_summary_model.dart';

class RevenueState {
  /// Top Cards
  final RevenueSummaryModel? summary;

  /// Currently Selected Month
  final MonthlyRevenueModel? currentMonth;

  /// Month Cache
  ///
  /// Example:
  /// {
  ///   "2026-07": MonthlyRevenueModel(...),
  ///   "2026-06": MonthlyRevenueModel(...),
  /// }
  final Map<String, MonthlyRevenueModel>? monthCache;

  /// Recent Payments
  final List<PaymentModel>? recentPayments;

  /// Charts
  final List<ChartPointModel> thirtyDayTrend;

  final List<ChartPointModel> twelveMonthTrend;

  const RevenueState({
    this.summary,
    this.currentMonth,
    this.monthCache = const {},
    this.recentPayments = const [],
    this.thirtyDayTrend = const [],
    this.twelveMonthTrend = const [],
  });

  RevenueState copyWith({
    RevenueSummaryModel? summary,
    MonthlyRevenueModel? currentMonth,
    Map<String, MonthlyRevenueModel>? monthCache,
    List<PaymentModel>? recentPayments,
    List<ChartPointModel>? thirtyDayTrend,
    List<ChartPointModel>? twelveMonthTrend,
  }) {
    return RevenueState(
      summary: summary ?? this.summary,
      currentMonth: currentMonth ?? this.currentMonth,
      monthCache: monthCache ?? this.monthCache,
      recentPayments: recentPayments ?? this.recentPayments,
      thirtyDayTrend: thirtyDayTrend ?? this.thirtyDayTrend,
      twelveMonthTrend: twelveMonthTrend ?? this.twelveMonthTrend,
    );
  }

  RevenueState clear() {
    return const RevenueState();
  }
}
