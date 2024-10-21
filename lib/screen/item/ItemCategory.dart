import 'package:flutter/material.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemCategory extends StatelessWidget {
  final String title; // Thêm title để truyền tên sản phẩm
  const ItemCategory({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo trục dọc
          children: [
            Image.asset(
              "assets/images/image_food.jpg",
              width: 80,
              height: 80,
              fit: BoxFit.fill,
            ), // Thay hình ảnh phù hợp
            SizedBox(height: 10),
            // Dùng Flexible để xử lý văn bản xuống dòng và căn giữa
            Flexible(
              child: Center(
                child: Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
