import 'dart:convert';

class ExpenseModel {
  final String? id;
  final String libraryId;
  final String title;
  final double amount;
  final String category;
  final DateTime expenseDate;
  final String description;

  const ExpenseModel({
    this.id,
    required this.libraryId,
    required this.title,
    required this.amount,
    required this.category,
    required this.expenseDate,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'libraryId': libraryId,
      'title': title,
      'amount': amount,
      'category': category,
      'expenseDate': _formatDateForApi(expenseDate),
      'description': description,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    final library = map['libraryId'];

    return ExpenseModel(
      id: map['_id']?.toString() ?? map['id']?.toString(),
      libraryId: library is Map
          ? library['_id'].toString()
          : library.toString(),
      title: map['title']?.toString() ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      category: map['category']?.toString() ?? '',
      expenseDate: DateTime.parse(map['expenseDate'].toString()),
      description: map['description']?.toString() ?? '',
    );
  }

  factory ExpenseModel.fromJson(String source) {
    return ExpenseModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }

  ExpenseModel copyWith({
    String? id,
    String? libraryId,
    String? title,
    double? amount,
    String? category,
    DateTime? expenseDate,
    String? description,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      expenseDate: expenseDate ?? this.expenseDate,
      description: description ?? this.description,
    );
  }

  static String _formatDateForApi(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
