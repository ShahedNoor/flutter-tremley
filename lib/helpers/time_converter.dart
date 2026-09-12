import 'package:intl/intl.dart';

class TimeConverter {
  /// Parses any UTC date string from API (with or without 'Z') and converts to device local time
  static DateTime? parseUtc(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    String raw = dateStr.trim();
    try {
      if (raw.endsWith('Z') ||
          raw.contains('+') ||
          RegExp(r'-\d{2}:\d{2}$').hasMatch(raw)) {
        return DateTime.parse(raw).toLocal();
      }
      if (raw.contains(' ') || raw.contains('T')) {
        final formatted = '${raw.replaceAll(' ', 'T')}Z';
        return DateTime.parse(formatted).toLocal();
      }
      return DateTime.parse(raw).toLocal();
    } catch (e) {
      try {
        return DateTime.parse(dateStr).toLocal();
      } catch (_) {
        return null;
      }
    }
  }

  /// Formats UTC date string to 24-hour HH:mm in local time
  static String formatTo24HourTime(String? dateStr) {
    final date = parseUtc(dateStr);
    if (date == null) return "";
    return DateFormat('HH:mm').format(date);
  }

  static String timeAgoFR(String? utcTime) {
    if (utcTime == null || utcTime.isEmpty) return "À l'instant";
    DateTime? date = parseUtc(utcTime);
    if (date == null) return utcTime;

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 1) {
      return "Il y a ${difference.inDays} jours";
    } else if (difference.inDays == 1) {
      return "Hier";
    } else if (difference.inHours >= 1) {
      return "Il y a ${difference.inHours} h";
    } else if (difference.inMinutes >= 1) {
      return "Il y a ${difference.inMinutes} min";
    } else {
      return "À l'instant";
    }
  }
}

