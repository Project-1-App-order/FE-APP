import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/screen/OTPSetting/ChangePasswordScreen.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class OTPScreen extends StatefulWidget {
  final Size size;
  final String email; // Pass email from the previous screen

  const OTPScreen({super.key, required this.size, required this.email});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _otpCode = "";
  final AuthRepository _authRepository = AuthRepository(AuthService());

  void _verifyOTP() async {
    try {
      // Call AuthService to verify the OTP
      String result = await _authRepository.verifyOTP(widget.email, _otpCode);

      if (result == 'OTP verified successfully') {
        // If OTP is verified, navigate to ChangePasswordScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordScreen(size: widget.size, email: widget.email, otp: _otpCode,)),
        );
      } else {
        _showMessage(result); // Show error message if OTP verification fails
      }
    } catch (e) {
      _showMessage('Failed to verify OTP');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                // Optional: Handle validation or checks here
              },
              onSubmit: (String verificationCode) {
                setState(() {
                  _otpCode = verificationCode; // Capture OTP code
                });
              },
            ),
            SizedBox(height: 20),
            InkWell(
              child: MyButton(size: widget.size, title: "Tiếp tục"),
              onTap: _verifyOTP, // Call _verifyOTP when tapped
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Optionally handle OTP resend logic
              },
              child: MyText(text: "Gửi Lại", size: 20, color: Colors.black, weight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
