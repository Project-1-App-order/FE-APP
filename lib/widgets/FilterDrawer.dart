// FilterDrawer.dart
import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/MyButton.dart';

class FilterDrawer extends StatelessWidget {

  const FilterDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 350,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Text(
              'Lọc theo khoảng giá',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Phần lọc giá
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PriceOption("25.000đ - 50.000đ"),
                _PriceOption("50.000đ - 75.000đ"),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PriceOption("75.000đ - 100.000đ"),
                _PriceOption("100.000đ - 125.000đ"),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                // Nút rộng 100% màn hình
                height: 48,

                child: Container(
                  width: 120,
                  // Nút rộng 100% màn hình
                  height: 48,
                  // Chiều cao của nút cố định
                  decoration: BoxDecoration(
                    color: ColorApp.brightOrangeColor, // Màu nền của nút
                    borderRadius:
                    BorderRadius.zero, // Bỏ bo góc để tạo thành hình chữ nhật
                  ),
                  alignment: Alignment.center,
                  // Căn giữa nội dung bên trong Container
                  child: Text(
                    "Áp dụng lọc",
                    style: const TextStyle(
                      color: ColorApp.whiteColor, // Màu chữ của nút
                      fontSize: 18,
                      fontWeight: FontWeight.w600, // Sử dụng font tùy chỉnh
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _PriceOption(String title) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            // Thực hiện hành động khi nhấn vào ô giá
            print('Lọc theo $title');
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
