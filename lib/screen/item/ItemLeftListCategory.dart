import 'package:flutter/material.dart';

class ItemLeftListCategory extends StatelessWidget {
  final Size size;
  final String title;
  final bool isSelected;
  final String imageUrl; // Thêm URL hình ảnh
  const ItemLeftListCategory({
    super.key,
    required this.size,
    required this.title,
    required this.isSelected,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.25,
      height: 100,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey[300],

      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Thay Icon bằng Image.network
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Icon mặc định nếu tải ảnh không thành công
                return Icon(
                  Icons.broken_image,
                  size: 30,
                  color: isSelected ? Colors.red : Colors.grey,
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.red : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontFamily: "Roboto-Light.ttf"
              ),
            ),
          ),
        ],
      ),
    );
  }
}
