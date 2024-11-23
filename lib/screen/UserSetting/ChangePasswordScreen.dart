import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/screen/Main/MainScreen.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/SnackBarHelper.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Size size;

  const ChangePasswordScreen({super.key, required this.size});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository(AuthService());

  void _changePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu mới và xác nhận không khớp')),
      );
      return;
    }

    try {
      final result = await _authRepository.changePasswordUser(
        currentPassword,
        newPassword,
        confirmPassword,
      );

      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: result,
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
    } catch (e) {
      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: "${e.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Đổi Mật Khẩu"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: "Thay đổi mật khẩu",
              size: 20,
              color: Colors.black,
              weight: FontWeight.w600,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hintText: "Mật Khẩu Cũ",
              controller: _currentPasswordController,
              iconSize: 10,
              hintColor: Colors.grey,
              background: Color(0xffc9c9c9),
              height: 45,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hintText: "Mật Khẩu Mới",
              controller: _newPasswordController,
              iconSize: 10,
              hintColor: Colors.grey,
              background: Color(0xffc9c9c9),
              height: 45,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hintText: "Xác nhận Mật Khẩu",
              controller: _confirmPasswordController,
              iconSize: 10,
              hintColor: Colors.grey,
              background: Color(0xffc9c9c9),
              height: 45,
            ),
            SizedBox(height: 20),
            InkWell(child:  MyButton(
              size: widget.size,
              title: "Lưu",
            ),
              onTap: (){
                _changePassword();
              },
            )
          ],
        ),
      ),
    );
  }
}
