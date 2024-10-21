import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ChangePasswordScreen extends StatelessWidget {
  final Size size;
  const ChangePasswordScreen({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Mật Khẩu"),
      body: Column(
        children: [
          MyText(text: "Nhập mật khẩu mới", size: 20, color: Colors.black, weight: FontWeight.w300),
          SizedBox(height: 20,),
          CustomTextField(hintText: "Mật khẩu mới", iconSize: 10, background: Colors.white, hintColor: Colors.black, height: 50),
          SizedBox(height: 20,),
          CustomTextField(hintText: "Xác nhận mật khẩu mới", iconSize: 10, background: Colors.white, hintColor: Colors.black, height: 50),
SizedBox(height: 20,),
          Center(child: MyButton(size: size, title: "Lưu"))
        ],
      ),
    );
  }
}
