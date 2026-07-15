import 'package:flutter/material.dart';
import 'package:library_management/models/expense_model.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/expense_section.dart';
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
    required this.expenseItems,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.scale,
  });

  final double scale;

  final DateTime selectedMonth;
  final double? revenue;
  final double? expenses;

  final List<ExpenseModel>? expenseItems;

  final bool canGoPrevious;
  final bool canGoNext;

  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;


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
              Expanded(
                child: SectionHeader(
                  title: 'Monthly Profit',
                  fontSize: 18 * scale,
                  scale: scale,
                ),
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

          MonthlyMetrics(revenue: revenue, expenses: expenses, scale: scale),

          if (expenseItems != null && expenseItems!.isNotEmpty) ...[
            SizedBox(height: 20 * scale),
            Divider(height: 1 * scale, color: Color(0xFFE8EBF1)),
            SizedBox(height: 18 * scale),

            SectionHeader(
              title: 'Expenses',
              fontSize: 14 * scale,
              weight: FontWeight.w600,
              scale: scale,
            ),

            SizedBox(height: 8 * scale),

            ExpenseSection(
              expenseList: expenseItems!,
              scale: scale,
              onDelete: () {},
            ),

            // ExpenseTile(
            //   expense: expenseItems![0],
            //   scale: scale,
            //   onDelete: () {},
            // ),
          ],
        ],
      ),
    );
  }
}
