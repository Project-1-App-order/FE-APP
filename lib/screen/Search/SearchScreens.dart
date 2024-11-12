import 'package:flutter/material.dart';
import 'package:project_1_btl/model/Food.dart';
import 'package:project_1_btl/repository/FoodRepository.dart';
import 'package:project_1_btl/screen/Main/MainScreen.dart';
import 'package:project_1_btl/screen/item/ItemFood.dart';
import 'package:project_1_btl/services/FoodService.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/FilterDrawer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFiltering = false;
  bool _isSearching = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FoodRepository _foodRepository = FoodRepository(FoodService());
  Future<List<Food>>? _searchResults;
  int? _selectedStartPrice;
  int? _selectedEndPrice;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isFiltering = _searchController.text.isNotEmpty;
      });
    });
  }

  void _performSearch() {
    setState(() {
      _isSearching = true;
      if (_selectedStartPrice != null && _selectedEndPrice != null) {
        print(
            'Đang tìm kiếm với bộ lọc: ${_searchController.text} - $_selectedStartPrice - $_selectedEndPrice');
        // Khi bộ lọc giá được áp dụng
        _searchResults = _foodRepository.getFoodByNameAndFilter(
          _searchController.text,
          _selectedStartPrice!,
          _selectedEndPrice!,
        );
      } else {
        // Khi chỉ tìm kiếm theo tên
        _searchResults = _foodRepository.getFoodByName(_searchController.text);
        print('Đang tìm kiếm với bộ lọc: ${_searchController.text}');
      }
    });
  }

  void _openFilterMenu() {
    FocusScope.of(context).unfocus();
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _updatePriceFilter(int? startPrice, int? endPrice) {
    setState(() {
      _selectedStartPrice = startPrice;
      _selectedEndPrice = endPrice;
    });

    String searchText =
        _searchController.text; // Lưu giá trị trước khi tìm kiếm

    _performSearch();

    // Nếu cần, có thể gán lại giá trị cho _searchController
    _searchController.text = searchText;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.only(left: 0, right: 15, top: 30, bottom: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  flex: 7,
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: "Tìm kiếm món ăn",
                    iconSize: 10,
                    hintColor: Colors.grey,
                    background: Color(0xffc9c9c9),
                    height: 40,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: ColorApp.brightOrangeColor),
                  onPressed: _performSearch,
                ),
                SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      if (_isFiltering) {
                        _openFilterMenu();
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()));
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
          Expanded(
            child: _isSearching
                ? FutureBuilder<List<Food>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa
                      children: [
                        // Hình ảnh
                        Container(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            "assets/images/searching.png", // Đường dẫn đến hình ảnh
                            fit: BoxFit.cover, // Đảm bảo hình ảnh được hiển thị đầy đủ trong container
                          ),
                        ),
                        SizedBox(height: 16), // Khoảng cách giữa hình ảnh và text
                        // Text
                        MyText(text: "Không có kết quả tìm kiếm", size: 20, color: Colors.black, weight: FontWeight.w500),

                      ],
                    ),
                  );
                } else {
                  final foods = snapshot.data!;
                  return ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return ItemFood(size: size, food: food);
                    },
                  );
                }
              },
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Căn giữa
                children: [
                  // Hình ảnh
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      "assets/images/searching.png", // Đường dẫn đến hình ảnh
                      fit: BoxFit.cover, // Đảm bảo hình ảnh được hiển thị đầy đủ trong container
                    ),
                  ),
                  SizedBox(height: 16), // Khoảng cách giữa hình ảnh và text
                  // Text
                  MyText(text: "Chưa có sản phẩm tìm kiếm", size: 20, color: Colors.black, weight: FontWeight.w500),

                ],
              ),
            ),
          ),
        ],
      ),
      endDrawer: FilterDrawer(
        onApplyFilter: _updatePriceFilter,
      ),
    );
  }
}
