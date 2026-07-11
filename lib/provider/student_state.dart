import 'package:library_management/models/student_model.dart';

class StudentState {
  final List<StudentModel> allStudents;
  final List<StudentModel> activeStudents;

  // Expiring
  final List<StudentModel> expiring1To3Days;
  final List<StudentModel> expiring4To7Days;
  final List<StudentModel> expiring8To10Days;

  // Expired
  final List<StudentModel> expired1To3Days;
  final List<StudentModel> expired4To7Days;
  final List<StudentModel> expired8To10Days;

  //Pending
  final List<StudentModel> pendingStudents;

  const StudentState({
    this.allStudents = const [],
    this.activeStudents = const [],
    this.expiring1To3Days = const [],
    this.expiring4To7Days = const [],
    this.expiring8To10Days = const [],
    this.expired1To3Days = const [],
    this.expired4To7Days = const [],
    this.expired8To10Days = const [],
    this.pendingStudents = const [],
  });

  StudentState copyWith({
    List<StudentModel>? allStudents,
    List<StudentModel>? activeStudents,
    List<StudentModel>? expiring1To3Days,
    List<StudentModel>? expiring4To7Days,
    List<StudentModel>? expiring8To10Days,
    List<StudentModel>? expired1To3Days,
    List<StudentModel>? expired4To7Days,
    List<StudentModel>? expired8To10Days,
    List<StudentModel>? pendingStudents,
  }) {
    return StudentState(
      allStudents: allStudents ?? this.allStudents,
      activeStudents: activeStudents ?? this.activeStudents,
      expiring1To3Days: expiring1To3Days ?? this.expiring1To3Days,
      expiring4To7Days: expiring4To7Days ?? this.expiring4To7Days,
      expiring8To10Days: expiring8To10Days ?? this.expiring8To10Days,
      expired1To3Days: expired1To3Days ?? this.expired1To3Days,
      expired4To7Days: expired4To7Days ?? this.expired4To7Days,
      expired8To10Days: expired8To10Days ?? this.expired8To10Days,
      pendingStudents: pendingStudents ?? this.pendingStudents,
    );
  }
}
