import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/student_state.dart';

final studentProvider = StateNotifierProvider<StudentNotifier, StudentState>((
  ref,
) {
  return StudentNotifier();
});

class StudentNotifier extends StateNotifier<StudentState> {
  StudentNotifier() : super(const StudentState());

  // =========================
  // ALL STUDENTS
  // =========================

  void setAllStudents(List<StudentModel> students) {
    state = state.copyWith(allStudents: students);
  }

  void addStudent(StudentModel student) {
    state = state.copyWith(allStudents: [student, ...state.allStudents]);
  }

  void addMoreAllStudents(List<StudentModel> students) {
    state = state.copyWith(allStudents: [...state.allStudents, ...students]);
  }

  List<StudentModel> _replaceStudentInList(
    List<StudentModel> students,
    StudentModel updatedStudent,
  ) {
    return students.map((student) {
      return student.id == updatedStudent.id ? updatedStudent : student;
    }).toList();
  }

  void updateStudent(StudentModel updatedStudent) {
    if (updatedStudent.id == null) return;

    state = state.copyWith(
      allStudents: _replaceStudentInList(state.allStudents, updatedStudent),
      activeStudents: _replaceStudentInList(
        state.activeStudents,
        updatedStudent,
      ),
      pendingStudents: _replaceStudentInList(
        state.pendingStudents,
        updatedStudent,
      ),
      expiring1To3Days: _replaceStudentInList(
        state.expiring1To3Days,
        updatedStudent,
      ),
      expiring4To7Days: _replaceStudentInList(
        state.expiring4To7Days,
        updatedStudent,
      ),
      expiring8To10Days: _replaceStudentInList(
        state.expiring8To10Days,
        updatedStudent,
      ),
      expired1To3Days: _replaceStudentInList(
        state.expired1To3Days,
        updatedStudent,
      ),
      expired4To7Days: _replaceStudentInList(
        state.expired4To7Days,
        updatedStudent,
      ),
      expired8To10Days: _replaceStudentInList(
        state.expired8To10Days,
        updatedStudent,
      ),
    );
  }

  void renewStudent(StudentModel updatedStudent) {
    if (updatedStudent.id == null) return;

    List<StudentModel> removeFrom(List<StudentModel> list) =>
        list.where((s) => s.id != updatedStudent.id).toList();

    List<StudentModel> upsertInto(List<StudentModel> list, StudentModel item) {
      final index = list.indexWhere((s) => s.id == item.id);
      if (index >= 0) {
        final copy = List<StudentModel>.from(list);
        copy[index] = item;
        return copy;
      }
      return [item, ...list];
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final rawExpire = updatedStudent.currentExpireDate?.toLocal();
    final expireDate = rawExpire != null
        ? DateTime(rawExpire.year, rawExpire.month, rawExpire.day)
        : null;
    final daysLeft =
        expireDate != null ? expireDate.difference(today).inDays : 999;

    List<StudentModel> exp1To3 = removeFrom(state.expiring1To3Days);
    List<StudentModel> exp4To7 = removeFrom(state.expiring4To7Days);
    List<StudentModel> exp8To10 = removeFrom(state.expiring8To10Days);

    if (daysLeft >= 0 && daysLeft <= 3) {
      exp1To3 = upsertInto(exp1To3, updatedStudent);
    } else if (daysLeft >= 4 && daysLeft <= 6) {
      exp4To7 = upsertInto(exp4To7, updatedStudent);
    } else if (daysLeft >= 7 && daysLeft <= 10) {
      exp8To10 = upsertInto(exp8To10, updatedStudent);
    }

    state = state.copyWith(
      allStudents: _replaceStudentInList(state.allStudents, updatedStudent),
      activeStudents: upsertInto(state.activeStudents, updatedStudent),

      // Removed from all expired lists
      expired1To3Days: removeFrom(state.expired1To3Days),
      expired4To7Days: removeFrom(state.expired4To7Days),
      expired8To10Days: removeFrom(state.expired8To10Days),

      // Expiring lists updated based on remaining days
      expiring1To3Days: exp1To3,
      expiring4To7Days: exp4To7,
      expiring8To10Days: exp8To10,
    );
  }

  // =========================
  // ACTIVE STUDENTS
  // =========================

  void setActiveStudents(List<StudentModel> students) {
    state = state.copyWith(activeStudents: students);
  }

  void addActiveStudent(StudentModel student) {
    state = state.copyWith(activeStudents: [student, ...state.activeStudents]);
  }

  void addMoreActiveStudents(List<StudentModel> students) {
    state = state.copyWith(
      activeStudents: [...state.activeStudents, ...students],
    );
  }

  //PENDING STUDENT
  void setPendingStudents(List<StudentModel> students) {
    state = state.copyWith(pendingStudents: students);
  }

  void addMorePendingStudents(List<StudentModel> students) {
    state = state.copyWith(
      pendingStudents: [...state.pendingStudents, ...students],
    );
  }

  // =========================
  // EXPIRING 1 - 3 DAYS
  // =========================

  void setExpiring1To3Days(List<StudentModel> students) {
    state = state.copyWith(expiring1To3Days: students);
  }

  void addMoreExpiring1To3Days(List<StudentModel> students) {
    state = state.copyWith(
      expiring1To3Days: [...state.expiring1To3Days, ...students],
    );
  }

  // =========================
  // EXPIRING 4 - 7 DAYS
  // =========================

  void setExpiring4To7Days(List<StudentModel> students) {
    state = state.copyWith(expiring4To7Days: students);
  }

  void addMoreExpiring4To7Days(List<StudentModel> students) {
    state = state.copyWith(
      expiring4To7Days: [...state.expiring4To7Days, ...students],
    );
  }

  // =========================
  // EXPIRING 8 - 10 DAYS
  // =========================

  void setExpiring8To10Days(List<StudentModel> students) {
    state = state.copyWith(expiring8To10Days: students);
  }

  void addMoreExpiring8To10Days(List<StudentModel> students) {
    state = state.copyWith(
      expiring8To10Days: [...state.expiring8To10Days, ...students],
    );
  }

  // =========================
  // EXPIRED 1 - 3 DAYS
  // =========================

  void setExpired1To3Days(List<StudentModel> students) {
    state = state.copyWith(expired1To3Days: students);
  }

  void addMoreExpired1To3Days(List<StudentModel> students) {
    state = state.copyWith(
      expired1To3Days: [...state.expired1To3Days, ...students],
    );
  }

  // =========================
  // EXPIRED 4 - 7 DAYS
  // =========================

  void setExpired4To7Days(List<StudentModel> students) {
    state = state.copyWith(expired4To7Days: students);
  }

  void addMoreExpired4To7Days(List<StudentModel> students) {
    state = state.copyWith(
      expired4To7Days: [...state.expired4To7Days, ...students],
    );
  }

  // =========================
  // EXPIRED 8 - 10 DAYS
  // =========================

  void setExpired8To10Days(List<StudentModel> students) {
    state = state.copyWith(expired8To10Days: students);
  }

  void addMoreExpired8To10Days(List<StudentModel> students) {
    state = state.copyWith(
      expired8To10Days: [...state.expired8To10Days, ...students],
    );
  }

  // Removes a refunded/cancelled student from all active & expiring lists
  // and updates their record in the allStudents list.
  void expireStudent(StudentModel updatedStudent) {
    if (updatedStudent.id == null) return;

    List<StudentModel> removeFrom(List<StudentModel> list) =>
        list.where((s) => s.id != updatedStudent.id).toList();

    state = state.copyWith(
      // Update the record in the full list
      allStudents: _replaceStudentInList(state.allStudents, updatedStudent),

      // Remove from active & expiring — they are no longer valid
      activeStudents: removeFrom(state.activeStudents),
      expiring1To3Days: removeFrom(state.expiring1To3Days),
      expiring4To7Days: removeFrom(state.expiring4To7Days),
      expiring8To10Days: removeFrom(state.expiring8To10Days),

      // Also remove pending (refund clears pending)
      pendingStudents: removeFrom(state.pendingStudents),

      // Keep expired lists as-is — will refresh on next fetch
    );
  }

  void clearStudents() {
    state = const StudentState();
  }

  //update student profile image
  void updateStudentPhoto({
    required String studentId,
    required String profileImage,
  }) {
    List<StudentModel> update(List<StudentModel> students) {
      return students.map((student) {
        if (student.id != studentId) return student;

        return student.copyWith(profileImage: profileImage);
      }).toList();
    }

    state = state.copyWith(
      allStudents: update(state.allStudents),
      activeStudents: update(state.activeStudents),

      expiring1To3Days: update(state.expiring1To3Days),
      expiring4To7Days: update(state.expiring4To7Days),
      expiring8To10Days: update(state.expiring8To10Days),

      expired1To3Days: update(state.expired1To3Days),
      expired4To7Days: update(state.expired4To7Days),
      expired8To10Days: update(state.expired8To10Days),

      pendingStudents: update(state.pendingStudents),
    );
  }
}
