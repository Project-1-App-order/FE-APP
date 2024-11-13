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
      final String userId = data['userId'];
      if (userId != null) {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userId", userId); // Lưu orderId vào SharedPreferences
      }
      try {
        print("Đã tạo qua " + userId);
        // Cố gắng tạo giỏ hàng cho người dùng mới đăng ký
        await _createCartForUser(userId);
      } catch (e) {
        return 'Đăng ký thành công, nhưng tạo giỏ hàng thất bại: $e!';
      }

      return data['userId'];
    } else if (response.statusCode == 400) {

      // Parse lỗi và trả về lỗi cụ thể
      final Map<String, dynamic> errorData = json.decode(response.body);

      if (errorData['status'] == 'False' && errorData['statusMessage'] == 'Email already exists') {
        throw Exception('Email đã tồn tại ! Hãy sử dụng email khác!').toString().replaceAll('Exception: ', '');
      }

      final errors = errorData['errors'];
      if (errors != null) {
        if (errors['Email'] != null) {
          if(errors['Email'][0] == "Emtpy email"){  // Cập nhật lỗi chính xác
            throw Exception('Email rỗng ! Hãy nhập email của bạn!').toString().replaceAll('Exception: ', '');
          }

          if(errors['Email'][0] == "Email invalid"){
            throw Exception('Email không đúng định dạng!').toString().replaceAll('Exception: ', '');
          }
        } else if (errors['Password'] != null) {
          if(errors['Password'][0] == "Empty Password"){
            throw Exception('Password rỗng ! Hãy nhập password của bạn!').toString().replaceAll('Exception: ', '');
          }
          if(errors['Password'][0] == "invalid format"){
            throw Exception('Password có độ dài từ 8 - 16 kí tự, có chữ cái in hoa, kí tự đặc biệt, chữ số !').toString().replaceAll('Exception: ', '');
          }
        }
      }

      throw Exception('Đăng ký người dùng lỗi !').toString().replaceAll('Exception: ', '');
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

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response.body);

      // Đăng nhập thành công, trả về token hoặc thông tin khác
      String? orderId = await fetchCart();

       // Save the token

      if (orderId != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("orderId", orderId); // Lưu orderId vào SharedPreferences
      }

      return response.body;
    } else if (response.statusCode == 400) {
      // Parse lỗi trả về từ API với status 500
      final Map<String, dynamic> errorData = json.decode(response.body);

      final errors = errorData['errors'];

      if (errors != null) {
        if (errors['Email'] != null) {
          if(errors['Email'][0] == "Emtpy email"){  // Cập nhật lỗi chính xác
            throw Exception('Email rỗng ! Hãy nhập email của bạn').toString().replaceAll('Exception: ', '');
          }
          if(errors['Email'][0] == "Email invalid"){
            throw Exception('Email không đúng định dạng').toString().replaceAll('Exception: ', '');
          }
        } else if (errors['Password'] != null) {
          if(errors['Password'][0] == "Emtpy Password"){
            throw Exception('Password rỗng ! Hãy nhập password của bạn').toString().replaceAll('Exception: ', '');
          }
          if(errors['Password'][0] == "invalid format"){
            throw Exception('Password có độ dài từ 8 - 16 kí tự, có chữ cái in hoa, kí tự đặc biệt, chữ số').toString().replaceAll('Exception: ', '');
          }
        }
      }

      if (errorData['status'] == 'Error' && errorData['statusMessage'] == "User doesn't exist") {
        throw Exception('Người dùng chưa tồn tại!').toString().replaceAll('Exception: ', '');
      }
      if (errorData['status'] == 'Error' && errorData['statusMessage'] == "Invalid password") {
        throw Exception('Mật khẩu sai ! Hãy nhập lại mật khẩu').toString().replaceAll('Exception: ', '');
      }

      // Xử lý các lỗi khác nếu có
      throw Exception('Lỗi Máy Chủ Nội Bộ').toString().replaceAll('Exception: ', '');
    } else {
      // Xử lý các mã lỗi khác
      throw Exception('Login failed with status code: ${response.statusCode}').toString().replaceAll('Exception: ', '');
    }
  }


  // Send OTP
  Future<String> sendOTP(String email) async {
    final url = Uri.parse('$baseUrl/SendOTP?email=$email');
    final response = await http.post(url, headers: {'accept': '*/*'});

    if (response.statusCode == 200) {
      return 'OTP gửi thành công đến $email';
    } else {
      throw Exception('Gửi OTP thất bại !').toString().replaceAll('Exception: ', '');
    }
  }

  // Verify OTP
  Future<String> verifyOTP(String email, String otp) async {
    final url = Uri.parse('$baseUrl/VerifyOTP?email=$email&otp=$otp');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'Success') {
        return 'Xác minh OTP thành công !';
      } else {
        return data['statusMessage'];
      }
    } else {
      throw Exception('Xác minh OTP thất bại!').toString().replaceAll('Exception: ', '');
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
      return 'Đặt lại mật khẩu thành công!';
    } else {
      throw Exception('Lỗi đặt lại mật khẩu!').toString().replaceAll('Exception: ', '');
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
      throw Exception('Lỗi tải dữ người dùng!').toString().replaceAll('Exception: ', '');
    }
  }

  Future<String> updateUserInformation(Map<String, dynamic> updatedUserInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token'); // Retrieve the saved token

    if (token == null) {
      throw Exception('No token found').toString().replaceAll('Exception: ', '');
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

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      return data['statusMessage']; // Return status message from response
    } else if(response.statusCode == 400) {
      final error = data['errors'];
      if(error['PhoneNumber'] != null){
        throw Exception("Số điện thoại không đúng định dạng ! Số điện thoại có đầu số : 03, 05, 07, 08,09 và phải có 10 chữ số").toString().replaceAll('Exception: ', '');
      }
      if(error['Address'] != null){
        throw Exception("Địa chỉ không được có kí tự đặc biệt").toString().replaceAll('Exception: ', '');
      }
      else{
        throw Exception("Chỉnh sửa thông tin người dùng thất bại").toString().replaceAll('Exception: ', '');
      }

    }else {
      throw Exception('Lỗi cập nhật thông tin người dùng ! Hãy kiếm tra lại !').toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No token found').toString().replaceAll('Exception: ', '');
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
      throw Exception('Đăng xuất thất bại!').toString().replaceAll('Exception: ', '');
    }
  }

  Future<String> changePasswordUser(String currentPassword, String newPassword, String confirmPassword) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Không tìm thấy token!').toString().replaceAll('Exception: ', '');
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
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      return data['statusMessage']; // Return status message from response
    }else if(response.statusCode == 400) {
      final error = data['errors'];
      if(error['NewPassword'] != null){
        throw Exception("Mật khẩu mới không hợp lệ!").toString().replaceAll('Exception: ', '');
      }else{
        throw Exception("Đổi mật khẩu thất bại !").toString().replaceAll('Exception: ', '');
      }
    }else {
      throw Exception('Đổi mật khẩu thất bại !').toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> _createCartForUser(String userId) async {
    final cartUrl = Uri.parse('http://10.0.2.2:7258/api/Cart/AddCart');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token'); // Thay bằng JWT token thực tế nếu cần

    final cartResponse = await http.post(
      cartUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId,
        'orderStatus': 0,
        'orderNote': 'Note abc',
      }),
    );

    if (cartResponse.statusCode == 200) {
      print('Tạo giỏ hàng thành công cho người dùng $userId');
    } else if (cartResponse.statusCode == 409) {
      print('Người dùng đã có giỏ hàng');
    } else if(cartResponse.statusCode == 500){
      print('Tạo giỏ hàng thất bại : 500');
    }else if(cartResponse.statusCode == 400){
      print('Tạo giỏ hàng thất bại');
    }
  }

  final String baseUrlCart = 'http://10.0.2.2:7258/api/Cart';

  Future<String?> fetchCart() async {
    final url = Uri.parse('$baseUrlCart/GetCart');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    print("token" + token!);
    try {
      final response = await http.get(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orderId = data['result'][0]['orderId'];
        return orderId;
      } else {
        print('Lỗi tải dữ liệu giỏ hàng :  ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching cart: $e');
      return null;
    }
  }
}
