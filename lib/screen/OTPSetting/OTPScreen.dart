import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/screen/OTPSetting/ChangePasswordScreen.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/SnackBarHelper.dart';

class OTPScreen extends StatefulWidget {
  final Size size;
  final String email; // Nhận email từ màn hình trước

  const OTPScreen({super.key, required this.size, required this.email});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _otpCode = "";
  final AuthRepository _authRepository = AuthRepository(AuthService());

  void _verifyOTP() async {
    try {
      print("1");
      // Gọi AuthService để xác minh OTP
      String result = await _authRepository.verifyOTP(widget.email, _otpCode);

      print("OTP 1");
      if (result == 'Xác minh OTP thành công !') {
        // Nếu OTP được xác minh thành công, chuyển sang màn hình đổi mật khẩu
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordScreen(size: widget.size, email: widget.email, otp: _otpCode,)),
        );
      } else {
        SnackBarHelper.showSimpleSnackBar(
          context: context,
          message: result,
        ); // Hiển thị thông báo lỗi nếu xác minh OTP thất bại
      }
    } catch (e) {
      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: "Không thể xác minh OTP",
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "OTP"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MyText(text: "Nhập mã OTP", size: 20, color: Colors.black, weight: FontWeight.w300),
            SizedBox(height: 20),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                // Optional: Xử lý kiểm tra hoặc xác nhận OTP tại đây
              },
              onSubmit: (String verificationCode) {
                setState(() {
                  _otpCode = verificationCode; // Lưu mã OTP
                });
              },
            ),
            SizedBox(height: 20),
            InkWell(
              child: MyButton(size: widget.size, title: "Tiếp tục"),
              onTap: _verifyOTP, // Gọi hàm _verifyOTP khi nhấn
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
