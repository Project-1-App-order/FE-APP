import 'package:flutter/material.dart';
import 'package:project_1_btl/model/Category.dart';

class ItemHomeCategory extends StatelessWidget {
  final Category category;

  const ItemHomeCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Column(
        children: [
        Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
            child: Container(
              width: 50,
              height: 50,
              child: Center(
                child: ClipOval(
                  child: Image(
                    image: (category.categoryImgUrl != null && category.categoryImgUrl!.isNotEmpty)
                        ? NetworkImage(category.categoryImgUrl!)
                        : AssetImage('assets/images/image_food.jpg') as ImageProvider,
                    width: 30,  // Kích thước ảnh là 25
                    height: 30, // Kích thước ảnh là 25
                    fit: BoxFit.cover, // Đảm bảo ảnh không bị méo
                  ),
                ),
              ),
            ),

            ),
          const SizedBox(height: 8),
          Text(
            category.categoryName != null ? category.categoryName : "Food 1",
            style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: "Roboto-Light.ttf"),
          ),
        ],
      ),
    );
  }
}
