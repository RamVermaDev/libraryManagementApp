import 'dart:convert';

class StudentModel {
  final String? id;
  final String libraryId;

  // Personal details
  final String name;
  final String phone;
  final String? idProof;

  // Membership summary
  final DateTime? joiningDate;
  final String currentPlan;
  final int? currentProgramDays;
  final DateTime? currentStartDate;
  final DateTime? currentExpireDate;

  // Financial summary
  final double totalPaid;
  final double totalPending;
  final DateTime? lastPaymentDate;

  // Other
  final String? notes;

  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StudentModel({
    this.id,
    required this.libraryId,
    required this.name,
    required this.phone,
    this.idProof,
    this.joiningDate,
    required this.currentPlan,
    this.currentProgramDays,
    this.currentStartDate,
    this.currentExpireDate,
    this.totalPaid = 0,
    this.totalPending = 0,
    this.lastPaymentDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    final library = map['library'];

    return StudentModel(
      id: map['_id'] ?? map['id'],

      // Handles both:
      // "library": "objectId"
      // and populated "library": {"_id": "objectId"}
      libraryId: library is Map
          ? library['_id']?.toString() ?? ''
          : library?.toString() ?? '',

      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      idProof: map['idProof'],

      joiningDate: _parseDate(map['joiningDate']),

      currentPlan: map['currentPlan'] ?? '',
      currentProgramDays: map['currentProgramDays'],

      currentStartDate: _parseDate(map['currentStartDate']),
      currentExpireDate: _parseDate(map['currentExpireDate']),

      totalPaid: (map['totalPaid'] ?? 0).toDouble(),
      totalPending: (map['totalPending'] ?? 0).toDouble(),

      lastPaymentDate: _parseDate(map['lastPaymentDate']),

      notes: map['notes'],

      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'library': libraryId,
      'name': name,
      'phone': phone,
      'idProof': idProof,
      'joiningDate': joiningDate?.toIso8601String(),
      'currentPlan': currentPlan,
      'currentProgramDays': currentProgramDays,
      'currentStartDate': currentStartDate?.toIso8601String(),
      'currentExpireDate': currentExpireDate?.toIso8601String(),
      'totalPaid': totalPaid,
      'totalPending': totalPending,
      'lastPaymentDate': lastPaymentDate?.toIso8601String(),
      'notes': notes,
    };
  }

  factory StudentModel.fromJson(String source) {
    return StudentModel.fromMap(json.decode(source));
  }

  String toJson() {
    return json.encode(toMap());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}
