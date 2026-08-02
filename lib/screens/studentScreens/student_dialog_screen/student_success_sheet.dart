import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/models/library_model.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/library_provider.dart';
import 'package:library_management/services/external_app_service.dart';
import 'package:library_management/services/manage_http_response.dart';
import 'package:library_management/services/pdf_receipt_service.dart';
import 'package:library_management/services/student_message_service.dart';

class StudentSuccessSheet extends ConsumerWidget {
  const StudentSuccessSheet({super.key, required this.student});

  final StudentModel student;

  LibraryModel? _getLibrary(WidgetRef ref) {
    final libraryId = ref.read(currentLibraryProvider);
    final libraries = ref.read(libraryProvider);
    if (libraryId == null) return libraries.isNotEmpty ? libraries.first : null;
    return libraries.firstWhere(
      (lib) => lib.id == libraryId,
      orElse: () => libraries.isNotEmpty
          ? libraries.first
          : const LibraryModel(
              libraryName: 'Library',
              tagLine: '',
              whatsappNumber: '',
              city: '',
              state: '',
              pinCode: '',
            ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double scale = context.scale;
    final library = _getLibrary(ref);
    final libName = StudentMessageService.getLibraryName(ref);

    return Container(
      padding: EdgeInsets.all(24 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24 * scale)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle Pill
          Center(
            child: Container(
              width: 42 * scale,
              height: 4 * scale,
              margin: EdgeInsets.only(bottom: 16 * scale),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Success Checkmark Icon
          Container(
            width: 60 * scale,
            height: 60 * scale,
            decoration: const BoxDecoration(
              color: Color(0xFFECFDF5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: const Color(0xFF10B981),
              size: 36 * scale,
            ),
          ),

          SizedBox(height: 14 * scale),

          Text(
            'Student Added Successfully! 🎉',
            style: TextStyle(
              fontSize: 18 * scale,
              fontWeight: FontWeight.bold,
              color: AppColors.heading,
            ),
          ),

          SizedBox(height: 4 * scale),

          Text(
            '${student.name} is registered in $libName.',
            style: TextStyle(fontSize: 13 * scale, color: AppColors.caption),
          ),

          SizedBox(height: 20 * scale),

          // 1. Primary: Welcome Text on WhatsApp (Direct to Student Chat)
          SizedBox(
            width: double.infinity,
            height: 48 * scale,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
              ),
              onPressed: () async {
                final welcomeMessage =
                    'Hi ${student.name}, welcome to $libName!';
                try {
                  await ExternalAppService.openWhatsApp(
                    phoneNumber: student.phone,
                    message: welcomeMessage,
                  );
                } catch (e) {
                  if (context.mounted) {
                    showSnackBar(
                      context,
                      'Could not open WhatsApp for ${student.phone}',
                    );
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/whatsapp.png',
                    width: 22 * scale,
                    height: 22 * scale,
                    color: Colors.white,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 10 * scale),
                  Text(
                    'Welcome Text on WhatsApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * scale,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10 * scale),

          // 2. Secondary: Share PDF Receipt File
          SizedBox(
            width: double.infinity,
            height: 48 * scale,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF25D366)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
              ),
              onPressed: () async {
                if (library != null) {
                  try {
                    await PdfReceiptService.shareReceipt(
                      student: student,
                      library: library,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      showSnackBar(context, 'Unable to share PDF receipt');
                    }
                  }
                }
              },
              icon: const Icon(
                Icons.share_rounded,
                color: Color(0xFF25D366),
                size: 20,
              ),
              label: Text(
                'Share PDF Receipt',
                style: TextStyle(
                  color: const Color(0xFF25D366),
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * scale,
                ),
              ),
            ),
          ),

          SizedBox(height: 10 * scale),

          // 3. Print / View PDF
          SizedBox(
            width: double.infinity,
            height: 48 * scale,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.buttonPrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
              ),
              onPressed: () async {
                if (library != null) {
                  try {
                    await PdfReceiptService.previewOrPrintReceipt(
                      context,
                      student: student,
                      library: library,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      AppNotification.show(
                        context,
                        message:
                            'Please restart the app once to enable PDF printing features.',
                      );
                    }
                  }
                }
              },
              icon: const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.buttonPrimary,
                size: 20,
              ),
              label: Text(
                'Print / View PDF Receipt',
                style: TextStyle(
                  color: AppColors.buttonPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * scale,
                ),
              ),
            ),
          ),

          SizedBox(height: 16 * scale),

          // Close / Done
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Done',
              style: TextStyle(
                color: AppColors.caption,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
