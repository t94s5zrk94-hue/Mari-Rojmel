class MonthService {
  MonthService._();

  static final MonthService instance = MonthService._();

  static const List<String> monthNames = [
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

  String format(DateTime date) {
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  DateTime previousMonth(DateTime date) {
    return DateTime(date.year, date.month - 1);
  }

  DateTime nextMonth(DateTime date) {
    return DateTime(date.year, date.month + 1);
  }

  bool isCurrentMonth(DateTime date) {
    final now = DateTime.now();

    return now.year == date.year &&
        now.month == date.month;
  }

  DateTime firstDay(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime lastDay(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }
}