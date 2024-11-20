import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final double iconSize;
  final bool obscureText;
  final Color background;
  final Color hintColor;
  final double width;
  final double height;
  final TextEditingController? controller; // Thêm controller để quản lý văn bản
  final ValueChanged<String>? onChanged; // Hàm lắng nghe sự thay đổi văn bản

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.icon,
    required this.iconSize,
    this.obscureText = false,
    required this.background,
    required this.hintColor,
    this.width = double.infinity,
    required this.height,
    this.controller,
    this.onChanged, // Nhận vào hàm lắng nghe thay đổi
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: TextField(
          controller: controller, // Sử dụng controller để quản lý văn bản
          onChanged: onChanged, // Lắng nghe sự thay đổi văn bản
          obscureText: obscureText,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor,),
            prefixIcon: icon != null
                ? Icon(
              icon,
              size: iconSize,
            )
                : null,
            contentPadding: EdgeInsets.symmetric(
              vertical: height * 0.25,
              horizontal: icon == null ? 10 : 0,
            ),
          ),
        ),
      ),
    );
  }
}
