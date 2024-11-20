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
import 'package:project_1_btl/widgets/SnackBarHelper.dart';

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
      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: "Vui lòng nhập email của bạn",
      );
      return;
    }

    try {
      String result = await _authRepository.sendOTP(email);
      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: result,
      );
      // Chuyển sang màn hình OTP nếu gửi OTP thành công
      Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(size: widget.size, email: email,)));
    } catch (e) {
      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: "OTP gửi thất bại !",
      );
    }
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
                controller: _emailController,  // Gán controller cho trường nhập liệu email
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
              onTap: _sendOTP,  // Gọi hàm sendOTP khi người dùng nhấn
            )
          ],
        ),
      ),
    );
  }
}
