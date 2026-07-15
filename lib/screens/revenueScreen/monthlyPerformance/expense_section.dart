import 'package:flutter/material.dart';
import 'package:library_management/models/expense_model.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/expense_tile.dart';

class ExpenseSection extends StatelessWidget {
  const ExpenseSection({
    super.key,
    required this.expenseList,
    required this.scale,
    required this.onDelete,
  });

  final List<ExpenseModel> expenseList;
  final double scale;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: expenseList.length,
      separatorBuilder: (_, __) => Divider(
        height: 1 * scale,
        thickness: 1 * scale,
        color: Color(0xFFF1F3F5),
      ),
      itemBuilder: (_, index) {
        return ExpenseTile(
          expense: expenseList[index],
          scale: scale,
        );
      },
    );
  }
}
