import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/seat_availability_controller.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/seat_availability_provider.dart';
import 'package:library_management/screens/seat_box.dart';

class ResumeResult {
  final int extensionDays;
  final String? seatId;

  ResumeResult({required this.extensionDays, this.seatId});
}

class ResumeStudentSheet extends ConsumerStatefulWidget {
  const ResumeStudentSheet({
    super.key,
    required this.member,
    required this.scale,
    required this.onResume,
  });

  final StudentModel member;
  final double scale;
  final Future<StudentModel?> Function(ResumeResult result) onResume;

  static Future<StudentModel?> show({
    required BuildContext context,
    required StudentModel member,
    required double scale,
    required Future<StudentModel?> Function(ResumeResult result) onResume,
  }) {
    return showModalBottomSheet<StudentModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ResumeStudentSheet(
          member: member,
          scale: scale,
          onResume: onResume,
        ),
      ),
    );
  }

  @override
  ConsumerState<ResumeStudentSheet> createState() => _ResumeStudentSheetState();
}

class _ResumeStudentSheetState extends ConsumerState<ResumeStudentSheet> {
  final SeatAvailabilityController _seatController =
      SeatAvailabilityController();
  final TextEditingController _daysController = TextEditingController();

  int _actualPausedDays = 0;
  int _extensionDays = 0;
  String? _selectedSeatId;
  bool _isLoadingSeats = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _calculatePausedDays();
    _daysController.text = _actualPausedDays.toString();
    _extensionDays = _actualPausedDays;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadSeatMap();
    });
  }

  void _calculatePausedDays() {
    if (widget.member.pausedAt != null) {
      final difference = DateTime.now().difference(widget.member.pausedAt!);
      _actualPausedDays = difference.inDays;
      if (_actualPausedDays < 0) _actualPausedDays = 0;
    } else {
      _actualPausedDays = 0;
    }
  }

  Future<void> _loadSeatMap() async {
    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null) return;

    setState(() => _isLoadingSeats = true);

    await _seatController.fetchSeatMap(
      context: context,
      ref: ref,
      libraryId: libraryId,
      slotTemplateId: widget.member.slotTemplateId,
    );

    if (mounted) {
      setState(() => _isLoadingSeats = false);
    }
  }

  DateTime _calculateNewExpiryDate() {
    final currentExpire = widget.member.currentExpireDate ?? DateTime.now();
    return currentExpire.add(Duration(days: _extensionDays));
  }

  String _formattedDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final seats = ref.watch(seatAvailabilityProvider);
    final newExpiryDate = _calculateNewExpiryDate();
    final bool hasAvailableSeats = seats.any((seat) => seat.isAvailable);
    final bool canResume = !hasAvailableSeats || _selectedSeatId != null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
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
      child: SingleChildScrollView(
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
              'Resume Membership',
              style: TextStyle(
                fontSize: 18 * scale,
                fontWeight: FontWeight.bold,
                color: AppColors.heading,
              ),
            ),
            SizedBox(height: 4 * scale),
            Text(
              'Resuming ${widget.member.name}\'s plan.',
              style: TextStyle(fontSize: 13 * scale, color: AppColors.caption),
            ),

            SizedBox(height: 16 * scale),

            // Paused Info Card
            Container(
              padding: EdgeInsets.all(12 * scale),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12 * scale),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Actual Days Paused:',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.grey600,
                        ),
                      ),
                      Text(
                        '$_actualPausedDays Days',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.heading,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6 * scale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'New Expiry Date:',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.grey600,
                        ),
                      ),
                      Text(
                        _formattedDate(newExpiryDate),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16 * scale),

            // Days Extension Input
            Text(
              'Days to Extend Membership',
              style: TextStyle(
                fontSize: 13 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
            SizedBox(height: 8 * scale),
            TextField(
              controller: _daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: 'Days',
                hintText: 'Enter extension days',
                filled: true,
                fillColor: AppColors.grey50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12 * scale),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _extensionDays = int.tryParse(val) ?? 0;
                });
              },
            ),

            SizedBox(height: 18 * scale),

            // Seat Picker Header
            Text(
              'Assign Seat (Optional)',
              style: TextStyle(
                fontSize: 13 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
            SizedBox(height: 8 * scale),

            if (_isLoadingSeats)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (seats.isEmpty)
              const Text(
                'No seats found for this slot',
                style: TextStyle(color: AppColors.caption),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                itemCount: seats.length,
                itemBuilder: (context, index) {
                  final seat = seats[index];
                  final isSelected = seat.seatId == _selectedSeatId;
                  return SeatBox(
                    seat: seat,
                    isSelected: isSelected,
                    onTap: () {
                      if (!seat.isAvailable) return;
                      setState(() {
                        _selectedSeatId = isSelected ? null : seat.seatId;
                      });
                    },
                  );
                },
              ),
            if (hasAvailableSeats && _selectedSeatId == null) ...[
              SizedBox(height: 8 * scale),
              const Text(
                '* Please select a seat below to resume membership.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
            ],

            SizedBox(height: 24 * scale),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: (canResume && !_isSubmitting)
                        ? () async {
                            setState(() => _isSubmitting = true);
                            final updatedStudent = await widget.onResume(
                              ResumeResult(
                                extensionDays: _extensionDays,
                                seatId: _selectedSeatId,
                              ),
                            );
                            if (context.mounted) {
                              Navigator.pop(context, updatedStudent);
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canResume
                          ? AppColors.success
                          : AppColors.grey300,
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
                            'Resume Now',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
