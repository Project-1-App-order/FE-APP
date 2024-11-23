import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemProfile extends StatelessWidget {
  final Size size;
  final IconData? icon;
  final String title;

  const ItemProfile({
    super.key,
    required this.size,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorApp.whiteColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // Gạch dưới màu xám
            width: 1, // Độ dày của gạch
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04), // Khoảng cách hai bên
      //color: ColorApp.skyBlue,
      height: size.height * 0.05, // Điều chỉnh chiều cao theo ý bạn
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null)
              Icon(icon, size: size.height * 0.03),
              SizedBox(width: size.width * 0.03), // Khoảng cách giữa icon và text
              MyText(
                text: title,
                size: size.height * 0.025,
                color: Colors.black,
                weight: FontWeight.w500,
              ),
            ],
          ),
          Icon(
            Icons.keyboard_arrow_right,
            size: size.height * 0.03, // Điều chỉnh kích thước của icon mũi tên
          ),
        ],
      ),
    );
  }
}
