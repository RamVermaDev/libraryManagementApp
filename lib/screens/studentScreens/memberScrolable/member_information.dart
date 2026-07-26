import 'package:flutter/material.dart';

class MemberInformation extends StatelessWidget {
  const MemberInformation({
    super.key,
    required this.plan,
    required this.expireDate,
    this.slotTiming,
    this.seatNumber,
  });

  final String plan;
  final DateTime? expireDate;
  final String? slotTiming;
  final String? seatNumber;

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final formattedExpire = _formatDate(expireDate);
    final timingText = (slotTiming != null && slotTiming!.trim().isNotEmpty)
        ? slotTiming!.trim()
        : 'Not Set';
    final seatText = (seatNumber != null && seatNumber!.trim().isNotEmpty)
        ? seatNumber!.trim()
        : 'Unassigned';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Plan & Expires
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InfoCell(
                label: 'Plan',
                value: plan,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoCell(
                label: 'Expires',
                value: formattedExpire,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Row 2: Timing & Seat
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InfoCell(
                label: 'Timing',
                value: timingText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoCell(
                label: 'Seat',
                value: seatText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8), // Muted grey caption
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B), // Dark heading value
          ),
        ),
      ],
    );
  }
}
