import 'dart:convert';

class LibraryModel {
  final String? id;
  final String? ownerId;
  final String libraryName;
  final String tagLine;
  final String whatsappNumber;
  final String city;
  final String state;
  final String pinCode;
  final int totalStudents;
  final int totalSeats;
  final int availableSeats;
  final String status;

  const LibraryModel({
    this.id,
    this.ownerId,
    required this.libraryName,
    required this.tagLine,
    required this.whatsappNumber,
    required this.city,
    required this.state,
    required this.pinCode,
    this.totalStudents = 0,
    this.totalSeats = 0,
    this.availableSeats = 0,
    this.status = "active",
  });

  factory LibraryModel.fromMap(Map<String, dynamic> map) {
    return LibraryModel(
      id: map['_id'],
      ownerId: map['ownerId'],
      libraryName: map['libraryName'] ?? '',
      tagLine: map['tagLine'] ?? '',
      whatsappNumber: map['whatsappNumber'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pinCode: map['pinCode'] ?? '',
      totalStudents: map['totalStudents'] ?? 0,
      totalSeats: map['totalSeats'] ?? 0,
      availableSeats: map['availableSeats'] ?? 0,
      status: map['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'libraryName': libraryName,
      'tagLine': tagLine,
      'whatsappNumber': whatsappNumber,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'totalStudents': totalStudents,
      'totalSeats': totalSeats,
    };
  }

  factory LibraryModel.fromJson(String source) =>
      LibraryModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
