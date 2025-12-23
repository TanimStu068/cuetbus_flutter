import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

part 'booking_model.g.dart';

@HiveType(typeId: 0)
class Booking extends HiveObject {
  @HiveField(0)
  String busNo;

  @HiveField(1)
  String route; // new field

  @HiveField(2)
  String tripTime;

  @HiveField(3)
  List<int> seats;

  @HiveField(4)
  DateTime bookingDate;

  Booking({
    required this.busNo,
    required this.route,
    required this.tripTime,
    required this.seats,
    required this.bookingDate,
  });
}

extension BookingExtension on Booking {
  bool get isUpcoming {
    final now = DateTime.now();

    // 1. Parse the trip time (String -> TimeOfDay)
    final time = _parseTime(tripTime);

    // 2. Combine bookingDate + time into ONE DateTime
    final bookingDateTime = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      time.hour,
      time.minute,
    );

    // 3. Now compare the FULL datetime
    return bookingDateTime.isAfter(now);
  }
}

/// Helper to convert "1:45 PM" → TimeOfDay(13, 45)
TimeOfDay _parseTime(String input) {
  // If the string contains commas, assume the time is after the last comma
  String timeStr = input.contains(',')
      ? input.split(',').last.trim()
      : input.trim();

  final formats = [DateFormat("h:mm a"), DateFormat("hh:mm a")];

  for (final f in formats) {
    try {
      final dt = f.parse(timeStr);
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {}
  }

  // If it still fails, fallback to a default time (optional)
  print("⚠️ Warning: Invalid tripTime format: $input");
  return const TimeOfDay(hour: 0, minute: 0);
}
