class SeatAvailabilityModel {
  final String seatId;
  final int seatNumber;
  final String? label;
  final String status; // "available" | "booked"
  final String? bookedByStudentName;

  const SeatAvailabilityModel({
    required this.seatId,
    required this.seatNumber,
    this.label,
    required this.status,
    this.bookedByStudentName,
  });

  bool get isAvailable => status == 'available';

  /// Falls back to "A<seatNumber>" if the owner never set a custom label.
  String get displayLabel =>
      (label != null && label!.isNotEmpty) ? label! : 'A$seatNumber';

  factory SeatAvailabilityModel.fromMap(Map<String, dynamic> map) {
    final bookedBy = map['bookedBy'] as Map<String, dynamic>?;

    return SeatAvailabilityModel(
      seatId: map['seatId']?.toString() ?? '',
      seatNumber: (map['seatNumber'] as num?)?.toInt() ?? 0,
      label: map['label']?.toString(),
      status: map['status']?.toString() ?? 'available',
      bookedByStudentName: bookedBy?['studentName']?.toString(),
    );
  }
}
