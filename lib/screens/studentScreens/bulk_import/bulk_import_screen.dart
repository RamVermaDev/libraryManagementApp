import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/bulk_import_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';

class BulkImportScreen extends ConsumerStatefulWidget {
  const BulkImportScreen({super.key});

  @override
  ConsumerState<BulkImportScreen> createState() => _BulkImportScreenState();
}

class _BulkImportScreenState extends ConsumerState<BulkImportScreen> {
  final _controller = BulkImportController();
  bool _isUploading = false;
  bool _isDownloading = false;
  bool _isClearing = false;

  Future<void> _handleDownloadTemplate() async {
    setState(() => _isDownloading = true);
    try {
      await _controller.downloadSampleTemplate(context, ref);
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<void> _handleSelectFile() async {
    final pickedFile = await _controller.pickExcelFile(context);
    if (pickedFile == null || pickedFile.files.single.path == null) return;

    final fileName = pickedFile.files.single.name;
    final filePath = pickedFile.files.single.path!;

    if (!mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.description_rounded, color: AppColors.primary, size: 26),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Import Selected File?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.table_chart_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      fileName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.heading,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Are you sure you want to process and import student records from this Excel file into your database?',
              style: TextStyle(color: AppColors.body, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(
              Icons.upload_file_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: const Text(
              'Confirm & Import',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isUploading = true);
    try {
      final result = await _controller.uploadExcelFile(
        context: context,
        ref: ref,
        filePath: filePath,
      );

      if (result != null && result['success'] == true && mounted) {
        final Map<String, dynamic> data = jsonDecode(result['body']);
        final count = data['count'] ?? 0;
        final skipped = data['skipped'] ?? 0;

        _showResultDialog(count: count, skipped: skipped);
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _handleClearData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
            SizedBox(width: 8),
            Text('Reset Library Data?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Warning: This action will perform a total fresh reset for this library:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            SizedBox(height: 10),
            Text('• Delete all student memberships'),
            Text('• Delete all fee payments & revenue records'),
            Text('• Delete all seat reservations'),
            Text('• Reset all seats to available status'),
            SizedBox(height: 12),
            Text(
              'This action cannot be undone!',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Yes, Reset All Data',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isClearing = true);
    try {
      final success = await _controller.clearLibraryData(
        context: context,
        ref: ref,
      );
      if (success && mounted) {
        AppNotification.show(context, message: 'Library Reset');
      }
    } finally {
      if (mounted) setState(() => _isClearing = false);
    }
  }

  void _showResultDialog({required int count, required int skipped}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'Members Imported 🎉',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count students added successfully.',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.heading,
              ),
            ),
            if (skipped > 0) ...[
              const SizedBox(height: 8),
              Text(
                '$skipped skipped (duplicates or incomplete info).',
                style: const TextStyle(color: AppColors.warning, fontSize: 13),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child:
                const Text('Continue', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'Bulk Import'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Download Sample File Card
            InkWell(
              onTap: _isDownloading ? null : _handleDownloadTemplate,
              borderRadius: BorderRadius.circular(16 * scale),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18 * scale),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16 * scale),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12 * scale),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(12 * scale),
                      ),
                      child: _isDownloading
                          ? const SpinKitThreeBounce(
                              color: AppColors.primary,
                              size: 16,
                            )
                          : Icon(
                              Icons.download_rounded,
                              color: AppColors.primary,
                              size: 24 * scale,
                            ),
                    ),
                    SizedBox(width: 16 * scale),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Download Sample File',
                            style: TextStyle(
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.bold,
                              color: AppColors.heading,
                            ),
                          ),
                          SizedBox(height: 2 * scale),
                          Text(
                            'Get the exact Excel template',
                            style: TextStyle(
                              fontSize: 13 * scale,
                              color: AppColors.body,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20 * scale),

            // 2. Select Excel File to Import Primary Button
            SizedBox(
              width: double.infinity,
              height: 52 * scale,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14 * scale),
                  ),
                  elevation: 2,
                ),
                onPressed: _isUploading ? null : _handleSelectFile,
                icon: _isUploading
                    ? const SpinKitThreeBounce(color: Colors.white, size: 16)
                    : const Icon(
                        Icons.folder_open_rounded,
                        color: Colors.white,
                      ),
                label: Text(
                  'Select Excel File to Import',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 24 * scale),

            // 3. Information Cards Grid (Quick Tip & Important)
            Row(
              children: [
                // Quick Tip Card
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16 * scale),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(16 * scale),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8 * scale),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8 * scale),
                          ),
                          child: Icon(
                            Icons.lightbulb_outline_rounded,
                            color: AppColors.primary,
                            size: 20 * scale,
                          ),
                        ),
                        SizedBox(height: 12 * scale),
                        Text(
                          'Quick Tip',
                          style: TextStyle(
                            fontSize: 15 * scale,
                            fontWeight: FontWeight.bold,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 4 * scale),
                        Text(
                          'Download sample file to see the exact format',
                          style: TextStyle(
                            fontSize: 12 * scale,
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 14 * scale),

                // Important Card
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16 * scale),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(16 * scale),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8 * scale),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8 * scale),
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.warning,
                            size: 20 * scale,
                          ),
                        ),
                        SizedBox(height: 12 * scale),
                        Text(
                          'Important',
                          style: TextStyle(
                            fontSize: 15 * scale,
                            fontWeight: FontWeight.bold,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 4 * scale),
                        Text(
                          'Ensure data accuracy before importing',
                          style: TextStyle(
                            fontSize: 12 * scale,
                            color: AppColors.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 28 * scale),

            // 4. Data Cleanup Box (Red Border Card)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18 * scale),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(18 * scale),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8 * scale),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8 * scale),
                        ),
                        child: Icon(
                          Icons.cleaning_services_rounded,
                          color: AppColors.error,
                          size: 20 * scale,
                        ),
                      ),
                      SizedBox(width: 10 * scale),
                      Text(
                        'Data Cleanup',
                        style: TextStyle(
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * scale),
                  Text(
                    'Need to re-import? Delete all existing memberships and payments for this library first.',
                    style: TextStyle(
                      fontSize: 13 * scale,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 16 * scale),
                  SizedBox(
                    width: double.infinity,
                    height: 46 * scale,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12 * scale),
                        ),
                      ),
                      onPressed: _isClearing ? null : _handleClearData,
                      icon: _isClearing
                          ? const SpinKitThreeBounce(
                              color: AppColors.error,
                              size: 14,
                            )
                          : const Icon(
                              Icons.delete_forever_rounded,
                              color: AppColors.error,
                            ),
                      label: Text(
                        'Clear Library Data',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
