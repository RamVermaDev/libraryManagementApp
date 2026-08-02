import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/student_controller.dart';
import 'package:library_management/models/fee_record_model.dart';
import 'package:library_management/models/library_model.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/library_provider.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/card_decoration.dart';
import 'package:library_management/services/manage_http_response.dart';
import 'package:library_management/services/pdf_receipt_service.dart';

class AdmissionsCard extends ConsumerStatefulWidget {
  final double scale;
  final StudentModel student;

  const AdmissionsCard({
    super.key,
    required this.scale,
    required this.student,
  });

  @override
  ConsumerState<AdmissionsCard> createState() => _AdmissionsCardState();
}

class _AdmissionsCardState extends ConsumerState<AdmissionsCard> {
  final StudentController _studentController = StudentController();
  bool _isExpanded = false;
  bool _isLoading = false;
  List<FeeRecordModel> _feeRecords = [];
  bool _hasFetched = false;

  Future<void> _toggleExpand() async {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded && !_hasFetched) {
      setState(() {
        _isLoading = true;
      });

      final libraryId = ref.read(currentLibraryProvider) ?? widget.student.libraryId;
      final studentId = widget.student.id;

      if (studentId != null && studentId.isNotEmpty) {
        final records = await _studentController.fetchStudentFeeRecords(
          ref: ref,
          libraryId: libraryId,
          studentId: studentId,
        );

        if (mounted) {
          setState(() {
            _feeRecords = records;
            _isLoading = false;
            _hasFetched = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasFetched = true;
          });
        }
      }
    }
  }

  LibraryModel? _getLibrary() {
    final libraryId = ref.read(currentLibraryProvider) ?? widget.student.libraryId;
    final libraries = ref.read(libraryProvider);
    if (libraries.isEmpty) return null;
    return libraries.firstWhere(
      (lib) => lib.id == libraryId,
      orElse: () => libraries.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scale = widget.scale;
    final radius = BorderRadius.circular(18 * scale);
    final dateFormat = DateFormat('dd MMM yyyy');
    final library = _getLibrary();

    return Container(
      decoration: cardDecoration(radius: 18 * scale),
      child: Material(
        color: Colors.white,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Toggle Bar
            InkWell(
              onTap: _toggleExpand,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20 * scale,
                  vertical: 18 * scale,
                ),
                child: Row(
                  children: [
                    Text(
                      'Admissions',
                      style: TextStyle(
                        color: AppColors.heading,
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(width: 8 * scale),

                    // Number of admissions pill background badge
                    if (_hasFetched && _feeRecords.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_feeRecords.length}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 11 * scale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const Spacer(),

                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 24 * scale,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),

            // Expandable Content Container (In-Line on Screen)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  const Divider(height: 1, color: AppColors.divider),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    )
                  else if (_feeRecords.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(20 * scale),
                      child: Text(
                        'No admission history found',
                        style: TextStyle(
                          fontSize: 13 * scale,
                          color: AppColors.caption,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16 * scale),
                      itemCount: _feeRecords.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12 * scale),
                      itemBuilder: (context, index) {
                        final record = _feeRecords[index];
                        final isPaid = record.pendingAmount <= 0;

                        return Container(
                          padding: EdgeInsets.all(14 * scale),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(14 * scale),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${record.planDays} Days Plan',
                                          style: TextStyle(
                                            fontSize: 14 * scale,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.heading,
                                          ),
                                        ),
                                        SizedBox(width: 8 * scale),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isPaid
                                                ? const Color(0xFFECFDF5)
                                                : const Color(0xFFFEF2F2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            isPaid
                                                ? 'Paid'
                                                : 'Pending ₹${record.pendingAmount.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 10 * scale,
                                              fontWeight: FontWeight.bold,
                                              color: isPaid
                                                  ? const Color(0xFF10B981)
                                                  : const Color(0xFFEF4444),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4 * scale),
                                    Text(
                                      '${dateFormat.format(record.startDate)} – ${dateFormat.format(record.expireDate)}',
                                      style: TextStyle(
                                        fontSize: 11 * scale,
                                        color: AppColors.caption,
                                      ),
                                    ),
                                    SizedBox(height: 6 * scale),
                                    Row(
                                      children: [
                                        Text(
                                          'Paid: ₹${record.paidAmount.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 12 * scale,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.heading,
                                          ),
                                        ),
                                        if (record.discount > 0) ...[
                                          SizedBox(width: 10 * scale),
                                          Text(
                                            'Disc: ₹${record.discount.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 11 * scale,
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // PDF SHARE Icon Button (Triggers Share, NOT Print)
                              IconButton(
                                onPressed: () async {
                                  if (library != null) {
                                    try {
                                      await PdfReceiptService.shareReceipt(
                                        student: widget.student,
                                        library: library,
                                      );
                                    } catch (e) {
                                      if (context.mounted) {
                                        showSnackBar(
                                          context,
                                          'Unable to share PDF receipt',
                                        );
                                      }
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.picture_as_pdf_rounded,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                                tooltip: 'Share PDF Receipt',
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
