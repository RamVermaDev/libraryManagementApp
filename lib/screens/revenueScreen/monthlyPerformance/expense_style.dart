import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ExpenseCategoryStyle {
  const ExpenseCategoryStyle({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  factory ExpenseCategoryStyle.from(String category) {
    switch (category) {
      case 'Rent':
        return const ExpenseCategoryStyle(
          icon: Icons.home_work_outlined,
          color: Color(0xFF7A55B7),
          background: Color(0xFFF3EDFF),
        );
      case 'Electricity':
        return const ExpenseCategoryStyle(
          icon: Icons.bolt_rounded,
          color: Color(0xFFC27816),
          background: Color(0xFFFFF4DC),
        );
      case 'Internet':
        return const ExpenseCategoryStyle(
          icon: Icons.receipt_long_outlined,
          color: Color(0xFFDC2626),
          background: Color(0xFFFFE8E8),
        );
      case 'Salary':
        return const ExpenseCategoryStyle(
          icon: Icons.badge_outlined,
          color: Color(0xFF059669),
          background: Color(0xFFE8F8F1),
        );
      case 'Maintenance':
        return const ExpenseCategoryStyle(
          icon: Icons.build_outlined,
          color: Color(0xFFBD5D32),
          background: Color(0xFFFFEEE7),
        );
      case 'Marketing':
        return const ExpenseCategoryStyle(
          icon: Icons.shop,
          color: Color(0xFF3D7D8B),
          background: Color(0xFFEAF6F8),
        );
      case 'Other':
        return const ExpenseCategoryStyle(
          icon: Icons.receipt_long_outlined,
          color: AppColors.body,
          background: Color(0xFFF1F3F6),
        );

      default:
        return const ExpenseCategoryStyle(
          icon: Icons.receipt_long_outlined,
          color: AppColors.body,
          background: Color(0xFFF1F3F6),
        );
    }
  }
}

// class ExpenseFormatter {
//   static String category(ExpenseCategory category) {
//     switch (category) {
//       case ExpenseCategory.rent:
//         return 'Rent';
//       case ExpenseCategory.electricity:
//         return 'Electricity';
//       case ExpenseCategory.internet:
//         return 'Internet';
//       case ExpenseCategory.salary:
//         return 'Salary';
//       case ExpenseCategory.maintenance:
//         return 'Maintenance';
//       case ExpenseCategory.cleaning:
//         return 'Cleaning';
//       case ExpenseCategory.other:
//         return 'Other';
//     }
//   }
// }
