import 'package:flutter/material.dart';

class Helper {
  static String formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  static Map<String, String> generateStartEndOutputs({
    required String startDate,
    required String startTime,
    required String endTime,
  }) {
    final base = DateTime.parse(startDate);

    // Build DateTime objects
    final start = DateTime(
      base.year,
      base.month,
      base.day,
      int.parse(startTime.split(":")[0]),
      int.parse(startTime.split(":")[1]),
    );

    DateTime end = DateTime(
      base.year,
      base.month,
      base.day,
      int.parse(endTime.split(":")[0]),
      int.parse(endTime.split(":")[1]),
    );

    // If end time is smaller than start time → assume next day
    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    String formatTime(DateTime t) {
      final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
      final minute = t.minute.toString().padLeft(2, "0");
      final period = t.hour >= 12 ? "PM" : "AM";
      return "$hour:$minute $period";
    }

    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    String formatOutput(DateTime dt) {
      return "${formatTime(dt)} - ${months[dt.month]} ${dt.day}";
    }

    return {"startOutput": formatOutput(start), "endOutput": formatOutput(end)};
  }

  static TimeOfDay stringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  static String capitalizeFirst(String input) {
    if (input.isNotEmpty) {
      return input.substring(0, 1).toUpperCase() + input.substring(1);
    } else {
      return '';
    }
  }

  static String formatCurrentDate() {
    final now = DateTime.now();

    final weekday = _weekdayName(now.weekday);
    final month = _monthShortName(now.month);

    return "$weekday ${now.day} $month, ${now.year}";
  }

  static String _weekdayName(int weekday) {
    const names = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return names[weekday - 1];
  }

  static String _monthShortName(int month) {
    const names = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return names[month - 1];
  }
}
