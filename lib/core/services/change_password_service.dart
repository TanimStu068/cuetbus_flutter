import 'dart:convert';
import 'package:cuetbus/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  static Future<Map<String, dynamic>> changePassword({
    required String studentId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse(
        "${ApiConstants.baseUrl}/auth/change-password/change-password",
      );

      final response = await http
          .put(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "studentId": studentId,
              "oldPassword": oldPassword,
              "newPassword": newPassword,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "message":
              "Server returned status ${response.statusCode}: ${response.body}",
        };
      }
    } catch (e) {
      return {"message": "Failed to connect to server: $e"};
    }
  }
}
