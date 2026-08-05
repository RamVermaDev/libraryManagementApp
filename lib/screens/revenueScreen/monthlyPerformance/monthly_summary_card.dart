import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/expense_model.dart';
import 'package:library_management/models/payemnt_model.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/expense_section.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/month_selector.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/monthly_metrics.dart';
import 'package:library_management/screens/revenueScreen/revenue_card_decoration.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';
import 'package:library_management/screens/revenueScreen/section_header.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    super.key,
    required this.selectedMonth,
    required this.revenue,
    required this.expenses,
    required this.expenseItems,
    this.refundItems,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.scale,
    this.isReceptionist = false,
  });

  final double scale;
  final bool isReceptionist;

  final DateTime selectedMonth;
  final double? revenue;
  final double? expenses;

  final List<ExpenseModel>? expenseItems;
  final List<PaymentModel>? refundItems;

  final bool canGoPrevious;
  final bool canGoNext;

  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final hasExpenses = expenseItems != null && expenseItems!.isNotEmpty;
    final hasRefunds = refundItems != null && refundItems!.isNotEmpty;

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
                  title: isReceptionist ? 'Monthly Expenses' : 'Monthly Profit',
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

          if (!isReceptionist) ...[
            const SizedBox(height: 20),
            MonthlyMetrics(revenue: revenue, expenses: expenses, scale: scale),
          ],

          if (hasExpenses) ...[
            SizedBox(height: 20 * scale),
            Divider(height: 1 * scale, color: const Color(0xFFE8EBF1)),
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
          ],

          if (hasRefunds) ...[
            SizedBox(height: 20 * scale),
            Divider(height: 1 * scale, color: const Color(0xFFE8EBF1)),
            SizedBox(height: 18 * scale),

            SectionHeader(
              title: 'Refunds',
              fontSize: 14 * scale,
              weight: FontWeight.w600,
              scale: scale,
            ),

            SizedBox(height: 8 * scale),

            Column(
              children: refundItems!.map((refund) {
                final titleText = '${refund.paymentMode} (Refund)';
                final subtitleText =
                    DateFormatter.shortDate(refund.paymentDate);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 35 * scale,
                        height: 35 * scale,
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.undo_rounded,
                          color: AppColors.error,
                          size: 20 * scale,
                        ),
                      ),
                      SizedBox(width: 18 * scale),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titleText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                              ),
                            ),
                            SizedBox(height: 2 * scale),
                            Text(
                              subtitleText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10 * scale,
                                fontWeight: FontWeight.w500,
                                color: AppColors.body,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '- ${CurrencyFormatter.format(refund.amount)}',
                        style: TextStyle(
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}



