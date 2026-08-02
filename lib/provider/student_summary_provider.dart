import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/models/student_summary_model.dart';

final studentSummaryProvider =
    StateNotifierProvider<StudentSummaryNotifier, StudentSummaryModel?>(
      (ref) => StudentSummaryNotifier(),
    );

class StudentSummaryNotifier extends StateNotifier<StudentSummaryModel?> {
  StudentSummaryNotifier() : super(null);

  void setSummary(StudentSummaryModel summary) {
    state = summary;
  }

  void addActiveStudent() {
    final currentState = state;

    if (currentState == null) return;

    state = currentState.copyWith(active: currentState.active + 1);
  }

  void onStudentAdded(StudentModel student) {
    final currentState = state;
    if (currentState == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysLeft = _getDaysLeft(student.currentExpireDate, today);

    int active = currentState.active + 1;
    int exp1To3 = currentState.expiring1To3Days;
    int exp4To7 = currentState.expiring4To7Days;
    int exp8To10 = currentState.expiring8To10Days;
    double totalPending = currentState.totalPendingAmount + student.totalPending;

    if (daysLeft != null && daysLeft >= 0 && daysLeft <= 10) {
      if (daysLeft >= 0 && daysLeft <= 3) {
        exp1To3++;
      } else if (daysLeft >= 4 && daysLeft <= 6) {
        exp4To7++;
      } else if (daysLeft >= 7 && daysLeft <= 10) {
        exp8To10++;
      }
    }

    state = currentState.copyWith(
      active: active,
      totalPendingAmount: totalPending,
      expiring1To3Days: exp1To3,
      expiring4To7Days: exp4To7,
      expiring8To10Days: exp8To10,
    );
  }

  void onStudentResumed(StudentModel student) {
    onStudentAdded(student);
  }

  void removeActiveStudent() {
    final currentState = state;
    if (currentState == null) return;
    state = currentState.copyWith(
      active: (currentState.active - 1).clamp(0, currentState.active),
    );
  }

  int? _getDaysLeft(DateTime? date, DateTime today) {
    if (date == null) return null;
    final local = date.toLocal();
    final dateOnly = DateTime(local.year, local.month, local.day);
    return dateOnly.difference(today).inDays;
  }

  void onStudentRenewed({
    required StudentModel oldStudent,
    required StudentModel newStudent,
  }) {
    final currentState = state;
    if (currentState == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final oldDays = _getDaysLeft(oldStudent.currentExpireDate, today);
    final newDays = _getDaysLeft(newStudent.currentExpireDate, today);

    int active = currentState.active;
    int exp1To3 = currentState.expiring1To3Days;
    int exp4To7 = currentState.expiring4To7Days;
    int exp8To10 = currentState.expiring8To10Days;

    int expired1To3 = currentState.expired1To3Days;
    int expired4To7 = currentState.expired4To7Days;
    int expired8To10 = currentState.expired8To10Days;

    // --- 1. DECREMENT OLD CATEGORY COUNTS ---
    if (oldDays != null) {
      if (oldDays < 0) {
        // Was expired -> becomes active (+1 active), decrement old expired category
        active = active + 1;
        final pastDays = oldDays.abs();
        if (pastDays >= 1 && pastDays <= 3) {
          expired1To3 = (expired1To3 - 1).clamp(0, expired1To3);
        } else if (pastDays >= 4 && pastDays <= 7) {
          expired4To7 = (expired4To7 - 1).clamp(0, expired4To7);
        } else if (pastDays >= 8) {
          expired8To10 = (expired8To10 - 1).clamp(0, expired8To10);
        }
      } else if (oldDays <= 10) {
        // Was expiring -> decrement old expiring category
        if (oldDays >= 0 && oldDays <= 3) {
          exp1To3 = (exp1To3 - 1).clamp(0, exp1To3);
        } else if (oldDays >= 4 && oldDays <= 6) {
          exp4To7 = (exp4To7 - 1).clamp(0, exp4To7);
        } else if (oldDays >= 7 && oldDays <= 10) {
          exp8To10 = (exp8To10 - 1).clamp(0, exp8To10);
        }
      }
    }

    // --- 2. INCREMENT NEW EXPIRING CATEGORY COUNT ---
    if (newDays != null && newDays >= 0 && newDays <= 10) {
      if (newDays >= 0 && newDays <= 3) {
        exp1To3 = exp1To3 + 1;
      } else if (newDays >= 4 && newDays <= 6) {
        exp4To7 = exp4To7 + 1;
      } else if (newDays >= 7 && newDays <= 10) {
        exp8To10 = exp8To10 + 1;
      }
    }

    state = currentState.copyWith(
      active: active,
      expiring1To3Days: exp1To3,
      expiring4To7Days: exp4To7,
      expiring8To10Days: exp8To10,
      expired1To3Days: expired1To3,
      expired4To7Days: expired4To7,
      expired8To10Days: expired8To10,
    );
  }

  void onStudentRemovedOrDeactivated(StudentModel student) {
    final currentState = state;
    if (currentState == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysLeft = _getDaysLeft(student.currentExpireDate, today);

    int active = currentState.active;
    int exp1To3 = currentState.expiring1To3Days;
    int exp4To7 = currentState.expiring4To7Days;
    int exp8To10 = currentState.expiring8To10Days;

    int expired1To3 = currentState.expired1To3Days;
    int expired4To7 = currentState.expired4To7Days;
    int expired8To10 = currentState.expired8To10Days;

    if (daysLeft != null) {
      if (daysLeft >= 0) {
        // Was Active -> decrement active count
        active = (active - 1).clamp(0, active);
        if (daysLeft >= 0 && daysLeft <= 3) {
          exp1To3 = (exp1To3 - 1).clamp(0, exp1To3);
        } else if (daysLeft >= 4 && daysLeft <= 6) {
          exp4To7 = (exp4To7 - 1).clamp(0, exp4To7);
        } else if (daysLeft >= 7 && daysLeft <= 10) {
          exp8To10 = (exp8To10 - 1).clamp(0, exp8To10);
        }
      } else {
        // Was Expired -> decrement expired count
        final pastDays = daysLeft.abs();
        if (pastDays >= 1 && pastDays <= 3) {
          expired1To3 = (expired1To3 - 1).clamp(0, expired1To3);
        } else if (pastDays >= 4 && pastDays <= 7) {
          expired4To7 = (expired4To7 - 1).clamp(0, expired4To7);
        } else if (pastDays >= 8) {
          expired8To10 = (expired8To10 - 1).clamp(0, expired8To10);
        }
      }
    }

    state = currentState.copyWith(
      active: active,
      expiring1To3Days: exp1To3,
      expiring4To7Days: exp4To7,
      expiring8To10Days: exp8To10,
      expired1To3Days: expired1To3,
      expired4To7Days: expired4To7,
      expired8To10Days: expired8To10,
    );
  }

  void onPendingAmountUpdated({
    required double oldAmount,
    required double newAmount,
  }) {
    final currentState = state;
    if (currentState == null) return;
    final double diff = newAmount - oldAmount;
    final double updated = (currentState.totalPendingAmount + diff).clamp(0.0, double.infinity);
    state = currentState.copyWith(totalPendingAmount: updated);
  }

  void clearSummary() {
    state = null;
  }
}
