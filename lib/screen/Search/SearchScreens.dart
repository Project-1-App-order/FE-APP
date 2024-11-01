import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/Main/MainScreen.dart';
import 'package:project_1_btl/screen/item/ItemFoodSearch.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/FilterDrawer.dart'; // Nhập widget FilterDrawer

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFiltering = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isFiltering = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Hàm để mở Right Drawer Menu
  void _openFilterMenu() {
    _scaffoldKey.currentState?.openEndDrawer(); // Mở EndDrawer
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey, // Đặt GlobalKey cho Scaffold
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: "Cú đêm không lo phí ship",
                    iconSize: 10,
                    hintColor: Colors.grey,
                    background: Color(0xffc9c9c9),
                    height: 40,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      if (_isFiltering) {
                        _openFilterMenu(); // Gọi hàm mở menu lọc
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                      }
                    },
                    child: MyText(
                      text: _isFiltering ? "Lọc" : "Hủy",
                      size: 18,
                      color: ColorApp.brightOrangeColor,
                      weight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(text: "Cú đêm không lo phí ship", size: 15, color: Colors.black, weight: FontWeight.w300),
                Container(
                  height: 50,
                  decoration: BoxDecoration(shape: BoxShape.rectangle),
                  child: Image.asset("assets/images/image_food.jpg", width: 70, height: 40),
                ),
              ],
            ),
          ),

        ],
      ),
      endDrawer: const FilterDrawer(), // Sử dụng FilterDrawer
    );
  }
}
