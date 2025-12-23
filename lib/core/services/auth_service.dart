import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  // Signup
  Future<String> signup({
    required String name,
    required String studentId,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _api.signup(name, studentId, email, password);
      if (res.containsKey('message')) {
        return "success"; // registration succeeded
      } else if (res.containsKey('error')) {
        return res['error']; // backend error message
      } else {
        return "Unknown error occurred";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  // Login → now returns a Map with success & message
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _api.login(email, password);

      if (res.containsKey('token')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', res['token']);
        return {'success': true, 'message': 'Login successful'};
      } else if (res.containsKey('error')) {
        return {'success': false, 'message': res['error']};
      } else {
        return {'success': false, 'message': 'Unknown error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Failed to connect to server'};
    }
  }

  // Get JWT token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
