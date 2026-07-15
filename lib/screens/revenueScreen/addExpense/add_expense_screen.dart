import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/expense_controller.dart';
import 'package:library_management/screens/revenueScreen/addExpense/expense_menu_dropdown.dart';
import 'package:library_management/screens/revenueScreen/addExpense/top_snack_bar.dart';
import 'package:library_management/screens/revenueScreen/section_header.dart';
import 'package:library_management/screens/taskScreen/field/date_field.dart';
import 'package:library_management/screens/taskScreen/field/task_text_field.dart';
import 'package:library_management/screens/taskScreen/field/title_text.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _expenseController = ExpenseController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate = DateTime.now();

  String? _selectedCategory;
  bool _isLoading = false;

  Future<void> _addExpense() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      TopSnackBar.show(context, message: 'Please select a category');
      return;
    }

    if (_selectedDate == null) {
      TopSnackBar.show(context, message: 'Please select a date');
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      TopSnackBar.show(context, message: 'Please enter a valid amount');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _expenseController.addExpense(
        context: context,
        ref: ref,
        libraryId: '6a422593f2ed24f734e41864',
        title: _titleController.text.trim(),
        amount: amount,
        category: _selectedCategory!,
        expenseDate: _selectedDate!,
        description: _descriptionController.text.trim(),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.scale;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity, // Full width
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(top: 2, bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SectionHeader(
                          title: 'Add Expense',
                          fontSize: 15 * scale,
                          weight: FontWeight.w700,
                          scale: scale,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Track your business expenses',
                          style: TextStyle(
                            color: AppColors.body,
                            fontSize: 12 * scale,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close_outlined, size: 18),
                  ),
                ],
              ),

              SizedBox(height: 30),

              _AddForm(
                titleController: _titleController,
                descriptionController: _descriptionController,
                amountController: _amountController,
                date: _selectedDate,
                selectedCategory: _selectedCategory,
                isLoading: _isLoading,
                onDateChanged: (value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
                onCategoryChange: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                onSubmit: _addExpense,
                //  () {
                //   print(_selectedDate);
                //   print(_amountController.text);
                //   print(_descriptionController.text);
                //   print(_titleController.text);
                // },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddForm extends StatelessWidget {
  const _AddForm({
    required this.titleController,
    required this.descriptionController,
    required this.onDateChanged,
    required this.amountController,
    required this.date,
    required this.onSubmit,
    required this.selectedCategory,
    required this.onCategoryChange,
    required this.isLoading,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final DateTime? date;
  final String? selectedCategory;
  final bool isLoading;

  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onSubmit;
  final ValueChanged<String?> onCategoryChange;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const TitleText(
          title: 'Expense Title',
          fontSize: 12,
          weight: FontWeight.w400,
          fontColor: AppColors.formLabel,
        ),
        const SizedBox(height: 8),
        TaskTextField(
          hintText: 'e.g. Employee Salary',
          controller: titleController,
          fillColor: AppColors.background,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          maxLength: 50,
          validator: (p0) {
            return null;
          },
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleText(
                    title: 'Amount',
                    fontSize: 12,
                    weight: FontWeight.w400,
                    fontColor: AppColors.formLabel,
                  ),
                  const SizedBox(height: 8),
                  TaskTextField(
                    hintText: '0',
                    controller: amountController,
                    fillColor: AppColors.background,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (p0) {
                      return null;
                    },
                  ),
                ],
              ),
            ),

            SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleText(
                    title: 'Category',
                    fontSize: 12,
                    weight: FontWeight.w400,
                    fontColor: AppColors.formLabel,
                  ),
                  const SizedBox(height: 8),
                  ExpenseMenuDropdown(
                    onChange: onCategoryChange,
                    selectedCategory: selectedCategory,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        const TitleText(
          title: 'Date',
          fontSize: 12,
          weight: FontWeight.w400,
          fontColor: AppColors.formLabel,
        ),
        const SizedBox(height: 8),
        DateField(
          onDateChanged: onDateChanged,
          selectedDate: date,
          hight: 48,
          color: AppColors.background,
        ),

        const SizedBox(height: 20),

        const TitleText(
          title: 'Description (Optional)',
          fontSize: 12,
          weight: FontWeight.w400,
          fontColor: AppColors.formLabel,
        ),
        const SizedBox(height: 8),
        TaskTextField(
          hintText: 'e.g. Employee Salary',
          controller: descriptionController,
          fillColor: AppColors.background,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          minLines: 2,
          maxLines: 4,
          maxLength: 200,
          validator: (p0) {
            return null;
          },
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: isLoading ? () {} : onSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? SpinKitThreeBounce(color: Colors.white, size: 12)
                : const Text(
                    'Add Expense',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
