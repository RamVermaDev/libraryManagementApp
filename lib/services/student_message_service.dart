import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/models/library_model.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/library_provider.dart';

class StudentMessageService {
  StudentMessageService._();

  /// Gets the library name using targetLibraryId or currentLibraryProvider
  /// searching through libraryProvider.
  static String getLibraryName(WidgetRef ref, {String? targetLibraryId}) {
    final currentLibraryId =
        targetLibraryId ?? ref.read(currentLibraryProvider);
    final List<LibraryModel> libraries = ref.read(libraryProvider);

    if (currentLibraryId != null && currentLibraryId.isNotEmpty) {
      for (final lib in libraries) {
        if (lib.id == currentLibraryId && lib.libraryName.isNotEmpty) {
          return lib.libraryName;
        }
      }
    }

    if (libraries.isNotEmpty && libraries.first.libraryName.isNotEmpty) {
      return libraries.first.libraryName;
    }

    return 'Library';
  }

  /// Generates a formal message for WhatsApp / SMS based on member status.
  /// Priority: Expired > Expiring > Pending > Default
  static String generateMessage({
    required StudentModel student,
    required String libraryName,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expireDate = student.currentExpireDate != null
        ? DateTime(
            student.currentExpireDate!.year,
            student.currentExpireDate!.month,
            student.currentExpireDate!.day,
          )
        : null;

    final double pending = student.totalPending;

    int? daysLeft;
    bool isExpired = false;
    bool isExpiring = false;

    if (expireDate != null) {
      daysLeft = expireDate.difference(today).inDays;
      if (daysLeft < 0) {
        isExpired = true;
      } else if (daysLeft <= 7) {
        isExpiring = true;
      }
    }

    // 1. Expired takes highest priority
    if (isExpired) {
      return 'Hi ${student.name},\n\n'
          'Your subscription has been expired. Please renew your plan to continue using library services.\n\n'
          'Thank you,\n'
          '$libraryName';
    }

    // 2. Expiring soon
    if (isExpiring && daysLeft != null) {
      final daysText =
          daysLeft == 0
              ? 'today'
              : 'in $daysLeft day${daysLeft == 1 ? '' : 's'}';
      return 'Hi ${student.name},\n\n'
          'Your subscription is expiring $daysText. Please renew your plan on time to enjoy uninterrupted access.\n\n'
          'Thank you,\n'
          '$libraryName';
    }

    // 3. Pending payment
    if (pending > 0) {
      final pendingInt =
          pending % 1 == 0
              ? pending.toInt().toString()
              : pending.toStringAsFixed(2);
      return 'Hi ${student.name},\n\n'
          'An amount of ₹$pendingInt is pending for your account. Please submit it at your earliest convenience.\n\n'
          'Thank you,\n'
          '$libraryName';
    }

    // 4. Default active message
    return 'Hi ${student.name},\n\n'
        'Thank you for being a valued member of $libraryName!\n\n'
        'Thank you,\n'
        '$libraryName';
  }
}
