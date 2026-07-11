class ExpenseItem {
  const ExpenseItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.expenseDate,
  });

  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime expenseDate;
}

enum ExpenseCategory {
  rent,
  electricity,
  internet,
  salary,
  maintenance,
  cleaning,
  other,
}
