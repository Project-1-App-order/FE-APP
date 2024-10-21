import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/screen/OTPSetting/OTPScreen.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class EmailOTPScreen extends StatefulWidget {
  final Size size;
  const EmailOTPScreen({super.key, required this.size});

  @override
  _EmailOTPScreenState createState() => _EmailOTPScreenState();
}

class _EmailOTPScreenState extends State<EmailOTPScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(_authService);
  }

  void _sendOTP() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email');
      return;
    }

    try {
      String result = await _authRepository.sendOTP(email);
      _showMessage(result);
      // Navigate to the OTP screen if successful
      Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(size: widget.size, email: email,)));
    } catch (e) {
      _showMessage('Error: Failed to send OTP');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Quên Mật Khẩu",),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(text: "Nhập email", size: 20, color: Colors.black, weight: FontWeight.w300),
            SizedBox(height: 20,),
            CustomTextField(
                controller: _emailController,  // Assign the controller here
                hintText: "Nhập Email",
                icon: Icons.email,
                iconSize: 20,
                background: Color(0xffc9c9c9),
                hintColor: Colors.grey,
                height: 50
            ),
            SizedBox(height: 20,),
            InkWell(
              child: MyButton(size: widget.size, title: "Tiếp tục"),
              onTap: _sendOTP,  // Call the sendOTP function when tapped
            )
          ],
        ),
      ),
    );
  }
}

