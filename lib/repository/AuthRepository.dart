
import 'package:project_1_btl/services/AuthService.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<String> registerUser(String email, String password) async {
    return await _authService.register(email, password);
  }

  Future<String> loginUser(String email, String password) async {
    return await _authService.login(email, password);
  }

  Future<String> sendOTP(String email) async {
    return await _authService.sendOTP(email);
  }

  Future<String> verifyOTP(String email, String otp) async {
    return await _authService.verifyOTP(email, otp);
  }

  Future<String> changePassword(String email, String otp, String newPassword) async {
    return await _authService.changePassword(email, otp, newPassword);
  }

  Future<Map<String , dynamic>> getUserInformation() async {
    return await _authService.getUserInformation();
  }

  updateUserInformation(Map<String, String> updatedUserInfo) async {
    return await _authService.updateUserInformation(updatedUserInfo);
  }

  Future<String> changePasswordUser(String currentPassword, String newPassword, String confirmPassword) async {
    return await _authService.changePasswordUser(currentPassword, newPassword, confirmPassword);
  }


}
