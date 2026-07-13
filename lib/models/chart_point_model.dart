import 'dart:convert';

class ChartPointModel {
  final int year;
  final int month;
  final int? day;
  final double income;

  const ChartPointModel({
    required this.year,
    required this.month,
    this.day,
    required this.income,
  });

  ChartPointModel copyWith({int? year, int? month, int? day, double? income}) {
    return ChartPointModel(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      income: income ?? this.income,
    );
  }

  Map<String, dynamic> toMap() {
    return {'year': year, 'month': month, 'day': day, 'income': income};
  }

  factory ChartPointModel.fromMap(Map<String, dynamic> map) {
    return ChartPointModel(
      year: map['year'] ?? 0,
      month: map['month'] ?? 0,
      day: map['day'],
      income: (map['income'] ?? 0).toDouble(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ChartPointModel.fromJson(String source) =>
      ChartPointModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChartPointModel(year: $year, month: $month, day: $day, income: $income)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartPointModel &&
            year == other.year &&
            month == other.month &&
            day == other.day &&
            income == other.income;
  }

  @override
  int get hashCode {
    return Object.hash(year, month, day, income);
  }
}
