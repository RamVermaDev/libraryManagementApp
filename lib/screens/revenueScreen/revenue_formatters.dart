class CurrencyFormatter {
  static String format(double amount, {bool signed = false}) {
    final value = amount.round().abs();
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    final sign = amount < 0
        ? '-'
        : signed && amount > 0
        ? '+'
        : '';
    return '$sign${String.fromCharCode(0x20B9)}$formatted';
  }
}

class DateFormatter {
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const _fullMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String shortMonth(int month) => _months[month - 1];
  static String shortMonthYear(DateTime date) =>
      '${shortMonth(date.month)} ${date.year % 100}';
  static String fullMonth(DateTime date) =>
      '${_fullMonths[date.month - 1]} ${date.year}';
  static String shortDate(DateTime date) =>
      '${date.day} ${shortMonth(date.month)}';

  static String paymentDate(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final displayHour = hour == 0 ? 12 : hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${shortDate(date)}, $displayHour:$minute $period';
  }
}
