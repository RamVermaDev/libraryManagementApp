import 'dart:convert';

class StudentSummaryModel {
  final int active;

  final int expiring1To3Days;
  final int expiring4To7Days;
  final int expiring8To10Days;

  final int expired1To3Days;
  final int expired4To7Days;
  final int expired8To10Days;

  const StudentSummaryModel({
    this.active = 0,
    this.expiring1To3Days = 0,
    this.expiring4To7Days = 0,
    this.expiring8To10Days = 0,
    this.expired1To3Days = 0,
    this.expired4To7Days = 0,
    this.expired8To10Days = 0,
  });

  factory StudentSummaryModel.fromMap(Map<String, dynamic> map) {
    return StudentSummaryModel(
      active: map['active'] ?? 0,

      expiring1To3Days: map['expiring']?['days1To3'] ?? 0,

      expiring4To7Days: map['expiring']?['days4To7'] ?? 0,

      expiring8To10Days: map['expiring']?['days8To10'] ?? 0,

      expired1To3Days: map['expired']?['days1To3'] ?? 0,

      expired4To7Days: map['expired']?['days4To7'] ?? 0,

      expired8To10Days: map['expired']?['days8To10'] ?? 0,
    );
  }

  factory StudentSummaryModel.fromJson(String source) {
    return StudentSummaryModel.fromMap(jsonDecode(source));
  }

  StudentSummaryModel copyWith({
    int? active,
    int? expiring1To3Days,
    int? expiring4To7Days,
    int? expiring8To10Days,
    int? expired1To3Days,
    int? expired4To7Days,
    int? expired8To10Days,
  }) {
    return StudentSummaryModel(
      active: active ?? this.active,
      expiring1To3Days: expiring1To3Days ?? this.expiring1To3Days,
      expiring4To7Days: expiring4To7Days ?? this.expiring4To7Days,
      expiring8To10Days: expiring8To10Days ?? this.expiring8To10Days,
      expired1To3Days: expired1To3Days ?? this.expired1To3Days,
      expired4To7Days: expired4To7Days ?? this.expired4To7Days,
      expired8To10Days: expired8To10Days ?? this.expired8To10Days,
    );
  }
}
