import 'package:flutter/material.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemFoodSearch extends StatelessWidget {
  const ItemFoodSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(// Khoảng cách bên trong container
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền
        border: Border.all(color: Colors.grey.shade300), // Viền màu xám nhạt
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(text: "Trà Sữa", size: 15, color: Colors.black, weight: FontWeight.w300),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              child: Image.asset("assets/images/image_food.jpg", width: 70, height: 190, fit: BoxFit.fill,), // Thêm width và height để điều chỉnh kích thước ảnh
            )
          ],
        ),
      ),
    );
  }
}
