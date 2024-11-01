import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart';

class MyButton extends StatelessWidget {
  final Size size;
  final String title;

  const MyButton({super.key, required this.size, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: size.width,
        // Nút rộng 100% màn hình
        height: 48,

        child: Container(
          width: size.width,
          // Nút rộng 100% màn hình
          height: 48,
          // Chiều cao của nút cố định
          decoration: BoxDecoration(
            color: ColorApp.brightOrangeColor, // Màu nền của nút
            borderRadius:
                BorderRadius.zero, // Bỏ bo góc để tạo thành hình chữ nhật
          ),
          alignment: Alignment.center,
          // Căn giữa nội dung bên trong Container
          child: Text(
            title,
            style: const TextStyle(
              color: ColorApp.whiteColor, // Màu chữ của nút
              fontSize: 18,
              fontWeight: FontWeight.w600, // Sử dụng font tùy chỉnh
            ),
          ),
        ),
      ),
    );
  }
}
