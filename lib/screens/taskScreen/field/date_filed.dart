import 'package:flutter/material.dart';

class DateFiled extends StatefulWidget {
  const DateFiled({super.key, required this.onDateChanged});

  final ValueChanged<DateTime?> onDateChanged;

  @override
  State<DateFiled> createState() => _DateFiledState();
}

class _DateFiledState extends State<DateFiled> {
  DateTime? _selectedDate;

  String get _formattedDate {
    if (_selectedDate == null) {
      return 'Select date';
    }

    final date = _selectedDate!;

    return '${date.day}-${date.month}-${date.year}';
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (selectedDate == null) return;

    setState(() {
      _selectedDate = selectedDate;
    });

    widget.onDateChanged.call(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 19,
              color: Color(0xFF667085),
            ),

            const SizedBox(width: 12),

            Text(
              _formattedDate,
              style: TextStyle(
                fontSize: 15,
                color: _selectedDate == null
                    ? const Color(0xFF98A2B3)
                    : const Color(0xFF0B1F44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
