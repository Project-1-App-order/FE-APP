import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/item/ItemUserInfo.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';

import '../../widgets/MyText.dart';

class UserInformationScreen extends StatelessWidget {
  const UserInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Thông tin người dùng",),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.2, // Đặt kích thước avatar
                  height: width * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Hình dạng tròn
                    image: DecorationImage(
                      image: AssetImage('assets/images/image_food.jpg'), // Đường dẫn ảnh avatar
                      fit: BoxFit.cover, // Hiển thị ảnh toàn bộ trong vòng tròn
                    ),
                  ),
                ),

                Row(
                  children: [
                    MyText(text: "Đổi ảnh đại diện", size: 18, color: Colors.black, weight: FontWeight.w300),
                    SizedBox(width: 15,),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                )
              ],
            ),
            SizedBox(height: 10,),
            ItemUserInfo(title: "Tên Đăng Nhập", value: "Nguyễn Văn A",),
            ItemUserInfo(title: "Số Điện Thoại", value: "Nguyễn Văn A",),
            ItemUserInfo(title: "Email", value: "Nguyễn Văn A",),
            ItemUserInfo(title: "Giới Tính", value: "Nguyễn Văn A",),
            ItemUserInfo(title: "Địa Chỉ", value: "Nguyễn Văn A",),
        ],
            ),
      ),
    );
  }
}
