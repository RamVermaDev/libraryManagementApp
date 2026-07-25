import 'package:flutter/material.dart';

class DecreaseSeatDialog extends StatelessWidget {
  final int currentTotal;
  final int newTotal;
  final bool isConflict;
  final String conflictMessage;
  final List<dynamic> affectedBookings;

  const DecreaseSeatDialog({
    super.key,
    required this.currentTotal,
    required this.newTotal,
    this.isConflict = false,
    this.conflictMessage = '',
    this.affectedBookings = const [],
  });

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required int currentTotal,
    required int newTotal,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) =>
          DecreaseSeatDialog(currentTotal: currentTotal, newTotal: newTotal),
    );
  }

  static void showConflictAlert({
    required BuildContext context,
    required String message,
    required List<dynamic> affectedBookings,
  }) {
    showDialog(
      context: context,
      builder: (_) => DecreaseSeatDialog(
        currentTotal: 0,
        newTotal: 0,
        isConflict: true,
        conflictMessage: message,
        affectedBookings: affectedBookings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isConflict) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text(
              'Cannot Decrease Seats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conflictMessage,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            if (affectedBookings.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                'Active Bookings Affected:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: affectedBookings.length,
                  itemBuilder: (context, index) {
                    final item = affectedBookings[index];
                    final name = item['studentName'] ?? 'Student';
                    final phone = item['phone'] ?? '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '• $name ${phone.isNotEmpty ? "($phone)" : ""}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade900,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }

    final removedCount = currentTotal - newTotal;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          SizedBox(width: 10),
          Text(
            'Decrease Seats Warning',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You are reducing total seats from $currentTotal to $newTotal ($removedCount seat(s) will be removed).',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Colors.orange.shade800,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Higher seat numbers (Seat ${newTotal + 1} to $currentTotal) will be permanently deleted from the seat layout.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
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
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirm Reduction'),
        ),
      ],
    );
  }
}
