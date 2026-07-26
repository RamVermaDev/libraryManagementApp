import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/student_model.dart';

class BlacklistStudentSheet extends StatefulWidget {
  const BlacklistStudentSheet({
    super.key,
    required this.member,
    required this.scale,
    required this.onBlacklist,
  });

  final StudentModel member;
  final double scale;
  final Future<StudentModel?> Function(String reason) onBlacklist;

  static Future<StudentModel?> show({
    required BuildContext context,
    required StudentModel member,
    required double scale,
    required Future<StudentModel?> Function(String reason) onBlacklist,
  }) {
    return showModalBottomSheet<StudentModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BlacklistStudentSheet(
          member: member,
          scale: scale,
          onBlacklist: onBlacklist,
        ),
      ),
    );
  }

  @override
  State<BlacklistStudentSheet> createState() => _BlacklistStudentSheetState();
}

class _BlacklistStudentSheetState extends State<BlacklistStudentSheet> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;

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
              const Icon(Icons.block_rounded, color: AppColors.error, size: 24),
              const SizedBox(width: 8),
              Text(
                'Blacklist / Block Student',
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
            'Blocking ${widget.member.name} will immediately expire their membership and release their seat.',
            style: TextStyle(
              fontSize: 13 * scale,
              color: AppColors.caption,
            ),
          ),

          SizedBox(height: 18 * scale),

          // Reason Field
          Text(
            'Reason for Blacklisting (Optional)',
            style: TextStyle(
              fontSize: 13 * scale,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
          SizedBox(height: 8 * scale),
          TextField(
            controller: _reasonController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'e.g. Property damage, Misbehavior, Non-payment',
              filled: true,
              fillColor: AppColors.grey50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * scale),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),

          SizedBox(height: 24 * scale),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
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
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          setState(() => _isSubmitting = true);
                          final updatedStudent = await widget.onBlacklist(_reasonController.text.trim());
                          if (context.mounted) {
                            Navigator.pop(context, updatedStudent);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitting ? AppColors.grey300 : AppColors.error,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14 * scale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * scale),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SpinKitThreeBounce(
                          color: Colors.white,
                          size: 20,
                        )
                      : const Text(
                          'Block Now',
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
