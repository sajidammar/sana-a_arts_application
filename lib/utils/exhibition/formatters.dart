import 'package:intl/intl.dart';

class Formatters {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd', 'ar').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy/MM/dd - hh:mm a', 'ar').format(date);
  }

  static String formatCurrency(double amount, {String currency = '\$'}) {
    final formatter = NumberFormat('#,##0.00', 'ar');
    return '$currency${formatter.format(amount)}';
  }

  static String formatNumber(int number) {
    return NumberFormat('#,##0', 'ar').format(number);
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes بايت';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} كيلوبايت';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} ميجابايت';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} جيجابايت';
    }
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hoursس $minutesد $secondsث';
    } else if (minutes > 0) {
      return '$minutesد $secondsث';
    } else {
      return '$secondsث';
    }
  }
}