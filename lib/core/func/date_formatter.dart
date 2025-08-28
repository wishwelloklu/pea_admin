import 'package:intl/intl.dart';

String formatSmartDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final inputDate = DateTime(date.year, date.month, date.day);

  if (inputDate == today) {
    return "Today";
  } else if (inputDate == yesterday) {
    return "Yesterday";
  } else if (inputDate.isAfter(today.subtract(const Duration(days: 7)))) {
    // Within the past week
    return DateFormat('EEEE').format(date); // e.g., Monday
  } else {
    // Older
    return DateFormat('MMMM d, y').format(date); // e.g., August 11, 2025
  }
}
