import 'package:flutter/material.dart';
import 'package:library_management/screens/revenueScreen/expense_item.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/expense_tile.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/month_selector.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/monthly_metrics.dart';
import 'package:library_management/screens/revenueScreen/revenue_card_decoration.dart';
import 'package:library_management/screens/revenueScreen/section_header.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    super.key,
    required this.selectedMonth,
    required this.revenue,
    required this.expenses,
    required this.profit,
    required this.expenseItems,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onExpenseTap,
  });

  final DateTime selectedMonth;
  final double revenue;
  final double expenses;
  final double profit;

  final List<ExpenseItem> expenseItems;

  final bool canGoPrevious;
  final bool canGoNext;

  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  final ValueChanged<ExpenseItem> onExpenseTap;

  bool get hasExpense => expenses > 0 && expenseItems.isNotEmpty;

  ExpenseItem? get topExpense {
    if (expenseItems.isEmpty) return null;

    final list = [...expenseItems];
    list.sort((a, b) => b.amount.compareTo(a.amount));

    return list.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
      decoration: AppCardDecoration.standard(),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: SectionHeader(title: 'Monthly Profit', fontSize: 18),
              ),
              MonthSelector(
                selectedMonth: selectedMonth,
                canGoPrevious: canGoPrevious,
                canGoNext: canGoNext,
                onPrevious: onPreviousMonth,
                onNext: onNextMonth,
              ),
            ],
          ),

          const SizedBox(height: 20),

          MonthlyMetrics(revenue: revenue, expenses: expenses, profit: profit),

          if (hasExpense) ...[
            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFFE8EBF1)),
            const SizedBox(height: 18),

            const SectionHeader(
              title: 'Expenses',
              fontSize: 14,
              weight: FontWeight.w600,
            ),

            const SizedBox(height: 8),

            ExpenseTile(expense: topExpense!, onDelete: () {}),
          ],
        ],
      ),
    );
  }
}
