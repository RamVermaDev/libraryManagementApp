import 'dart:convert';

class StudentModel {
  final String? id;

  // Ownership / booking links
  final String libraryId;
  final String slotTemplateId;
  final String? seatId;

  // Personal details
  final String name;
  final String phone;
  final String? gender;
  final String? idProof;
  final String? profileImage;

  // Membership summary
  final DateTime? joiningDate;
  final int? currentPlanDays;
  final DateTime? currentStartDate;
  final DateTime? currentExpireDate;

  // Financial summary
  final double totalPaid;
  final double totalPending;
  final double totalDiscount;
  final DateTime? lastPaymentDate;

  // Other
  final String? notes;

  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StudentModel({
    this.id,
    required this.libraryId,
    required this.slotTemplateId,
    this.seatId,
    required this.name,
    required this.phone,
    this.gender,
    this.idProof,
    this.profileImage,
    this.joiningDate,
    this.currentPlanDays,
    this.currentStartDate,
    this.currentExpireDate,
    this.totalPaid = 0,
    this.totalPending = 0,
    this.totalDiscount = 0,
    this.lastPaymentDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
    
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['_id']?.toString() ?? map['id']?.toString(),

      // libraryId/slotTemplateId/seatId can each arrive either as a plain
      // ObjectId string OR as a populated object (if the backend ever does
      // .populate() on these refs) - _parseRefId handles both shapes.
      libraryId: _parseRefId(map['libraryId']) ?? '',
      slotTemplateId: _parseRefId(map['slotTemplateId']) ?? '',
      seatId: _parseRefId(map['seatId']),

      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      gender: map['gender']?.toString(),
      idProof: map['idProof']?.toString(),
      profileImage: map['profileImage']?.toString(),

      joiningDate: _parseDate(map['joiningDate']),

      currentPlanDays: (map['currentPlanDays'] as num?)?.toInt(),
      currentStartDate: _parseDate(map['currentStartDate']),
      currentExpireDate: _parseDate(map['currentExpireDate']),

      totalPaid: (map['totalPaid'] as num?)?.toDouble() ?? 0,
      totalPending: (map['totalPending'] as num?)?.toDouble() ?? 0,
      totalDiscount: (map['totalDiscount'] as num?)?.toDouble() ?? 0,

      lastPaymentDate: _parseDate(map['lastPaymentDate']),

      notes: map['notes']?.toString(),

      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  /// Shape matching the Student schema itself - use this for displaying/
  /// editing an existing student record. NOTE: this is NOT the same shape
  /// the /addstudent endpoint expects (that request also carries
  /// startDate/expireDate/amount/discount/paidAmount/paymentMode, which
  /// belong to FeeRecord/Payment, not Student) - build that as a separate
  /// request payload when we get to the controller.
  Map<String, dynamic> toMap() {
    return {
      'libraryId': libraryId,
      'slotTemplateId': slotTemplateId,
      'seatId': seatId,
      'name': name,
      'phone': phone,
      'gender': gender,
      'idProof': idProof,
      'profileImage': profileImage,
      'joiningDate': joiningDate?.toIso8601String(),
      'currentPlanDays': currentPlanDays,
      'currentStartDate': currentStartDate?.toIso8601String(),
      'currentExpireDate': currentExpireDate?.toIso8601String(),
      'totalPaid': totalPaid,
      'totalPending': totalPending,
      'totalDiscount': totalDiscount,
      'lastPaymentDate': lastPaymentDate?.toIso8601String(),
      'notes': notes,
    };
  }

  factory StudentModel.fromJson(String source) {
    return StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  StudentModel copyWith({
    String? id,
    String? libraryId,
    String? slotTemplateId,
    String? seatId,
    String? name,
    String? phone,
    String? gender,
    String? idProof,
    String? profileImage,
    DateTime? joiningDate,
    int? currentPlanDays,
    DateTime? currentStartDate,
    DateTime? currentExpireDate,
    double? totalPaid,
    double? totalPending,
    double? totalDiscount,
    DateTime? lastPaymentDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      slotTemplateId: slotTemplateId ?? this.slotTemplateId,
      seatId: seatId ?? this.seatId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      idProof: idProof ?? this.idProof,
      profileImage: profileImage ?? this.profileImage,
      joiningDate: joiningDate ?? this.joiningDate,
      currentPlanDays: currentPlanDays ?? this.currentPlanDays,
      currentStartDate: currentStartDate ?? this.currentStartDate,
      currentExpireDate: currentExpireDate ?? this.currentExpireDate,
      totalPaid: totalPaid ?? this.totalPaid,
      totalPending: totalPending ?? this.totalPending,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String? _parseRefId(dynamic value) {
    if (value == null) return null;
    if (value is Map) return value['_id']?.toString();
    return value.toString();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
