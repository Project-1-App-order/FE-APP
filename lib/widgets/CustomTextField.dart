import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final double iconSize;
  final bool obscureText;
  final Color background;
  final Color hintColor;
  final double width;  // Chiều rộng
  final double height; // Chiều cao

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.icon, // Để icon là optional (có thể null)
    required this.iconSize,
    this.obscureText = false,
    required this.background,
    required this.hintColor,
    this.width = double.infinity,  // Giá trị mặc định là full width
    required this.height,              // Giá trị mặc định cho chiều cao
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,  // Đặt chiều rộng
      height: height, // Đặt chiều cao
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            border: InputBorder.none, // Bỏ border
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor),
            // Kiểm tra icon != null trước khi thêm prefixIcon
            prefixIcon: icon != null
                ? Icon(
              icon,
              size: iconSize, // Kích thước icon phụ thuộc vào tham số
            )
                : null, // Nếu icon là null, không thêm prefixIcon
            contentPadding: icon != null ? EdgeInsets.symmetric(vertical: height * 0.25) : EdgeInsets.symmetric(vertical: height * 0.25, horizontal: 10),
          ),
        ),
      ),
    );
  }
}
