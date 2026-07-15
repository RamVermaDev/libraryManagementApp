import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/expense_controller.dart';
import 'package:library_management/models/expense_model.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/expense_style.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class ExpenseTile extends ConsumerWidget {
  const ExpenseTile({super.key, required this.expense, required this.scale});

  final ExpenseModel expense;
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ExpenseCategoryStyle.from(expense.category);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Category Icon
          Container(
            width: 35 * scale,
            height: 35 * scale,
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(style.icon, color: style.color, size: 24 * scale),
          ),

          SizedBox(width: 18 * scale),

          // Expense Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
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
                  "${expense.category} • ${DateFormatter.shortDate(expense.expenseDate)}",
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

          // Amount
          Text(
            CurrencyFormatter.format(expense.amount),
            style: TextStyle(
              fontSize: 14 * scale,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),

          SizedBox(width: 4 * scale),
          InkWell(
            onTap: () async {
              print('happen');
              ExpenseController().deleteExpense(
                context: context,
                ref: ref,
                expenseId: expense.id!,
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.close,
                size: 16 * scale,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
