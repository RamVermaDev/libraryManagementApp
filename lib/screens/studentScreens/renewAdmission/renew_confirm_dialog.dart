import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/student_model.dart';

class RenewConfirmDialog extends StatelessWidget {
  const RenewConfirmDialog({
    super.key,
    required this.member,
    required this.slotDisplay,
    required this.amountText,
    required this.planDays,
  });

  final StudentModel member;
  final String slotDisplay;
  final String amountText;
  final int planDays;

  static Future<bool?> show(
    BuildContext context, {
    required StudentModel member,
    required String slotDisplay,
    required String amountText,
    required int planDays,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RenewConfirmDialog(
        member: member,
        slotDisplay: slotDisplay,
        amountText: amountText,
        planDays: planDays,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          _ConfirmRow(label: 'Phone', value: member.phone),
          _ConfirmRow(label: 'Slot', value: slotDisplay),
          _ConfirmRow(label: 'Amount', value: '₹$amountText'),
          _ConfirmRow(label: 'Plan', value: '$planDays days'),
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
  const _ConfirmRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
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
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
