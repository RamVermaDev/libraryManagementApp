import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/expense_item.dart';

class ExpenseCategoryStyle {
  const ExpenseCategoryStyle({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  factory ExpenseCategoryStyle.from(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.rent:
        return const ExpenseCategoryStyle(
          icon: Icons.home_work_outlined,
          color: Color(0xFF7A55B7),
          background: Color(0xFFF3EDFF),
        );
      case ExpenseCategory.electricity:
        return const ExpenseCategoryStyle(
          icon: Icons.bolt_rounded,
          color: Color(0xFFC27816),
          background: Color(0xFFFFF4DC),
        );
      case ExpenseCategory.internet:
        return const ExpenseCategoryStyle(
          icon: Icons.receipt_long_outlined,
          color: Color(0xFFDC2626),
          background: Color(0xFFFFE8E8),
        );
      case ExpenseCategory.salary:
        return const ExpenseCategoryStyle(
          icon: Icons.badge_outlined,
          color: Color(0xFF059669),
          background: Color(0xFFE8F8F1),
        );
      case ExpenseCategory.maintenance:
        return const ExpenseCategoryStyle(
          icon: Icons.build_outlined,
          color: Color(0xFFBD5D32),
          background: Color(0xFFFFEEE7),
        );
      case ExpenseCategory.cleaning:
        return const ExpenseCategoryStyle(
          icon: Icons.cleaning_services_outlined,
          color: Color(0xFF3D7D8B),
          background: Color(0xFFEAF6F8),
        );
      case ExpenseCategory.other:
        return const ExpenseCategoryStyle(
          icon: Icons.receipt_long_outlined,
          color: AppColors.body,
          background: Color(0xFFF1F3F6),
        );
    }
  }
}

class ExpenseFormatter {
  static String category(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.rent:
        return 'Rent';
      case ExpenseCategory.electricity:
        return 'Electricity';
      case ExpenseCategory.internet:
        return 'Internet';
      case ExpenseCategory.salary:
        return 'Salary';
      case ExpenseCategory.maintenance:
        return 'Maintenance';
      case ExpenseCategory.cleaning:
        return 'Cleaning';
      case ExpenseCategory.other:
        return 'Other';
    }
  }
}
