import 'package:intl/intl.dart';

class DateFormatter {
  static String relativeOrDate(DateTime date, {String locale = 'en'}) {
    final now = DateTime.now();
    final difference = now.difference(date);

    switch (locale) {
      case 'tr':
        if (difference.inDays == 0) return 'Bugün';
        if (difference.inDays == 1) return 'Dün';
        if (difference.inDays < 7) return '${difference.inDays} gün önce';
        return DateFormat('dd/MM/yyyy', 'tr').format(date);
      default:
        if (difference.inDays == 0) return 'Today';
        if (difference.inDays == 1) return 'Yesterday';
        if (difference.inDays < 7) return '${difference.inDays} days ago';
        return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}


