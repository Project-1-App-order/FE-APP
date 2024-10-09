import 'package:flutter/material.dart';

class ItemLeftListCategory extends StatelessWidget {
  final Size size;
  final String title;
  final bool isSelected; // Biến để kiểm tra xem item có được chọn hay không

  const ItemLeftListCategory({
    super.key,
    required this.size,
    required this.title,
    required this.isSelected, // Nhận biến isSelected
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.25,
      height: 100,

      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey[300], // Nền trắng nếu được chọn, xám nếu không
        borderRadius: isSelected ? BorderRadius.only(topRight: Radius.circular(10)) : null, // BorderRadius cho item
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 30,
            color: isSelected ? Colors.red : Colors.grey, // Icon đỏ nếu được chọn, xám nếu không
          ),
          SizedBox(height: 10),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.red : Colors.black, // Text đỏ nếu được chọn, đen nếu không
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // Font đậm nếu được chọn
              ),
            ),
          ),
        ],
      ),
    );
  }
}
