import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cuetbus/core/constants/api_constants.dart';

class AccountDeleteService {
  /// Deletes a user account by studentId
  /// Returns a map with "message" key from backend
  static Future<Map<String, dynamic>> deleteAccount({
    required String studentId,
  }) async {
    try {
      final url = Uri.parse(
        "${ApiConstants.baseUrl}/auth/delete-account/delete-account",
      );

      final response = await http
          .delete(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"studentId": studentId}),
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
