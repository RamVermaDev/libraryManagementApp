import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/app_colors.dart';

class EndStudentDateField extends StatefulWidget {
  const EndStudentDateField({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
    this.height = 52,
    this.borderRadius = 12,
    required this.startDate,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final double height;
  final double borderRadius;
  final DateTime startDate;

  @override
  State<EndStudentDateField> createState() => _EndStudentDateFieldState();
}

class _EndStudentDateFieldState extends State<EndStudentDateField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(covariant EndStudentDateField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialDate != widget.initialDate) {
      setState(() {
        _selectedDate = widget.initialDate;
      });
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.startDate,
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
