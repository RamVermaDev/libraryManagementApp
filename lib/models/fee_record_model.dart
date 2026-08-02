class FeeRecordModel {
  final String? id;
  final String libraryId;
  final String studentId;
  final String slotId;
  final int planDays;
  final DateTime startDate;
  final DateTime expireDate;
  final double amount;
  final double discount;
  final double finalAmount;
  final double paidAmount;
  final double pendingAmount;
  final String? notes;
  final DateTime? createdAt;

  const FeeRecordModel({
    this.id,
    required this.libraryId,
    required this.studentId,
    required this.slotId,
    required this.planDays,
    required this.startDate,
    required this.expireDate,
    required this.amount,
    this.discount = 0,
    required this.finalAmount,
    required this.paidAmount,
    required this.pendingAmount,
    this.notes,
    this.createdAt,
  });

  factory FeeRecordModel.fromMap(Map<String, dynamic> map) {
    return FeeRecordModel(
      id: map['_id']?.toString() ?? map['id']?.toString(),
      libraryId: map['libraryId']?.toString() ?? '',
      studentId: map['studentId']?.toString() ?? '',
      slotId: map['slotId']?.toString() ?? '',
      planDays: (map['planDays'] as num?)?.toInt() ?? 0,
      startDate: _parseDate(map['startDate']) ?? DateTime.now(),
      expireDate: _parseDate(map['expireDate']) ?? DateTime.now(),
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      finalAmount: (map['finalAmount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (map['paidAmount'] as num?)?.toDouble() ?? 0.0,
      pendingAmount: (map['pendingAmount'] as num?)?.toDouble() ?? 0.0,
      notes: map['notes']?.toString(),
      createdAt: _parseDate(map['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic val) {
    if (val == null) return null;
    if (val is DateTime) return val;
    return DateTime.tryParse(val.toString())?.toLocal();
  }
}
