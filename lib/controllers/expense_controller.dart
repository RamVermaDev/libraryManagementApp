import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/expense_model.dart';
import 'package:library_management/provider/expense_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class ExpenseController {
  Future<void> addExpense({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required String title,
    required double amount,
    required String category,
    required DateTime expenseDate,
    String description = '',
  }) async {
    try {
      final expenseModel = ExpenseModel(
        libraryId: libraryId,
        title: title,
        amount: amount,
        category: category,
        expenseDate: expenseDate,
        description: description,
      );

      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final response = await http.post(
        Uri.parse('$uri/api/addexpense'),
        body: expenseModel.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);

          final newExpense = ExpenseModel.fromMap(
            data['expense'] as Map<String, dynamic>,
          );

          ref.read(expenseProvider.notifier).addExpense(newExpense);

          Navigator.pop(context);

          AppNotification.show(context, message: 'Expense added successfully');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Add Expense Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to add expense');
      }
    }
  }
}
