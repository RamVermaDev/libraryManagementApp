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
      year: _toInt(map['year']),
      month: _toInt(map['month']),
      day: map['day'] == null ? null : _toInt(map['day']),
      income: _toDouble(map['income']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
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
