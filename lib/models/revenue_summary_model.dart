import 'dart:convert';

class RevenueSummaryModel {
  final double todayIncome;
  final double monthlyIncome;
  final double yearlyIncome;
  final double allTimeIncome;

  const RevenueSummaryModel({
    required this.todayIncome,
    required this.monthlyIncome,
    required this.yearlyIncome,
    required this.allTimeIncome,
  });

  RevenueSummaryModel copyWith({
    double? todayIncome,
    double? monthlyIncome,
    double? yearlyIncome,
    double? allTimeIncome,
  }) {
    return RevenueSummaryModel(
      todayIncome: todayIncome ?? this.todayIncome,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      yearlyIncome: yearlyIncome ?? this.yearlyIncome,
      allTimeIncome: allTimeIncome ?? this.allTimeIncome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todayIncome': todayIncome,
      'monthlyIncome': monthlyIncome,
      'yearlyIncome': yearlyIncome,
      'allTimeIncome': allTimeIncome,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory RevenueSummaryModel.fromMap(Map<String, dynamic> map) {
    return RevenueSummaryModel(
      todayIncome: (map['todayIncome'] ?? 0).toDouble(),
      monthlyIncome: (map['monthlyIncome'] ?? 0).toDouble(),
      yearlyIncome: (map['yearlyIncome'] ?? 0).toDouble(),
      allTimeIncome: (map['allTimeIncome'] ?? 0).toDouble(),
    );
  }

  

  factory RevenueSummaryModel.fromJson(String source) =>
      RevenueSummaryModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RevenueSummaryModel(todayIncome: $todayIncome, monthlyIncome: $monthlyIncome, yearlyIncome: $yearlyIncome, allTimeIncome: $allTimeIncome)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RevenueSummaryModel &&
            todayIncome == other.todayIncome &&
            monthlyIncome == other.monthlyIncome &&
            yearlyIncome == other.yearlyIncome &&
            allTimeIncome == other.allTimeIncome;
  }

  @override
  int get hashCode {
    return Object.hash(todayIncome, monthlyIncome, yearlyIncome, allTimeIncome);
  }
}
