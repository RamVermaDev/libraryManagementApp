import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/app_colors.dart';

class StartStudentDateField extends StatefulWidget {
  const StartStudentDateField({
    super.key,
    this.initialDate,
    required this.onDateChanged,
    this.height = 52,
    this.borderRadius = 12,
  });

  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final double height;
  final double borderRadius;

  @override
  State<StartStudentDateField> createState() => _StartStudentDateFieldState();
}

class _StartStudentDateFieldState extends State<StartStudentDateField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });

      widget.onDateChanged.call(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickDate,
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                DateFormat("dd/MM/yyyy").format(_selectedDate),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B4B4B),
                ),
              ),
            ),

            Icon(
              Icons.calendar_month_rounded,
              size: 20,
              color: AppColors.iconMuted,
            ),
          ],
        ),
      ),
    );
  }
}
