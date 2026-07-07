import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/student_model.dart';

final studentProvider =
    StateNotifierProvider<StudentNotifier, List<StudentModel>>((ref) {
      return StudentNotifier();
    });

class StudentNotifier extends StateNotifier<List<StudentModel>> {
  StudentNotifier() : super([]);

  // Set all students after fetching from backend
  void setStudents(List<StudentModel> students) {
    state = students;
  }

  void addStudents(List<StudentModel> students) {
    state = [...state, ...students];
  }

  // Add one newly created student
  void addStudent(StudentModel student) {
    state = [student, ...state];
  }

  // Update one student
  void updateStudent(StudentModel updatedStudent) {
    state = [
      for (final student in state)
        if (student.id == updatedStudent.id) updatedStudent else student,
    ];
  }

  // Delete one student
  void deleteStudent(String studentId) {
    state = state.where((student) => student.id != studentId).toList();
  }

  // Clear all students
  void clearStudents() {
    state = [];
  }
}
