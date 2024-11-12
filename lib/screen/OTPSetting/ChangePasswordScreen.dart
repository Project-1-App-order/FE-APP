import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/screen/Login/LoginScreen.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Size size;
  final String email;  // Email được truyền từ màn hình trước
  final String otp;    // OTP được truyền từ màn hình trước

  const ChangePasswordScreen({super.key, required this.size, required this.email, required this.otp});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository(AuthService());

  void _changePassword() async {
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      _showMessage('Mật khẩu không khớp');
      return;
    }

    try {
      String result = await _authRepository.changePassword(widget.email, widget.otp, password);
      _showMessage(result);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      // Điều hướng về màn hình đăng nhập hoặc màn hình khác
    } catch (e) {
      _showMessage('Đặt lại mật khẩu thất bại');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Mật Khẩu"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MyText(text: "Nhập mật khẩu mới", size: 20, color: Colors.black, weight: FontWeight.w300),
            SizedBox(height: 20,),
            CustomTextField(
              controller: _passwordController,
              hintText: "Mật khẩu mới",
              iconSize: 10,
              background: Colors.white,
              hintColor: Colors.black,
              height: 50,
            ),
            SizedBox(height: 20,),
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: "Xác nhận mật khẩu mới",
              iconSize: 10,
              background: Colors.white,
              hintColor: Colors.black,
              height: 50,
            ),
            SizedBox(height: 20,),
            InkWell(
              child: MyButton(size: widget.size, title: "Lưu"),
              onTap: _changePassword,
            ),
          ],
        ),
      ),
    );
  }
}
