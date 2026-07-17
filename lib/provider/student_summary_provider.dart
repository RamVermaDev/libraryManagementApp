import 'package:flutter_riverpod/legacy.dart';
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

  void clearSummary() {
    state = null;
  }
}
