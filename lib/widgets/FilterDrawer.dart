import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart';

class FilterDrawer extends StatefulWidget {
  final Function(int? startPrice, int? endPrice) onApplyFilter;

  const FilterDrawer({Key? key, required this.onApplyFilter}) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  int? selectedStartPrice;
  int? selectedEndPrice;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 350,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              'Lọc theo khoảng giá',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Price filtering section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PriceOption("25.000đ - 50.000đ", 25000, 50000),
                _PriceOption("50.000đ - 75.000đ", 50000, 75000),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PriceOption("75.000đ - 100.000đ", 75000, 100000),
                _PriceOption("100.000đ - 125.000đ", 100000, 125000),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedStartPrice != null && selectedEndPrice != null) {
                      widget.onApplyFilter(selectedStartPrice!, selectedEndPrice!);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorApp.brightOrangeColor,
                  ),
                  child: Text(
                    "Áp dụng lọc",
                    style: const TextStyle(
                      color: ColorApp.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Hủy lọc
                    setState(() {
                      selectedStartPrice = null;
                      selectedEndPrice = null;
                    });
                    widget.onApplyFilter(null, null); // Gọi lại để hủy bộ lọc
                    Navigator.of(context).pop(); // Đóng drawer
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Màu đỏ cho nút hủy
                  ),
                  child: Text(
                    "Hủy lọc",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _PriceOption(String title, int startPrice, int endPrice) {
    bool isSelected = (selectedStartPrice == startPrice && selectedEndPrice == endPrice);

    return Expanded(
      child: Card(
        elevation: isSelected ? 4 : 2,
        color: isSelected ? ColorApp.brightOrangeColor.withOpacity(0.2) : Colors.white,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedStartPrice = startPrice;
              selectedEndPrice = endPrice;
            });
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
