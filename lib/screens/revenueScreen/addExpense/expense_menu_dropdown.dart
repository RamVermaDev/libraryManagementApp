import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ExpenseMenuDropdown extends StatelessWidget {
  const ExpenseMenuDropdown({
    super.key,
    required this.onChange,
    required this.selectedCategory,
  });

  final ValueChanged<String> onChange;
  final String? selectedCategory;

  static final List<String> expenseCategories = [
    'Salary',
    'Rent',
    'Electricity',
    'Internet',
    'Maintenance',
    'Marketing',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChange,
      position: PopupMenuPosition.under,
      elevation: 3,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => expenseCategories
          .map(
            (category) => PopupMenuItem<String>(
              height: 36,
              value: category,
              child: Row(
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),

      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedCategory ?? "Select",
                  style: selectedCategory == null
                      ? TextStyle(fontSize: 14, color: Color(0xFF667085))
                      : TextStyle(fontSize: 14),
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: Color(0xFF667085)),
            ],
          ),
        ),
      ),
    );
  }
}
