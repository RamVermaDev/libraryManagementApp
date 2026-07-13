import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/revenue_dashboard_model.dart';
import 'package:library_management/provider/revenue_state.dart';

final revenueProvider = StateNotifierProvider<RevenueNotifier, RevenueState>(
  (ref) => RevenueNotifier(),
);

class RevenueNotifier extends StateNotifier<RevenueState> {
  RevenueNotifier() : super(const RevenueState());

  // ---------------- Dashboard ----------------

  void setDashboard(RevenueDashboardModel dashboard) {
    //final now = DateTime.now();

    // final key =
    //     '${now.year}-${now.month.toString().padLeft(2, '0')}';

    state = state.copyWith(
      summary: dashboard.summary,
      recentPayments: dashboard.recentPayments,
      // thirtyDayTrend: dashboard.thirtyDayTrend,
      // twelveMonthTrend: dashboard.twelveMonthTrend,
      // selectedMonthKey: key,
      // monthCache: {
      //   key: dashboard.monthData,
      // },
    );
  }

  // ---------------- Month ----------------

  // void setMonth({
  //   required int month,
  //   required int year,
  //   required MonthlyRevenueModel data,
  // }) {
  //   final key =
  //       '$year-${month.toString().padLeft(2, '0')}';

  //   final cache = Map<String, MonthlyRevenueModel>.from(
  //     state.monthCache,
  //   );

  //   cache[key] = data;

  //   state = state.copyWith(
  //     selectedMonthKey: key,
  //     monthCache: cache,
  //   );
  // }

  // bool hasMonth({
  //   required int month,
  //   required int year,
  // }) {
  //   final key =
  //       '$year-${month.toString().padLeft(2, '0')}';

  //   return state.monthCache.containsKey(key);
  // }

  // MonthlyRevenueModel? getMonth({
  //   required int month,
  //   required int year,
  // }) {
  //   final key =
  //       '$year-${month.toString().padLeft(2, '0')}';

  //   return state.monthCache[key];
  // }

  // ---------------- Expense ----------------

  // void addExpense(ExpenseModel expense) {
  //   final key = state.selectedMonthKey;

  //   if (key == null) return;

  //   final month = state.monthCache[key];

  //   if (month == null) return;

  //   final updated = month.copyWith(
  //     expense: month.expense + expense.amount,
  //     expenses: [
  //       expense,
  //       ...month.expenses,
  //     ],
  //   );

  //   final cache = Map<String, MonthlyRevenueModel>.from(
  //     state.monthCache,
  //   );

  //   cache[key] = updated;

  //   state = state.copyWith(
  //     monthCache: cache,
  //   );
  // }

  // void deleteExpense(String expenseId) {
  //   final key = state.selectedMonthKey;

  //   if (key == null) return;

  //   final month = state.monthCache[key];

  //   if (month == null) return;

  //   final expense = month.expenses.firstWhere(
  //     (e) => e.id == expenseId,
  //   );

  //   final updated = month.copyWith(
  //     expense: month.expense - expense.amount,
  //     expenses: month.expenses
  //         .where((e) => e.id != expenseId)
  //         .toList(),
  //   );

  //   final cache = Map<String, MonthlyRevenueModel>.from(
  //     state.monthCache,
  //   );

  //   cache[key] = updated;

  //   state = state.copyWith(
  //     monthCache: cache,
  //   );
  // }

  // ---------------- Payment ----------------

  // void addPayment(PaymentModel payment) {
  //   if (state.summary == null) return;

  //   final summary = state.summary!.copyWith(
  //     todayIncome:
  //         state.summary!.todayIncome + payment.amount,
  //     monthlyIncome:
  //         state.summary!.monthlyIncome + payment.amount,
  //     yearlyIncome:
  //         state.summary!.yearlyIncome + payment.amount,
  //     allTimeIncome:
  //         state.summary!.allTimeIncome + payment.amount,
  //   );

  //   state = state.copyWith(
  //     summary: summary,
  //     recentPayments: [
  //       payment,
  //       ...state.recentPayments,
  //     ].take(7).toList(),
  //   );
  // }

  // // ---------------- Chart ----------------

  // void setThirtyDayTrend(
  //   List<ChartPointModel> trend,
  // ) {
  //   state = state.copyWith(
  //     thirtyDayTrend: trend,
  //   );
  // }

  // void setTwelveMonthTrend(
  //   List<ChartPointModel> trend,
  // ) {
  //   state = state.copyWith(
  //     twelveMonthTrend: trend,
  //   );
  // }

  // ---------------- Loading ----------------

  // void setLoading(bool value) {
  //   state = state.copyWith(
  //     isLoading: value,
  //   );
  // }

  // ---------------- Clear ----------------

  // void clear() {
  //   state = const RevenueState();
  // }
}
