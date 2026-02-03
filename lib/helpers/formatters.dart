import 'package:intl/intl.dart';

// Formatting utilities for dates, currency, and text
// Provides consistent formatting across the app
class Formatters {
  // Private constructor to prevent instantiation
  Formatters._();

  // ============== Date Formatters ==============

  // Format date as: Jan 15, 2024
  static String dateShort(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format date as: January 15, 2024
  static String dateLong(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  // Format date as: 01/15/2024
  static String dateNumeric(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  // Format date as: 2024-01-15
  static String dateISO(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format time as: 3:30 PM
  static String timeShort(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  // Format time as: 15:30
  static String time24Hour(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  // Format datetime as: Jan 15, 2024 at 3:30 PM
  static String dateTimeShort(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy \'at\' h:mm a').format(dateTime);
  }

  // Format datetime as: January 15, 2024 at 3:30 PM
  static String dateTimeLong(DateTime dateTime) {
    return DateFormat('MMMM dd, yyyy \'at\' h:mm a').format(dateTime);
  }

  // Relative time (e.g., "2 hours ago", "Just now")
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  // ============== Number Formatters ==============

  // Format number with thousand separators: 1,234,567
  static String number(num value) {
    return NumberFormat('#,###').format(value);
  }

  // Format as currency: $1,234.56
  static String currency(num value, {String symbol = '\$'}) {
    return NumberFormat.currency(symbol: symbol, decimalDigits: 2).format(value);
  }

  // Format as percentage: 75.5%
  static String percentage(num value, {int decimals = 1}) {
    return NumberFormat.percentPattern()
        .format(value / 100)
        .replaceAll(RegExp(r'\.0+%$'), '%');
  }

  // Format file size (bytes to KB, MB, GB)
  static String fileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // ============== Text Formatters ==============

  // Capitalize first letter of each word
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  // Capitalize only first letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  // Truncate text with ellipsis
  static String truncate(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  // Format phone number: (123) 456-7890
  static String phoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return phone;
  }
}
