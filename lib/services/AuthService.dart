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
    } else if (response.statusCode == 400) {

      // Parse lỗi và trả về lỗi cụ thể
      final Map<String, dynamic> errorData = json.decode(response.body);

      if (errorData['status'] == 'False' && errorData['statusMessage'] == 'Email already exists') {
        throw Exception('Email already exists');
      }

      final errors = errorData['errors'];
      if (errors != null) {

        if (errors['Email'] != null) {
          throw Exception('Email không đúng định dạng');
        } else if (errors['Password'] != null) {
          throw Exception('Password có độ dài từ 8 - 16 kí tự, có chữ cái in hoa, kí tự đặc biệt, chữ số');
        }
      }
      throw Exception('Registration failed');
    } else {
      throw Exception('${response.statusCode}');
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
      // Đăng nhập thành công, trả về token hoặc thông tin khác
      return response.body;
    } else if (response.statusCode == 400) {
      // Parse lỗi trả về từ API với status 500
      final Map<String, dynamic> errorData = json.decode(response.body);


      if (errorData['status'] == 'Error' && errorData['statusMessage'] == "User doesn't exist") {
        throw Exception('User does not exist');
      }
      if (errorData['status'] == 'Error' && errorData['statusMessage'] == "Invalid password") {
        throw Exception('Password có độ dài từ 8 - 16 kí tự, có chữ cái in hoa, kí tự đặc biệt, chữ số');
      }

      // Xử lý các lỗi khác nếu có
      throw Exception('Internal Server Error');
    } else {
      // Xử lý các mã lỗi khác
      throw Exception('Login failed with status code: ${response.statusCode}');
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

  Future<String> changePasswordUser(String currentPassword, String newPassword, String confirmPassword) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/ChangePassword');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['statusMessage']; // Return status message from response
    } else {
      throw Exception('Failed to change password');
    }
  }
}
