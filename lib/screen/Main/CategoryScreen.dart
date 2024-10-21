import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/item/ItemCategory.dart';
import 'package:project_1_btl/screen/item/ItemLeftListCategory.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
 // Import ItemLeftListCategory

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int selectedIndex = 0;

  // Danh sách danh mục (cột bên trái)
  final List<String> categories = ['Trà sữa', 'Gà rán', 'Pizza', 'Mì Ý', 'Bánh ngọt'];

  // Danh sách sản phẩm cho mỗi danh mục
  final Map<String, List<String>> products = {
    'Trà sữa': ['Trà sữa trân châu', 'Trà sữa matcha', 'Trà sữa socola', 'Trà sữa trân châu', 'Trà sữa matcha', 'Trà sữa socola'],
    'Gà rán': ['Gà rán truyền thống', 'Gà rán cay', 'Gà rán phô mai'],
    'Pizza': ['Pizza hải sản', 'Pizza bò', 'Pizza phô mai'],
    'Mì Ý': ['Mì Ý sốt bò bằm', 'Mì Ý sốt kem', 'Mì Ý sốt cà chua'],
    'Bánh ngọt': ['Bánh cheesecake', 'Bánh tiramisu', 'Bánh su kem'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Danh mục sản phẩm",),
      body: Row(
        children: [
          // Cột bên trái chứa ListView các danh mục
          Container(
            width: MediaQuery.of(context).size.width * 0.25, // Cột chiếm 25% màn hình
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index; // Cập nhật selectedIndex khi chọn
                    });
                  },
                  child: ItemLeftListCategory(
                    size: MediaQuery.of(context).size,  // Truyền kích thước của màn hình
                    title: categories[index],            // Truyền tên danh mục
                    isSelected: selectedIndex == index,  // Xác định mục nào được chọn
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 10,),
          // Phần còn lại là GridView chứa các sản phẩm tương ứng với danh mục được chọn
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 hànmainAxisSpacing: 5,
                crossAxisSpacing: 5,

                childAspectRatio: 2 / 3, // Điều chỉnh tỷ lệ kích thước của ô sản phẩm
              ),
              itemCount: products[categories[selectedIndex]]?.length ?? 0,
              itemBuilder: (context, index) {
                // Thay thế bằng ItemCategory
                return ItemCategory(
                  title: products[categories[selectedIndex]]?[index] ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
