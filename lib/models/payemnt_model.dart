import 'dart:convert';

class PaymentModel {
  final String? id;

  /// Relationships
  final String libraryId;
  final String studentId;
  final String feeRecordId;

  /// Payment Details
  final double amount;
  final String paymentMode;
  final DateTime paymentDate;
  final String tracker;

  /// Optional
  final String? transactionReference;
  final String? note;

  const PaymentModel({
    this.id,
    required this.libraryId,
    required this.studentId,
    required this.feeRecordId,
    required this.amount,
    required this.paymentMode,
    required this.paymentDate,
    this.tracker = 'credit',
    this.transactionReference,
    this.note,
  });

  PaymentModel copyWith({
    String? id,
    String? libraryId,
    String? studentId,
    String? feeRecordId,
    double? amount,
    String? paymentMode,
    DateTime? paymentDate,
    String? tracker,
    String? transactionReference,
    String? note,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      studentId: studentId ?? this.studentId,
      feeRecordId: feeRecordId ?? this.feeRecordId,
      amount: amount ?? this.amount,
      paymentMode: paymentMode ?? this.paymentMode,
      paymentDate: paymentDate ?? this.paymentDate,
      tracker: tracker ?? this.tracker,
      transactionReference: transactionReference ?? this.transactionReference,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'library': libraryId,
      'student': studentId,
      'feeRecord': feeRecordId,
      'amount': amount,
      'paymentMode': paymentMode,
      'paymentDate': paymentDate.toIso8601String(),
      'tracker': tracker,
      'transactionReference': transactionReference,
      'note': note,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    final student = map['student'];

    return PaymentModel(
      id: map['_id']?.toString(),

      libraryId: map['library'] is Map
          ? map['library']['_id'].toString()
          : map['library'].toString(),

      studentId: student is Map
          ? student['_id'].toString()
          : student.toString(),

      feeRecordId: map['feeRecord'] is Map
          ? map['feeRecord']['_id'].toString()
          : map['feeRecord'].toString(),

      amount: (map['amount'] ?? 0).toDouble(),

      paymentMode: map['paymentMode']?.toString() ?? '',

      paymentDate: DateTime.parse(map['paymentDate'].toString()).toLocal(),

      tracker: map['tracker']?.toString() ?? 'credit',

      transactionReference: map['transactionReference']?.toString(),

      note: map['note']?.toString(),
    );
  }

  factory PaymentModel.fromJson(String source) {
    return PaymentModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
