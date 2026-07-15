import 'package:flutter/material.dart';
import 'package:library_management/context_extension.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/revenue_summary_controller.dart';
import 'package:library_management/models/chart_point_model.dart' as backend;
import 'package:library_management/provider/revenue_provider.dart';
import 'package:library_management/screens/revenueScreen/addExpense/add_expense_screen.dart';
import 'package:library_management/screens/revenueScreen/chart/chart_models.dart';
import 'package:library_management/screens/revenueScreen/chart/earnings_trend_card.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/monthly_summary_card.dart';
import 'package:library_management/screens/revenueScreen/earningSummary/revenue_overview.dart';
import 'package:library_management/screens/revenueScreen/recentPayement/recent_payements_section.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class RevenueAnalyticsScreen extends ConsumerStatefulWidget {
  const RevenueAnalyticsScreen({super.key});

  @override
  ConsumerState<RevenueAnalyticsScreen> createState() =>
      _RevenueAnalyticsScreenState();
}

class _RevenueAnalyticsScreenState
    extends ConsumerState<RevenueAnalyticsScreen> {
  DateTime _selectedMonth = DateTime.now();
  TrendPeriod _selectedPeriod = TrendPeriod.thirtyDays;

  final _revenueSummaryController = RevenueSummaryController();

  @override
  void initState() {
    _getRevenue();
    super.initState();
  }

  Future<void> _getRevenue() async {
    final revenueState = ref.read(revenueProvider);

    // Already loaded once, don't call the API again.
    if (revenueState.summary != null) {
      return;
    }

    try {
      await _revenueSummaryController.getRevenueSummary(
        context: context,
        ref: ref,
        libraryId: '6a422593f2ed24f734e41864',
      );
    } finally {}
  }

  Future<void> _refreshRevenue() async {
    await _revenueSummaryController.getRevenueSummary(
      context: context,
      ref: ref,
      libraryId: '6a422593f2ed24f734e41864',
    );
  }

  Future<void> _loadMonth(DateTime month) async {
    final notifier = ref.read(revenueProvider.notifier);

    if (notifier.hasMonth(year: month.year, month: month.month)) {
      notifier.setCurrentMonth(year: month.year, month: month.month);
      return;
    }

    await _revenueSummaryController.getMonthlyRevenue(
      context: context,
      ref: ref,
      libraryId: '6a422593f2ed24f734e41864',
      year: month.year,
      month: month.month,
    );
  }

  bool get _canGoPrevious {
    return true;
  }

  bool get _canGoNext {
    final now = DateTime.now();

    return _monthNumber(_selectedMonth) <
        _monthNumber(DateTime(now.year, now.month));
  }

  Future<void> _changeMonth(int offset) async {
    final month = DateTime(_selectedMonth.year, _selectedMonth.month + offset);

    setState(() {
      _selectedMonth = month;
    });

    await _loadMonth(month);
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.scale;
    final revenue = ref.watch(revenueProvider);
    final monthSummary = revenue.currentMonth;
    final summary = revenue.summary;
    final recentPayment = revenue.recentPayments;
    final chartPoints = _selectedPeriod == TrendPeriod.thirtyDays
        ? _dailyPoints(revenue.thirtyDayTrend)
        : _monthlyPoints(revenue.twelveMonthTrend);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddExpenseScreen(),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        // shape: const CircleBorder(),
        // child: const Icon(Icons.add_rounded, size: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text(
          'Expense',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refreshRevenue,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 0),
                sliver: SliverToBoxAdapter(
                  child: RevenueOverview(
                    today: summary?.todayIncome,
                    month: summary?.monthlyIncome,
                    year: summary?.yearlyIncome,
                    allTime: summary?.allTimeIncome,
                    scale: scale,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                sliver: SliverToBoxAdapter(
                  child: MonthlySummaryCard(
                    selectedMonth: _selectedMonth,
                    revenue: monthSummary?.income,
                    expenses: monthSummary?.expense,
                    expenseItems: monthSummary?.expenses,
                    canGoPrevious: _canGoPrevious,
                    canGoNext: _canGoNext,
                    onPreviousMonth: () => _changeMonth(-1),
                    onNextMonth: () => _changeMonth(1),
                    scale: scale,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                sliver: SliverToBoxAdapter(
                  child: EarningsTrendCard(
                    points: chartPoints,
                    period: _selectedPeriod,
                    onPeriodChanged: (period) {
                      setState(() => _selectedPeriod = period);
                    },
                    scale: scale,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 34, 22, 110),
                sliver: SliverToBoxAdapter(
                  child: RecentPaymentsSection(
                    payments: recentPayment,
                    scale: scale,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ChartPoint> _dailyPoints(List<backend.ChartPointModel> trend) {
    final totals = {
      for (final point in trend)
        _dayKey(point.year, point.month, point.day ?? 0): point.income,
    };
    final today = DateTime.now();
    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 29));

    return List.generate(30, (index) {
      final date = start.add(Duration(days: index));
      final total = totals[_dayKey(date.year, date.month, date.day)] ?? 0;

      return ChartPoint(
        x: index.toDouble(),
        y: total,
        label: DateFormatter.shortDate(date),
        valueLabel: CurrencyFormatter.format(total),
      );
    });
  }

  List<ChartPoint> _monthlyPoints(List<backend.ChartPointModel> trend) {
    final totals = {
      for (final point in trend)
        _monthKey(point.year, point.month): point.income,
    };
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 11);

    return List.generate(12, (index) {
      final date = DateTime(start.year, start.month + index);
      final total = totals[_monthKey(date.year, date.month)] ?? 0;

      return ChartPoint(
        x: index.toDouble(),
        y: total,
        label: DateFormatter.shortMonthYear(date),
        valueLabel: CurrencyFormatter.format(total),
      );
    });
  }

  static String _dayKey(int year, int month, int day) => '$year-$month-$day';
  static String _monthKey(int year, int month) => '$year-$month';
  static int _monthNumber(DateTime date) => date.year * 12 + date.month;
}
