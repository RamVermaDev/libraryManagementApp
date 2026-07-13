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
  // final List<ChartPointModel> thirtyDayTrend;

  // final List<ChartPointModel> twelveMonthTrend;

  /// Loading
  //final bool isLoading;

  const RevenueState({
    this.summary,
    this.currentMonth,
    this.monthCache = const {},
    this.recentPayments = const [],
    // this.thirtyDayTrend = const [],
    // this.twelveMonthTrend = const [],
    //this.isLoading = false,
  });

  RevenueState copyWith({
    RevenueSummaryModel? summary,
    MonthlyRevenueModel? currentMonth,
    Map<String, MonthlyRevenueModel>? monthCache,
    List<PaymentModel>? recentPayments,
    // List<ChartPointModel>? thirtyDayTrend,
    // List<ChartPointModel>? twelveMonthTrend,
    //bool? isLoading,
  }) {
    return RevenueState(
      summary: summary ?? this.summary,
      currentMonth: currentMonth ?? this.currentMonth,
      monthCache: monthCache ?? this.monthCache,
      recentPayments: recentPayments ?? this.recentPayments,
      // thirtyDayTrend: thirtyDayTrend ?? this.thirtyDayTrend,
      // twelveMonthTrend: twelveMonthTrend ?? this.twelveMonthTrend,
      //isLoading: isLoading ?? this.isLoading,
    );
  }

  RevenueState clear() {
    return const RevenueState();
  }
}

// class ChartPointModel {
//   static Object? fromMap(e) {}
// }
