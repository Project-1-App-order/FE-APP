import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/TextFieldSearchHome.dart';

class ChangePasswordScreen extends StatelessWidget {
  final Size size;

  const ChangePasswordScreen({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Đổi Mật Khẩu"),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
                text: "Nhập mật khẩu mới",
                size: 20,
                color: Colors.black,
                weight: FontWeight.w600),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              hintText: "Mật Khẩu",
              iconSize: 10,
              hintColor: Colors.grey,
              background: Color(0xffc9c9c9),
              height: 45,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hintText: "Mật Khẩu Mới",
              iconSize: 10,
              hintColor: Colors.grey,
              background: Color(0xffc9c9c9),
              height: 45,
            ),
            SizedBox(height: 20,),
            MyButton(size: size, title: "Lưu")
          ],
        ),
      ),
    );
  }
}
