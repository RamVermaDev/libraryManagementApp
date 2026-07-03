import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndStudentDateField extends StatefulWidget {
  const EndStudentDateField({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
    this.height = 52,
    this.borderRadius = 4,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final double height;
  final double borderRadius;

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
    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
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

          IconButton(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month_rounded, size: 30),
          ),
        ],
      ),
    );
  }
}
