import 'package:flutter/material.dart';
import 'package:project_1_btl/repository/CategoryRepository.dart';
import 'package:project_1_btl/repository/FoodRepository.dart';
import 'package:project_1_btl/screen/item/ItemCategory.dart';
import 'package:project_1_btl/screen/item/ItemLeftListCategory.dart';
import 'package:project_1_btl/services/CategoryService.dart';
import 'package:project_1_btl/services/FoodService.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/model/Category.dart';
import 'package:project_1_btl/model/Food.dart'; // Import model của Food

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int selectedIndex = 0;
  final CategoryRepository _categoryRepository = CategoryRepository(CategoryService());
  final FoodRepository _foodRepository = FoodRepository(FoodService());
  List<Category> categories = [];
  Map<String, List<Food>> products = {}; // Map lưu trữ sản phẩm theo danh mục

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    List<Category> fetchedCategories = await _categoryRepository.getCategoriesAndSpecial();
    setState(() {
      categories = fetchedCategories;
    });
    if (categories.isNotEmpty) {
      loadProductsForSelectedCategory(); // Chỉ gọi sau khi categories có dữ liệu
    }
  }

  Future<void> loadProductsForSelectedCategory() async {
    if (categories.isEmpty) return;

    // Nếu danh mục "Tất Cả" được chọn, tải toàn bộ sản phẩm
    if (categories[selectedIndex].categoryId == "all") {
      List<Food> allFoods = await  _foodRepository.getAll();// Giả sử bạn có phương thức này
      setState(() {
        products["all"] = allFoods;
      });
    }
    else {
      List<Food> foodsByCategory = await _foodRepository.getFoodsByCategory(categories[selectedIndex].categoryId);
      setState(() {
        products[categories[selectedIndex].categoryId] = foodsByCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Danh mục sản phẩm"),
      body: categories.isEmpty // Kiểm tra nếu categories rỗng
          ? Center(child: CircularProgressIndicator()) // Hiển thị vòng xoay tải
          :Row(
        children: [
          // Cột bên trái chứa ListView các danh mục
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    loadProductsForSelectedCategory(); // Tải sản phẩm tương ứng với danh mục được chọn
                  },
                  child: ItemLeftListCategory(
                    size: MediaQuery.of(context).size,
                    title: categories[index].categoryName,
                    imageUrl: categories[index].categoryImgUrl!,
                    isSelected: selectedIndex == index,
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 10),
          // Phần còn lại là GridView chứa các sản phẩm tương ứng với danh mục được chọn
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 2 / 3,
              ),
              itemCount: products[categories[selectedIndex].categoryId]?.length ?? 0,
              itemBuilder: (context, index) {
                Food? food = products[categories[selectedIndex].categoryId]?[index];
                return ItemCategory(
                  food: food!, // Hiển thị URL của hình ảnh nếu có
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
