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
          ClipOval(
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (category.categoryImgUrl != null && category.categoryImgUrl!.isNotEmpty)
                      ? NetworkImage(category.categoryImgUrl!) // Use NetworkImage if categoryImgUrl is not null
                      : AssetImage('assets/images/image_food.jpg') as ImageProvider, // Fallback to local asset
                  fit: BoxFit.fill,
                ),
              ),

            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.categoryName != null ? category.categoryName : "Food 1",
            style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
