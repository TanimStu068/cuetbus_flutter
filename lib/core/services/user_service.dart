import 'dart:convert';
import 'package:cuetbus/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:cuetbus/core/services/auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await _authService.getToken();
    print("Token: $token"); // << check if token exists
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/user/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Response code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error fetching user: ${response.body}");
      return null;
    }
  }
}
