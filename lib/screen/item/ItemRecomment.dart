import 'package:flutter/material.dart';

class ItemRecomment extends StatelessWidget {
  const ItemRecomment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          // Cột bên trái: Avatar
          Expanded(
            flex: 2, // Tỉ lệ 2 phần cho avatar
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/avatar.jpg'), // Đường dẫn ảnh avatar
            ),
          ),

          SizedBox(width: 10), // Khoảng cách giữa hai cột

          // Cột bên phải: Gồm 3 hàng
          Expanded(
            flex: 8, // Tỉ lệ 8 phần cho nội dung
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hàng 1: Tên người dùng
                Text(
                  "Tên người dùng",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5), // Khoảng cách giữa các hàng

                // Hàng 2: Đánh giá 5 sao
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: Colors.yellow[700],
                      size: 20,
                    );
                  }),
                ),
                SizedBox(height: 5), // Khoảng cách giữa các hàng

                // Hàng 3: Bình luận
                Text(
                  "Bình luận của người dùng về sản phẩm...",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
