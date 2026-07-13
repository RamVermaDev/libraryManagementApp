import 'dart:convert';

class PaymentModel {
  final String? id;

  /// Relationships
  final String libraryId;
  final String studentId;
  final String feeRecordId;

  /// Revenue Screen (only available when backend populates student)
  final String? studentName;
  final String? memberId;

  /// Payment Details
  final double amount;
  final String paymentMode;
  final DateTime paymentDate;

  /// Optional
  final String? transactionReference;
  final String? note;

  const PaymentModel({
    this.id,
    required this.libraryId,
    required this.studentId,
    required this.feeRecordId,
    this.studentName,
    this.memberId,
    required this.amount,
    required this.paymentMode,
    required this.paymentDate,
    this.transactionReference,
    this.note,
  });

  PaymentModel copyWith({
    String? id,
    String? libraryId,
    String? studentId,
    String? feeRecordId,
    String? studentName,
    String? memberId,
    double? amount,
    String? paymentMode,
    DateTime? paymentDate,
    String? transactionReference,
    String? note,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      studentId: studentId ?? this.studentId,
      feeRecordId: feeRecordId ?? this.feeRecordId,
      studentName: studentName ?? this.studentName,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      paymentMode: paymentMode ?? this.paymentMode,
      paymentDate: paymentDate ?? this.paymentDate,
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

      studentName: student is Map ? student['name']?.toString() : null,

      memberId: student is Map ? student['memberId']?.toString() : null,

      amount: (map['amount'] ?? 0).toDouble(),

      paymentMode: map['paymentMode']?.toString() ?? '',

      paymentDate: DateTime.parse(map['paymentDate'].toString()).toLocal(),

      transactionReference: map['transactionReference']?.toString(),

      note: map['note']?.toString(),
    );
  }

  factory PaymentModel.fromJson(String source) {
    return PaymentModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
