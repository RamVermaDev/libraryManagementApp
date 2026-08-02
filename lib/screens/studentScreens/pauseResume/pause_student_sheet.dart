import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/student_model.dart';

class PauseStudentSheet extends StatefulWidget {
  const PauseStudentSheet({
    super.key,
    required this.member,
    required this.scale,
    required this.onPause,
  });

  final StudentModel member;
  final double scale;
  final Future<StudentModel?> Function(String reason) onPause;

  static Future<StudentModel?> show({
    required BuildContext context,
    required StudentModel member,
    required double scale,
    required Future<StudentModel?> Function(String reason) onPause,
  }) {
    return showModalBottomSheet<StudentModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: PauseStudentSheet(
          member: member,
          scale: scale,
          onPause: onPause,
        ),
      ),
    );
  }

  @override
  State<PauseStudentSheet> createState() => _PauseStudentSheetState();
}

class _PauseStudentSheetState extends State<PauseStudentSheet> {
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24 * scale)),
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

          Text(
            'Pause Membership',
            style: TextStyle(
              fontSize: 18 * scale,
              fontWeight: FontWeight.bold,
              color: AppColors.heading,
            ),
          ),
          SizedBox(height: 6 * scale),
          Text(
            'Pausing ${widget.member.name}\'s membership will release their seat. Their countdown will pause today until resumed.',
            style: TextStyle(fontSize: 13 * scale, color: AppColors.caption),
          ),

          SizedBox(height: 18 * scale),

          // Reason Field
          Text(
            'Pause Reason (Optional)',
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
              hintText: 'e.g. Out of town, Medical leave, Exams',
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
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.pop(context),
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
                          final updatedStudent = await widget.onPause(
                            _reasonController.text.trim(),
                          );
                          if (context.mounted) {
                            Navigator.pop(context, updatedStudent);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitting
                        ? AppColors.grey300
                        : AppColors.warning,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14 * scale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * scale),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                      : const Text(
                          'Pause Now',
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
