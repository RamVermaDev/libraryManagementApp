import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/student_controller.dart';
import 'package:library_management/models/fee_record_model.dart';
import 'package:library_management/models/library_model.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/library_provider.dart';
import 'package:library_management/services/pdf_receipt_service.dart';

class AdmissionsHistorySheet extends ConsumerStatefulWidget {
  const AdmissionsHistorySheet({super.key, required this.student});

  final StudentModel student;

  @override
  ConsumerState<AdmissionsHistorySheet> createState() => _AdmissionsHistorySheetState();
}

class _AdmissionsHistorySheetState extends ConsumerState<AdmissionsHistorySheet> {
  final StudentController _studentController = StudentController();
  List<FeeRecordModel> _feeRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadRecords();
    });
  }

  Future<void> _loadRecords() async {
    final libraryId = ref.read(currentLibraryProvider) ?? widget.student.libraryId;
    final studentId = widget.student.id;

    if (studentId == null || studentId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    final records = await _studentController.fetchStudentFeeRecords(
      ref: ref,
      libraryId: libraryId,
      studentId: studentId,
    );

    if (!mounted) return;

    setState(() {
      _feeRecords = records;
      _isLoading = false;
    });
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
    final double scale = context.scale;
    final dateFormat = DateFormat('dd MMM yyyy');
    final library = _getLibrary();

    return Container(
      padding: EdgeInsets.fromLTRB(20 * scale, 12 * scale, 20 * scale, 24 * scale),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24 * scale)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle Pill
            Center(
              child: Container(
                width: 42 * scale,
                height: 4 * scale,
                margin: EdgeInsets.only(bottom: 14 * scale),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            // Header Title & Count Badge
            Row(
              children: [
                Text(
                  'Admissions & Fees',
                  style: TextStyle(
                    fontSize: 18 * scale,
                    fontWeight: FontWeight.bold,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(width: 8 * scale),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_feeRecords.length}',
                    style: TextStyle(
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.caption),
                ),
              ],
            ),

            const Divider(height: 1, color: AppColors.border),
            SizedBox(height: 14 * scale),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_feeRecords.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 44,
                        color: AppColors.caption,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No admission history found',
                        style: TextStyle(
                          fontSize: 14 * scale,
                          color: AppColors.caption,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.55,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _feeRecords.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10 * scale),
                  itemBuilder: (context, index) {
                    final record = _feeRecords[index];
                    final isPaid = record.pendingAmount <= 0;

                    return Container(
                      padding: EdgeInsets.all(14 * scale),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16 * scale),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
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
                                        fontSize: 15 * scale,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.heading,
                                      ),
                                    ),
                                    SizedBox(width: 8 * scale),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isPaid
                                            ? const Color(0xFFECFDF5)
                                            : const Color(0xFFFEF2F2),
                                        borderRadius: BorderRadius.circular(10),
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
                                    fontSize: 12 * scale,
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
                                          fontSize: 12 * scale,
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

                          // PDF Receipt Action Icon Button
                          if (library != null)
                            IconButton(
                              onPressed: () async {
                                await PdfReceiptService.previewOrPrintReceipt(
                                  context,
                                  student: widget.student,
                                  library: library,
                                );
                              },
                              icon: const Icon(
                                Icons.picture_as_pdf_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              tooltip: 'View PDF Receipt',
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
