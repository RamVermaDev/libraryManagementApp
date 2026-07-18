import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/expense_model.dart';
import 'package:library_management/models/monthly_revenue_model.dart';
import 'package:library_management/models/payemnt_model.dart';
import 'package:library_management/models/revenue_dashboard_model.dart';
import 'package:library_management/provider/revenue_state.dart';

final revenueProvider = StateNotifierProvider<RevenueNotifier, RevenueState>(
  (ref) => RevenueNotifier(),
);

class RevenueNotifier extends StateNotifier<RevenueState> {
  RevenueNotifier() : super(const RevenueState());

  // ---------------- Dashboard ----------------

  void setDashboard(RevenueDashboardModel dashboard) {
    final now = DateTime.now();

    final key = _monthKey(now.year, now.month);

    //'${now.year}-${now.month.toString().padLeft(2, '0')}';

    state = state.copyWith(
      summary: dashboard.summary,
      currentMonth: dashboard.monthSummary,
      monthCache: {key: dashboard.monthSummary},
      recentPayments: dashboard.recentPayments,
      thirtyDayTrend: dashboard.trend30Days,
      twelveMonthTrend: dashboard.trend12Months,
    );
  }

  // ---------------- Month ----------------

  void setMonth({
    required int year,
    required int month,
    required MonthlyRevenueModel data,
  }) {
    final key = _monthKey(year, month);

    final cache = Map<String, MonthlyRevenueModel>.from(state.monthCache ?? {});

    cache[key] = data;

    state = state.copyWith(currentMonth: data, monthCache: cache);
  }

  void setCurrentMonth({required int year, required int month}) {
    final key = _monthKey(year, month);

    final data = state.monthCache?[key];

    if (data == null) return;

    state = state.copyWith(currentMonth: data);
  }

  bool hasMonth({required int year, required int month}) {
    final key = _monthKey(year, month);

    return state.monthCache?.containsKey(key) ?? false;
  }

  // ---------------- Expense ----------------

  void addExpense(ExpenseModel expense) {
    final key =
        '${expense.expenseDate.year}-${expense.expenseDate.month.toString().padLeft(2, '0')}';

    final month = state.monthCache?[key];

    // Month not cached yet → do nothing.
    if (month == null) return;

    final updatedMonth = month.copyWith(
      expense: month.expense + expense.amount,
      expenses: [expense, ...month.expenses],
    );

    final cache = Map<String, MonthlyRevenueModel>.from(state.monthCache ?? {});
    cache[key] = updatedMonth;

    state = state.copyWith(
      monthCache: cache,
      currentMonth: state.currentMonth == month
          ? updatedMonth
          : state.currentMonth,
    );
  }

  void deleteExpense(String expenseId) {
    final currentMonth = state.currentMonth;
    if (currentMonth == null) return;

    final expense = currentMonth.expenses.firstWhere((e) => e.id == expenseId);

    final updatedMonth = currentMonth.copyWith(
      expense: currentMonth.expense - expense.amount,
      expenses: currentMonth.expenses.where((e) => e.id != expenseId).toList(),
    );

    final cache = Map<String, MonthlyRevenueModel>.from(state.monthCache ?? {});

    // Replace the matching month in the cache
    cache.updateAll((key, value) {
      if (value == currentMonth) {
        return updatedMonth;
      }
      return value;
    });

    state = state.copyWith(currentMonth: updatedMonth, monthCache: cache);
  }

  // ---------------- Payment ----------------

  void addPayment(PaymentModel payment) {
    if (state.summary == null) return;

    final summary = state.summary!.copyWith(
      todayIncome: state.summary!.todayIncome + payment.amount,
      monthlyIncome: state.summary!.monthlyIncome + payment.amount,
      yearlyIncome: state.summary!.yearlyIncome + payment.amount,
      allTimeIncome: state.summary!.allTimeIncome + payment.amount,
    );

    state = state.copyWith(
      summary: summary,
      recentPayments: [payment, ...state.recentPayments!].toList(),
      currentMonth: state.currentMonth!.copyWith(
        income: state.currentMonth!.income + payment.amount,
      ),
    );
  }

  // ---------------- Loading ----------------

  // void setLoading(bool value) {
  //   state = state.copyWith(
  //     isLoading: value,
  //   );
  // }

  // ---------------- Clear ----------------

  void clear() {
    state = const RevenueState();
  }

  String _monthKey(int year, int month) {
    return '$year-${month.toString().padLeft(2, '0')}';
  }
}
