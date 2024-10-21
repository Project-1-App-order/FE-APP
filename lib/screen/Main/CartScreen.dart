import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/item/ItemCart.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Lấy kích thước của màn hình
    int cartItemCount = 5; // Giả sử có 5 mục trong giỏ hàng, có thể thay đổi thành giá trị động từ database

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: "Xóa Tất Cả",
              size: 13,
              color: ColorApp.brightOrangeColor,
              weight: FontWeight.w300,
            ),
            const Text(
              'Giỏ hàng',
              style: TextStyle(color: Colors.black),
            ),
            const Icon(Icons.close, size: 27, color: Colors.black),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItemCount, // Số lượng mục trong giỏ hàng
              itemBuilder: (context, index) {
                return ItemCart(size: size, title: "ladjdsl");
              },
            ),
          ),
          Divider(height: 2,color: Colors.grey,),
          // Phần tính tiền, chỉ hiển thị nếu giỏ hàng có phần tử
          Visibility(
            visible: cartItemCount > 0, // Kiểm tra xem giỏ hàng có phần tử không
            child: Container(
              padding: EdgeInsets.all(20), // Thêm padding để đẹp hơn
              decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.1),
                //     spreadRadius: 2,
                //     blurRadius: 5,
                //     offset: Offset(0, -2), // Shadow ở phía trên
                //   ),
                // ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Hiển thị số tiền
                  MyText(
                    text: "Tổng: 120000đ", // Giả sử tổng số tiền là 120000đ, có thể thay bằng giá trị động
                    size: 18,
                    color: Colors.black,
                    weight: FontWeight.bold,
                  ),
                  // Nút đặt mua
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.brightOrangeColor,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: () {
                      // Xử lý sự kiện khi nhấn nút đặt mua
                    },
                    child: MyText(
                      text: "Đặt mua",
                      size: 16,
                      color: Colors.white,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
