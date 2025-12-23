// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cuetbus/core/constants/api_constants.dart';

class ApiService {
  // Replace with your backend URL:
  // - Android emulator: 10.0.2.2
  // - iOS simulator: localhost
  // - Physical device: use your PC's local IP

  // Signup API
  Future<Map<String, dynamic>> signup(
    String name,
    String studentId,
    String email,
    String password,
  ) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'student_id': studentId,
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  // Login API
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  // Optional: test route
  Future<Map<String, dynamic>> testServer() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/test');
    final response = await http.get(url);
    return jsonDecode(response.body);
  }
}
