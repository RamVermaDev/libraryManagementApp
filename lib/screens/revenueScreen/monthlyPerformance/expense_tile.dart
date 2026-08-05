import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/controllers/expense_controller.dart';
import 'package:library_management/models/expense_model.dart';
import 'package:library_management/provider/app_mode_provider.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/expense_style.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class ExpenseTile extends ConsumerWidget {
  const ExpenseTile({super.key, required this.expense, required this.scale});

  final ExpenseModel expense;
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMode = ref.watch(appModeProvider);
    final isReceptionistExpense = expense.addedBy.toLowerCase() == 'reception';

    final canDelete = isReceptionistExpense
        ? activeMode == AppMode.reception
        : activeMode == AppMode.admin;

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
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: expense.title,
                        style: TextStyle(
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),

                      if (isReceptionistExpense) ...[
                        TextSpan(
                          text: ' (Reception)',
                          style: TextStyle(
                            fontSize: 11 * scale,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
            onTap: () {
              if (!canDelete) {
                AppNotification.show(
                  context,
                  message: isReceptionistExpense
                      ? 'Can be deleted through Reception mode'
                      : 'Can be deleted through Admin mode',
                  showIcon: false,
                );
                return;
              }

              ExpenseController().deleteExpense(
                context: context,
                ref: ref,
                expenseId: expense.id!,
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.close,
                size: 16 * scale,
                color: canDelete ? AppColors.error : AppColors.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
