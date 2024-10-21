import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:7258/api/Authentication';

  // Register user
  Future<String> register(String email, String password) async {
    final url = Uri.parse('$baseUrl/Register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['statusMessage'];
    } else {
      throw Exception('Registration failed');
    }
  }

  // Login user
  Future<String> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/Login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return response.body; // Return the token
    } else {
      throw Exception('Login failed');
    }
  }

  // Send OTP
  Future<String> sendOTP(String email) async {
    final url = Uri.parse('$baseUrl/SendOTP?email=$email');
    final response = await http.post(url, headers: {'accept': '*/*'});

    if (response.statusCode == 200) {
      return 'OTP sent successfully to $email';
    } else {
      throw Exception('Failed to send OTP');
    }
  }

  // Verify OTP
  Future<String> verifyOTP(String email, String otp) async {
    final url = Uri.parse('$baseUrl/VerifyOTP?email=$email&otp=$otp');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'Success') {
        return 'OTP verified successfully';
      } else {
        return data['statusMessage'];
      }
    } else {
      throw Exception('Failed to verify OTP');
    }
  }

  Future<String> changePassword(
      String email, String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/ResetPassword');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return 'Password reset successfully';
    } else {
      throw Exception('Failed to reset password');
    }
  }

  Future<Map<String, dynamic>> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token =
        prefs.getString('auth_token'); // Retrieve the saved token

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:7258/api/ApplicationUsers/GetUserProfile'),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token', // Use the saved token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user information');
    }
  }

  Future<String> updateUserInformation(Map<String, dynamic> updatedUserInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token'); // Retrieve the saved token

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('http://10.0.2.2:7258/api/ApplicationUsers/UpdateUserProfile');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the token
      },
      body: jsonEncode(updatedUserInfo),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['statusMessage']; // Return status message from response
    } else {
      throw Exception('Failed to update user information');
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/Logout');
    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Remove token from shared preferences
      await prefs.remove('auth_token');
    } else {
      throw Exception('Logout failed');
    }
  }
}
