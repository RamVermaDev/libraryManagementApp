import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/student_model.dart';

class UnblockStudentSheet extends StatelessWidget {
  const UnblockStudentSheet({
    super.key,
    required this.member,
    required this.scale,
  });

  final StudentModel member;
  final double scale;

  static Future<bool?> show({
    required BuildContext context,
    required StudentModel member,
    required double scale,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: UnblockStudentSheet(member: member, scale: scale),
      ),
    );
  }

  String _formattedDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final reasonText = (member.blacklistReason != null && member.blacklistReason!.trim().isNotEmpty)
        ? member.blacklistReason!.trim()
        : 'No reason provided';

    return Container(
      padding: EdgeInsets.fromLTRB(
        20 * scale,
        20 * scale,
        20 * scale,
        24 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24 * scale),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40 * scale,
              height: 4 * scale,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 16 * scale),

          Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 24),
              const SizedBox(width: 8),
              Text(
                'Unblock Student',
                style: TextStyle(
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.bold,
                  color: AppColors.heading,
                ),
              ),
            ],
          ),
          SizedBox(height: 6 * scale),
          Text(
            'Unblocking ${member.name} will restore their status to active. No seat will be assigned and membership remains expired until renewed.',
            style: TextStyle(
              fontSize: 13 * scale,
              color: AppColors.caption,
            ),
          ),

          SizedBox(height: 16 * scale),

          // Blacklist Reason Display Card
          Container(
            padding: EdgeInsets.all(12 * scale),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12 * scale),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Blocked Date:',
                      style: TextStyle(fontSize: 12, color: AppColors.grey600),
                    ),
                    Text(
                      _formattedDate(member.blacklistedAt),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error),
                    ),
                  ],
                ),
                SizedBox(height: 6 * scale),
                const Text(
                  'Reason for Blacklist:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.heading),
                ),
                SizedBox(height: 4 * scale),
                Text(
                  reasonText,
                  style: const TextStyle(fontSize: 13, color: AppColors.heading),
                ),
              ],
            ),
          ),

          SizedBox(height: 24 * scale),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14 * scale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * scale),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(width: 12 * scale),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14 * scale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * scale),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Unblock Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
