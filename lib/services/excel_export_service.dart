import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/models/student_model.dart';

class ExcelExportService {
  ExcelExportService._();

  /// Generates and exports student roster to .xlsx Excel spreadsheet
  static Future<void> exportStudentsToExcel(
    BuildContext context, {
    required List<StudentModel> students,
    required String libraryName,
  }) async {
    try {
      final excel = Excel.createExcel();
      final String sheetName = "Student Roster";
      excel.rename("Sheet1", sheetName);

      final Sheet sheet = excel[sheetName];

      // Add Headers
      final List<String> headers = [
        "Student ID",
        "Student Name",
        "Phone Number",
        "Gender",
        "ID Proof",
        "Status",
        "Joining Date",
        "Plan Days",
        "Start Date",
        "Expire Date",
        "Slot Timing",
        "Seat Number",
        "Total Paid (Rs)",
        "Total Pending (Rs)",
        "Total Discount (Rs)",
      ];

      sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

      final dateFormat = DateFormat('yyyy-MM-dd');

      // Add Data Rows
      for (final student in students) {
        final List<CellValue> row = [
          TextCellValue(student.id ?? "N/A"),
          TextCellValue(student.name),
          TextCellValue(student.phone),
          TextCellValue(student.gender ?? "N/A"),
          TextCellValue(student.idProof ?? "N/A"),
          TextCellValue(student.status.toUpperCase()),
          TextCellValue(
            student.joiningDate != null
                ? dateFormat.format(student.joiningDate!)
                : "N/A",
          ),
          IntCellValue(student.currentPlanDays ?? 30),
          TextCellValue(
            student.currentStartDate != null
                ? dateFormat.format(student.currentStartDate!)
                : "N/A",
          ),
          TextCellValue(
            student.currentExpireDate != null
                ? dateFormat.format(student.currentExpireDate!)
                : "N/A",
          ),
          TextCellValue(student.slotTiming ?? "N/A"),
          TextCellValue(student.seatId != null ? "Assigned" : "Unassigned"),
          DoubleCellValue(student.totalPaid),
          DoubleCellValue(student.totalPending),
          DoubleCellValue(student.totalDiscount),
        ];

        sheet.appendRow(row);
      }

      final fileBytes = excel.save();
      if (fileBytes == null) {
        if (context.mounted) {
          AppNotification.show(
            context,
            message: 'Failed to generate Excel spreadsheet',
          );
        }
        return;
      }

      final uint8Bytes = Uint8List.fromList(fileBytes);
      final cleanName = libraryName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final fileName =
          '${cleanName}_Students_${DateFormat("yyyyMMdd_HHmm").format(DateTime.now())}.xlsx';

      // Save to Documents / Downloads folder
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(uint8Bytes);

      // Share / Open File Sheet
      await Printing.sharePdf(
        bytes: uint8Bytes,
        filename: fileName,
        subject: 'Student Roster - $libraryName',
      );

      if (context.mounted) {
        AppNotification.show(
          context,
          message: 'Exported ${students.length} students to Excel!',
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppNotification.show(context, message: 'Could not export to Excel: $e');
      }
    }
  }
}
