import 'dart:convert';
import 'package:cuetbus/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class BusScheduleService {
  // Fetch all schedules
  static Future<List<dynamic>> getSchedules() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/schedules');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load schedules");
    }
  }

  // Fetch schedules for a specific bus
  static Future<List<dynamic>> getBusSchedules(String busNo) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/schedules/$busNo');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load bus schedules");
    }
  }
}
