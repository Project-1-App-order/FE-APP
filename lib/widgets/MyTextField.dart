import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart';

class MyTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword; // Thêm trường để kiểm soát hiển thị mật khẩu

  const MyTextField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
    this.isPassword = false, // Mặc định không phải trường mật khẩu
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Kết nối với TextEditingController
      obscureText: isPassword, // Ẩn nội dung nếu là trường mật khẩu
      showCursor: true,
      style: TextStyle(fontWeight: FontWeight.w500, fontFamily: "Roboto-Light.ttf", fontSize: 19),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        prefixIcon: Icon(
          icon,
          color: ColorApp.brightOrangeColor,
          size: 25,
        ),
        fillColor: Color(0xFFF2F3F5),
        hintStyle: TextStyle(
          color: Color(0xFF666666),
          fontFamily: "Roboto-Light.ttf",
          fontSize: 20,
        ),
        hintText: hintText,
      ),
    );
  }
}
