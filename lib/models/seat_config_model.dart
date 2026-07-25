class SeatConfigModel {
  final int totalSeats;
  final int availableSeats;
  final int rows;
  final int columns;
  final String prefix;
  final List<dynamic> seats;

  const SeatConfigModel({
    required this.totalSeats,
    required this.availableSeats,
    required this.rows,
    required this.columns,
    this.prefix = 'A',
    required this.seats,
  });

  int get bookedSeats =>
      totalSeats > availableSeats ? totalSeats - availableSeats : 0;

  factory SeatConfigModel.fromMap(Map<String, dynamic> map) {
    final seatsList = (map['seats'] as List<dynamic>?) ?? [];
    String detectedPrefix = 'A';

    if (map['prefix'] != null && map['prefix'].toString().trim().isNotEmpty) {
      detectedPrefix = map['prefix'].toString().trim();
    } else if (map['seatPrefix'] != null &&
        map['seatPrefix'].toString().trim().isNotEmpty) {
      detectedPrefix = map['seatPrefix'].toString().trim();
    } else if (seatsList.isNotEmpty) {
      final firstLabel = seatsList.first['label']?.toString() ?? '';
      final match = RegExp(r'^([A-Za-z]+)').firstMatch(firstLabel);
      if (match != null) {
        detectedPrefix = match.group(1)!;
      }
    }

    return SeatConfigModel(
      totalSeats: (map['totalSeats'] ?? 0) as int,
      availableSeats: (map['availableSeats'] ?? 0) as int,
      rows: (map['rows'] ?? 5) as int,
      columns: (map['columns'] ?? 10) as int,
      prefix: detectedPrefix,
      seats: seatsList,
    );
  }

  SeatConfigModel copyWith({
    int? totalSeats,
    int? availableSeats,
    int? rows,
    int? columns,
    String? prefix,
    List<dynamic>? seats,
  }) {
    return SeatConfigModel(
      totalSeats: totalSeats ?? this.totalSeats,
      availableSeats: availableSeats ?? this.availableSeats,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      prefix: prefix ?? this.prefix,
      seats: seats ?? this.seats,
    );
  }
}
