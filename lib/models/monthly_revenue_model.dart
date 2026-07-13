import 'dart:convert';

import 'package:library_management/models/expense_model.dart';

class MonthlyRevenueModel {
  final double income;
  final double expense;

  final List<ExpenseModel> expenses;

  const MonthlyRevenueModel({
    required this.income,
    required this.expense,
    required this.expenses,
  });

  MonthlyRevenueModel copyWith({
    double? income,
    double? expense,
    double? profit,
    List<ExpenseModel>? expenses,
  }) {
    return MonthlyRevenueModel(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      expenses: expenses ?? this.expenses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'income': income,
      'expense': expense,
      'expenses': expenses.map((e) => e.toMap()).toList(),
    };
  }

  factory MonthlyRevenueModel.fromMap(Map<String, dynamic> map) {
    return MonthlyRevenueModel(
      income: (map['income'] ?? 0).toDouble(),
      expense: (map['expense'] ?? 0).toDouble(),
      expenses: (map['expenses'] as List<dynamic>? ?? [])
          .map((e) => ExpenseModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory MonthlyRevenueModel.fromJson(String source) =>
      MonthlyRevenueModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MonthlyRevenueModel(income: $income, expense: $expense, expenses: ${expenses.length})';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MonthlyRevenueModel &&
            income == other.income &&
            expense == other.expense &&
            expenses == other.expenses;
  }

  @override
  int get hashCode {
    return Object.hash(income, expense, expenses);
  }
}
