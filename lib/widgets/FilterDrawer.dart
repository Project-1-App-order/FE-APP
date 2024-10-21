// FilterDrawer.dart
import 'package:flutter/material.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            ElevatedButton(
              onPressed: () {
                // Thực hiện hành động khi nhấn nút Lọc
                Navigator.pop(context); // Đóng Drawer sau khi chọn
              },
              child: Text('Áp dụng lọc'),
            ),
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
            padding: EdgeInsets.all(15),
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
