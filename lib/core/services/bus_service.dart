import 'dart:convert';
import 'package:cuetbus/core/constants/api_constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BusService {
  static Future<List<Map<String, dynamic>>> getBuses() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/buses');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load buses');
    }

    final List<dynamic> data = jsonDecode(response.body);
    final now = DateTime.now();
    final displayFormat = DateFormat.jm();

    // -------- TIME PARSER ------------------------
    DateTime? parseTime(String t) {
      final formats = [
        DateFormat("h:mm a"),
        DateFormat("hh:mm a"),
        DateFormat("H:mm"),
        DateFormat("HH:mm"),
      ];

      for (var f in formats) {
        try {
          final parsed = f.parse(t);
          return DateTime(
            now.year,
            now.month,
            now.day,
            parsed.hour,
            parsed.minute,
          );
        } catch (_) {}
      }
      return null;
    }

    return data.map<Map<String, dynamic>>((bus) {
      // -------- FILTER TRIPS (KEEP ONLY VALID TIMES) --------
      final rawTrips = Map<String, dynamic>.from(bus["trips"] ?? {});
      final trips = <String, String>{};

      rawTrips.forEach((key, value) {
        final v = value.toString().trim();

        // Only accept values like "5:40 AM", "10:30 PM"
        final bool isTime = RegExp(
          r'^\d{1,2}:\d{2}(\s?[APap][Mm])?$',
        ).hasMatch(v);

        if (isTime) trips[key] = v;
      });

      // -------- AMENITIES PARSE --------
      final amenities = bus["amenities"] is String
          ? List<String>.from(jsonDecode(bus["amenities"]))
          : (bus["amenities"] ?? []);

      // -------- NEXT DEPARTURE --------
      DateTime? nextDeparture;

      for (var value in trips.values) {
        final parsed = parseTime(value);
        if (parsed == null) continue;

        if (parsed.isAfter(now) &&
            (nextDeparture == null || parsed.isBefore(nextDeparture))) {
          nextDeparture = parsed;
        }
      }

      final nextDepartureStr = nextDeparture != null
          ? displayFormat.format(nextDeparture)
          : (trips.isNotEmpty ? trips.values.first : "N/A");

      return {
        ...bus,
        "trips": trips, // ⬅️ IMPORTANT: Now trips are guaranteed valid
        "amenities": amenities,
        "time": nextDepartureStr,
        "available": bus["capacity"] ?? 0,
        "capacity": bus["capacity"] ?? 0,
        "status": "On Time",
        "favorite": false,
      };
    }).toList();
  }
}
