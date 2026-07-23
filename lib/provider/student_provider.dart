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
      activeStudents: [...state.pendingStudents, ...students],
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
