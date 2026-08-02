import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:library_management/models/library_model.dart';
import 'package:library_management/models/student_model.dart';

class PdfReceiptService {
  PdfReceiptService._();

  /// Generates the Admission Receipt PDF as bytes
  static Future<Uint8List> generateReceiptPdf({
    required StudentModel student,
    required LibraryModel library,
  }) async {
    final pdf = pw.Document();

    final dateFormat = DateFormat('dd MMM yyyy');
    final issueDate = dateFormat.format(student.createdAt ?? DateTime.now());
    final startDateStr = student.currentStartDate != null
        ? dateFormat.format(student.currentStartDate!)
        : 'N/A';
    final expireDateStr = student.currentExpireDate != null
        ? dateFormat.format(student.currentExpireDate!)
        : 'N/A';

    final totalFee =
        student.totalPaid + student.totalPending + student.totalDiscount;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Card
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.indigo900,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      library.libraryName.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    if (library.tagLine.isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        library.tagLine,
                        style: const pw.TextStyle(
                          fontSize: 11,
                          color: PdfColors.grey300,
                        ),
                      ),
                    ],
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        if (library.city.isNotEmpty)
                          pw.Text(
                            '📍 ${library.city}${library.state.isNotEmpty ? ", ${library.state}" : ""}',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey300,
                            ),
                          ),
                        if (library.whatsappNumber.isNotEmpty)
                          pw.Text(
                            '📞 WhatsApp: ${library.whatsappNumber}',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey300,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 24),

              // Title & Date
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'ADMISSION RECEIPT',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.indigo900,
                    ),
                  ),
                  pw.Text(
                    'Date: $issueDate',
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),

              pw.Divider(thickness: 1, color: PdfColors.grey300),

              pw.SizedBox(height: 16),

              // Member Details Box
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Member Information',
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.indigo900,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _infoRow('Full Name:', student.name),
                              pw.SizedBox(height: 6),
                              _infoRow('Phone:', student.phone),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _infoRow(
                                'Plan Duration:',
                                '${student.currentPlanDays} Days',
                              ),
                              pw.SizedBox(height: 6),
                              _infoRow('Valid Till:', expireDateStr),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Subscription Table
              pw.Text(
                'Billing & Payment Breakdown',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.indigo900,
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.grey300,
                  width: 0.8,
                ),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.indigo50,
                    ),
                    children: [
                      _tableHeader('Description'),
                      _tableHeader('Start Date'),
                      _tableHeader('Expiry Date'),
                      _tableHeader('Amount'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _tableCell(
                        'Study Space Membership (${student.currentPlanDays} Days)',
                      ),
                      _tableCell(startDateStr),
                      _tableCell(expireDateStr),
                      _tableCell('Rs ${totalFee.toStringAsFixed(0)}'),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Summary Box
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 220,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Column(
                    children: [
                      _summaryRow(
                        'Total Plan Fee:',
                        'Rs ${totalFee.toStringAsFixed(0)}',
                      ),
                      if (student.totalDiscount > 0) ...[
                        pw.SizedBox(height: 4),
                        _summaryRow(
                          'Discount:',
                          '- Rs ${student.totalDiscount.toStringAsFixed(0)}',
                          color: PdfColors.green700,
                        ),
                      ],
                      pw.SizedBox(height: 4),
                      pw.Divider(thickness: 0.5, color: PdfColors.grey300),
                      pw.SizedBox(height: 4),
                      _summaryRow(
                        'Paid Amount:',
                        'Rs ${student.totalPaid.toStringAsFixed(0)}',
                        bold: true,
                        color: PdfColors.green700,
                      ),
                      if (student.totalPending > 0) ...[
                        pw.SizedBox(height: 4),
                        _summaryRow(
                          'Pending Balance:',
                          'Rs ${student.totalPending.toStringAsFixed(0)}',
                          bold: true,
                          color: PdfColors.red700,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              // Footer Note
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  'Thank you for joining ${library.libraryName}! This is a computer-generated receipt.',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Text(
          '$label ',
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey700,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
        ),
      ],
    );
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.indigo900,
        ),
      ),
    );
  }

  static pw.Widget _tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
      ),
    );
  }

  static pw.Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
    PdfColor color = PdfColors.black,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey800,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// Opens the PDF Preview & Thermal Print Screen
  static Future<void> previewOrPrintReceipt(
    BuildContext context, {
    required StudentModel student,
    required LibraryModel library,
  }) async {
    await Printing.layoutPdf(
      onLayout: (format) async =>
          generateReceiptPdf(student: student, library: library),
      name: 'Admission_Receipt_${student.name}.pdf',
    );
  }

  /// Shares the PDF Receipt via WhatsApp or Native Share Sheet
  static Future<void> shareReceipt({
    required StudentModel student,
    required LibraryModel library,
  }) async {
    final pdfBytes = await generateReceiptPdf(
      student: student,
      library: library,
    );

    final welcomeText =
        'Welcome to ${library.libraryName}! Here is your official admission receipt & membership details. Thank you!';

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Admission_Receipt_${student.name}.pdf',
      subject: welcomeText,
    );
  }
}
