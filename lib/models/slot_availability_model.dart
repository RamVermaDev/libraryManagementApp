class SlotAvailabilityModel {
  final String slotTemplateId;
  final String name;
  final int startMinute;
  final int endMinute;
  final double monthlyPrice;
  final int totalSeats;
  final int usedSeats;
  final int availableSeats;
  final bool isFull;
  final int extraSeatsNeededIfBookingOneMore;

  const SlotAvailabilityModel({
    required this.slotTemplateId,
    required this.name,
    required this.startMinute,
    required this.endMinute,
    required this.monthlyPrice,
    required this.totalSeats,
    required this.usedSeats,
    required this.availableSeats,
    required this.isFull,
    required this.extraSeatsNeededIfBookingOneMore,
  });

  factory SlotAvailabilityModel.fromMap(Map<String, dynamic> map) {
    return SlotAvailabilityModel(
      slotTemplateId: map['slotTemplateId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      startMinute: (map['startMinute'] as num?)?.toInt() ?? 0,
      endMinute: (map['endMinute'] as num?)?.toInt() ?? 0,
      monthlyPrice: (map['monthlyPrice'] as num?)?.toDouble() ?? 0,
      totalSeats: (map['totalSeats'] as num?)?.toInt() ?? 0,
      usedSeats: (map['usedSeats'] as num?)?.toInt() ?? 0,
      availableSeats: (map['availableSeats'] as num?)?.toInt() ?? 0,
      isFull: map['isFull'] as bool? ?? false,
      extraSeatsNeededIfBookingOneMore:
          (map['extraSeatsNeededIfBookingOneMore'] as num?)?.toInt() ?? 0,
    );
  }

  /// e.g. "6:00 AM - 12:00 PM" - built from raw minute-of-day values,
  /// so it works for ANY custom slot, not just fixed presets.
  String get formattedTime {
    return '${_formatMinutes(startMinute)} - ${_formatMinutes(endMinute)}';
  }

  /// e.g. "₹400 / month"
  String get formattedPrice {
    final int rounded = monthlyPrice.round();
    return '₹$rounded / month';
  }

  static String _formatMinutes(int totalMinutes) {
    final int wrapped = totalMinutes % 1440; // handles overnight slots >1440
    final int hour24 = wrapped ~/ 60;
    final int minute = wrapped % 60;

    final int hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final String period = hour24 >= 12 ? 'PM' : 'AM';
    final String minuteStr = minute.toString().padLeft(2, '0');

    return '$hour12:$minuteStr $period';
  }
}