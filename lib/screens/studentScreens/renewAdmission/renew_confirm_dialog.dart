import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/student_model.dart';

class RenewConfirmDialog extends StatelessWidget {
  const RenewConfirmDialog({
    super.key,
    required this.member,
    required this.slotDisplay,
    required this.seatDisplay,
    required this.planDays,
    required this.startDate,
    required this.expireDate,
    required this.amountText,
    this.discountText,
    this.paidAmountText,
    this.pendingText,
  });

  final StudentModel member;
  final String slotDisplay;
  final String seatDisplay;
  final int planDays;
  final DateTime startDate;
  final DateTime expireDate;
  final String amountText;
  final String? discountText;
  final String? paidAmountText;
  final String? pendingText;

  static String _formatDateRange(DateTime start, DateTime expire) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];
    final startStr =
        '${start.day} ${months[start.month - 1]} ${start.year.toString().substring(2)}';
    final expireStr =
        '${expire.day} ${months[expire.month - 1]} ${expire.year.toString().substring(2)}';
    return '$startStr - $expireStr';
  }

  static Future<bool?> show(
    BuildContext context, {
    required StudentModel member,
    required String slotDisplay,
    required String seatDisplay,
    required int planDays,
    required DateTime startDate,
    required DateTime expireDate,
    required String amountText,
    String? discountText,
    String? paidAmountText,
    String? pendingText,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RenewConfirmDialog(
        member: member,
        slotDisplay: slotDisplay,
        seatDisplay: seatDisplay,
        planDays: planDays,
        startDate: startDate,
        expireDate: expireDate,
        amountText: amountText,
        discountText: discountText,
        paidAmountText: paidAmountText,
        pendingText: pendingText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double discountVal =
        discountText != null ? (double.tryParse(discountText!) ?? 0) : 0;
    final double pendingVal =
        pendingText != null ? (double.tryParse(pendingText!) ?? 0) : 0;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text(
        'Confirm Renewal',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ConfirmRow(label: 'Name', value: member.name),
          _ConfirmRow(label: 'Slot', value: slotDisplay),
          _ConfirmRow(label: 'Seat', value: seatDisplay),
          _ConfirmRow(label: 'Plan', value: '$planDays days'),
          _ConfirmRow(
            label: 'Validity',
            value: _formatDateRange(startDate, expireDate),
          ),
          _ConfirmRow(label: 'Total Fee', value: '₹$amountText'),
          if (discountVal > 0)
            _ConfirmRow(
              label: 'Discount',
              value: '₹$discountText',
              valueColor: Colors.green.shade700,
            ),
          if (paidAmountText != null && paidAmountText!.isNotEmpty)
            _ConfirmRow(label: 'Paid', value: '₹$paidAmountText'),
          if (pendingVal > 0)
            _ConfirmRow(
              label: 'Pending',
              value: '₹$pendingText',
              valueColor: AppColors.error,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Renew'),
        ),
      ],
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grey500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
