import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/expense_model.dart';

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, List<ExpenseModel>>((ref) {
      return ExpenseNotifier();
    });

class ExpenseNotifier extends StateNotifier<List<ExpenseModel>> {
  ExpenseNotifier() : super([]);

  // Set all expenses after fetching from backend
  void setExpenses(List<ExpenseModel> expenses) {
    state = expenses;
  }

  // Add one newly created expense
  void addExpense(ExpenseModel expense) {
    state = [expense, ...state];
  }

  // Update one expense
  void updateExpense(ExpenseModel updatedExpense) {
    state = [
      for (final expense in state)
        if (expense.id == updatedExpense.id) updatedExpense else expense,
    ];
  }

  // Delete one expense
  void deleteExpense(String expenseId) {
    state = state.where((expense) => expense.id != expenseId).toList();
  }

  // Clear all expenses
  void clearExpenses() {
    state = [];
  }
}
