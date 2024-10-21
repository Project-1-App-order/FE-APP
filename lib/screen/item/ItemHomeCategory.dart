import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart';

class ItemHomeCategory extends StatelessWidget {
  final Size size;

  const ItemHomeCategory({super.key, required this.size});

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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image_food.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8), // Add some space between the image and the text
          const Text(
            "Food 1",
            style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
