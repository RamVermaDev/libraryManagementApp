import 'package:flutter/material.dart';
import 'package:library_management/context_extension.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/revenue_summary_controller.dart';
import 'package:library_management/provider/revenue_provider.dart';
import 'package:library_management/screens/revenueScreen/addExpense/add_expense_screen.dart';
import 'package:library_management/screens/revenueScreen/chart/chart_models.dart';
import 'package:library_management/screens/revenueScreen/chart/earnings_trend_card.dart';
import 'package:library_management/screens/revenueScreen/dataset.dart';
import 'package:library_management/screens/revenueScreen/expense_item.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/monthly_summary_card.dart';
import 'package:library_management/screens/revenueScreen/earningSummary/revenue_overview.dart';
import 'package:library_management/screens/revenueScreen/payement_item.dart';
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
  DateTime _selectedMonth = DateTime(2026, 6);
  TrendPeriod _selectedPeriod = TrendPeriod.thirtyDays;

  late final List<PaymentItem> _payments = List.unmodifiable(paymentItems);
  late final List<ExpenseItem> _expenses = List.unmodifiable(expenseItems);

  final _revenueSummaryController = RevenueSummaryController();
  bool _isloading = false;

  // final ScrollController _scrollController = ScrollController();
  // double _titleOpacity = 0;

  @override
  void initState() {
    _getRevenue();

    // _scrollController.addListener(() {
    //   const fadeStart = 40.0;
    //   const fadeEnd = 110.0;

    //   final opacity =
    //       ((_scrollController.offset - fadeStart) / (fadeEnd - fadeStart))
    //           .clamp(0.0, 1.0);

    //   if (opacity != _titleOpacity) {
    //     setState(() => _titleOpacity = opacity);
    //   }
    // });
    super.initState();
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  List<PaymentItem> get _selectedPayments {
    final items = _payments
        .where((item) => _sameMonth(item.paidAt, _selectedMonth))
        .toList();
    items.sort((a, b) => b.paidAt.compareTo(a.paidAt));
    return items;
  }

  Future<void> _getRevenue() async {
    setState(() {
      _isloading = true;
    });
    try {
      _revenueSummaryController.getRevenueSummary(
        context: context,
        ref: ref,
        libraryId: '6a422593f2ed24f734e41864',
      );
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  List<ExpenseItem> get _selectedExpenses {
    final items = _expenses
        .where((item) => _sameMonth(item.expenseDate, _selectedMonth))
        .toList();
    items.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    return items;
  }

  double get _monthlyRevenue => _sum(_selectedPayments.map((e) => e.amount));
  double get _monthlyExpense => _sum(_selectedExpenses.map((e) => e.amount));
  double get _monthlyProfit => _monthlyRevenue - _monthlyExpense;
  //double get _allTimeIncome => _sum(_payments.map((e) => e.amount));

  // double get _yearIncome => _sum(
  //   _payments
  //       .where((item) => item.paidAt.year == _selectedMonth.year)
  //       .map((item) => item.amount),
  // );

  // double get _todayIncome {
  //   final now = DateTime.now();
  //   return _sum(
  //     _payments
  //         .where((item) => _sameDay(item.paidAt, now))
  //         .map((e) => e.amount),
  //   );
  // }

  List<ChartPoint> get _chartPoints {
    return _selectedPeriod == TrendPeriod.thirtyDays
        ? _dailyPoints()
        : _monthlyPoints();
  }

  DateTime? get _earliestMonth {
    final months = _availableMonths;
    return months.isEmpty ? null : months.first;
  }

  DateTime? get _latestMonth {
    final months = _availableMonths;
    return months.isEmpty ? null : months.last;
  }

  List<DateTime> get _availableMonths {
    final dates = [
      ..._payments.map((item) => item.paidAt),
      ..._expenses.map((item) => item.expenseDate),
    ]..sort();

    return dates.map((date) => DateTime(date.year, date.month)).toList();
  }

  bool get _canGoPrevious {
    final earliest = _earliestMonth;
    return earliest != null &&
        _monthNumber(_selectedMonth) > _monthNumber(earliest);
  }

  bool get _canGoNext {
    final latest = _latestMonth;
    return latest != null &&
        _monthNumber(_selectedMonth) < _monthNumber(latest);
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.scale;
    final revenue = ref.watch(revenueProvider);

    final summary = revenue.summary;
    final recentPayment = revenue.recentPayments;
    //print(recentPayment?[0].paymentDate);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'Add Expense',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        bottom: false,
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
                  isLoading: _isloading,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
              sliver: SliverToBoxAdapter(
                child: MonthlySummaryCard(
                  selectedMonth: _selectedMonth,
                  revenue: _monthlyRevenue,
                  expenses: _monthlyExpense,
                  profit: _monthlyProfit,
                  expenseItems: _selectedExpenses,
                  canGoPrevious: _canGoPrevious,
                  canGoNext: _canGoNext,
                  onPreviousMonth: () => _changeMonth(-1),
                  onNextMonth: () => _changeMonth(1),
                  onExpenseTap: (_) {},
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
              sliver: SliverToBoxAdapter(
                child: EarningsTrendCard(
                  points: _chartPoints,
                  period: _selectedPeriod,
                  onPeriodChanged: (period) {
                    setState(() => _selectedPeriod = period);
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 34, 22, 110),
              sliver: SliverToBoxAdapter(
                child: RecentPaymentsSection(
                  payments: recentPayment,
                  isloading: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ChartPoint> _dailyPoints() {
    final days = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final totals = List<double>.filled(days, 0);

    for (final payment in _payments.where(
      (item) => _sameMonth(item.paidAt, _selectedMonth),
    )) {
      totals[payment.paidAt.day - 1] += payment.amount;
    }

    return List.generate(days, (index) {
      final day = index + 1;
      return ChartPoint(
        x: index.toDouble(),
        y: totals[index],
        label: '$day ${DateFormatter.shortMonth(_selectedMonth.month)}',
        valueLabel: CurrencyFormatter.format(totals[index]),
      );
    });
  }

  List<ChartPoint> _monthlyPoints() {
    final totals = List<double>.filled(12, 0);

    for (final payment in _payments.where(
      (item) => item.paidAt.year == _selectedMonth.year,
    )) {
      totals[payment.paidAt.month - 1] += payment.amount;
    }

    return List.generate(12, (index) {
      return ChartPoint(
        x: index.toDouble(),
        y: totals[index],
        label: DateFormatter.shortMonth(index + 1),
        valueLabel: CurrencyFormatter.format(totals[index]),
      );
    });
  }

  static bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
  // static bool _sameDay(DateTime a, DateTime b) =>
  //     _sameMonth(a, b) && a.day == b.day;
  static int _monthNumber(DateTime date) => date.year * 12 + date.month;
  static double _sum(Iterable<double> values) =>
      values.fold(0, (total, item) => total + item);
}
