class ChartFormatter {
  static final _rupee = String.fromCharCode(0x20B9);

  static String currency(num value) {
    final formatted = value.round().toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );

    return '$_rupee$formatted';
  }

  static String compact(num value) {
    if (value >= 100000) {
      return '$_rupee${(value / 100000).toStringAsFixed(1)}L';
    }

    if (value >= 1000) {
      return '$_rupee${(value / 1000).toStringAsFixed(1)}K';
    }

    return currency(value);
  }
}
