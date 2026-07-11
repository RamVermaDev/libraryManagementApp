import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/expense_item.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/expense_style.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense, required this.onDelete});

  final ExpenseItem expense;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final style = ExpenseCategoryStyle.from(expense.category);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Category Icon
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(style.icon, color: style.color, size: 24),
          ),

          const SizedBox(width: 18),

          // Expense Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "${ExpenseFormatter.category(expense.category)} • ${DateFormatter.shortDate(expense.expenseDate)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),

          const SizedBox(width: 4),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close, size: 16, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
