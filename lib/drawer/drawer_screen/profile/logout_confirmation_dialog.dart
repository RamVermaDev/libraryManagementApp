import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/authScreens/login_screen.dart';
import 'package:library_management/local_storage.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/expense_provider.dart';
import 'package:library_management/provider/library_provider.dart';
import 'package:library_management/provider/payment_provider.dart';
import 'package:library_management/provider/revenue_provider.dart';
import 'package:library_management/provider/student_provider.dart';
import 'package:library_management/provider/student_summary_provider.dart';
import 'package:library_management/provider/task_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/provider/user_provider.dart';

Future<void> showLogoutConfirmationDialog({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );

  if (shouldLogout != true || !context.mounted) return;

  await LocalStorage.clearLogin();
  ref.read(currentLibraryProvider.notifier).clear();
  ref.read(studentProvider.notifier).clearStudents();
  ref.read(studentSummaryProvider.notifier).clearSummary();
  ref.read(taskProvider.notifier).clearTasks();
  ref.read(revenueProvider.notifier).clear();
  ref.read(paymentProvider.notifier).clearPayments();
  ref.read(expenseProvider.notifier).clearExpenses();
  ref.read(libraryProvider.notifier).clearLibraries();
  ref.read(userProvider.notifier).clearUser();
  ref.read(tokenProvider.notifier).clearToken();

  if (!context.mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}
