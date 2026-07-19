import 'dart:convert';

class SlotModel {
  final String? id;
  final String? libraryId;
  final String name;
  final double monthlyPrice;
  final int startMinute;
  final int endMinute;
  final bool isActive;

  const SlotModel({
    this.id,
    this.libraryId,
    required this.name,
    required this.monthlyPrice,
    required this.startMinute,
    required this.endMinute,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'monthlyPrice': monthlyPrice,
      'startMinute': startMinute,
      'endMinute': endMinute,
      'isActive': isActive,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory SlotModel.fromMap(Map<String, dynamic> map) {
    final library = map['libraryId'];

    return SlotModel(
      id: map['_id']?.toString() ?? map['id']?.toString(),
      libraryId: library is Map
          ? library['_id'].toString()
          : library.toString(),
      name: map['name']?.toString() ?? '',
      monthlyPrice: (map['monthlyPrice'] as num?)?.toDouble() ?? 0,
      startMinute: (map['startMinute'] as num?)?.toInt() ?? 0,
      endMinute: (map['endMinute'] as num?)?.toInt() ?? 0,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  factory SlotModel.fromJson(String source) {
    return SlotModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }

  SlotModel copyWith({
    String? id,
    String? libraryId,
    String? name,
    double? monthlyPrice,
    int? startMinute,
    int? endMinute,
    bool? isActive,
  }) {
    return SlotModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      name: name ?? this.name,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      isActive: isActive ?? this.isActive,
    );
  }
}
