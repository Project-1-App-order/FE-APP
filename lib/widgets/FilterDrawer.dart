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
      backgroundColor: Colors.white,
      width: 350,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              'Lọc theo khoảng giá',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "RobotoRegular"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
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
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Filter button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 3 / 9,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedStartPrice = null;
                          selectedEndPrice = null;
                        });
                        widget.onApplyFilter(null, null);
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: ColorApp.brightOrangeColor),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text(
                        "Hủy lọc",
                        style: TextStyle(
                          color: ColorApp.brightOrangeColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Apply Filter button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 3 / 9,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text(
                        "Áp dụng",
                        style: TextStyle(
                          color: ColorApp.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
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
        color: isSelected ? ColorApp.brightOrangeColor : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
