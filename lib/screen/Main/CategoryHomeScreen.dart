import 'package:flutter/material.dart';
import 'package:project_1_btl/model/Category.dart';
import 'package:project_1_btl/model/Food.dart';
import 'package:project_1_btl/repository/FoodRepository.dart';
import 'package:project_1_btl/screen/item/ItemFood.dart';
import 'package:project_1_btl/services/FoodService.dart';
import 'package:project_1_btl/widgets/CenterCircularProgress.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';

class CategoryHomeScreen extends StatelessWidget {
  final Category selectedCategory;

  const CategoryHomeScreen({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final FoodRepository _foodRepository = FoodRepository(FoodService());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        title: this.selectedCategory.categoryName,
      ),
      body: FutureBuilder<List<Food>>(
        future: _foodRepository.getFoodsByCategory(selectedCategory.categoryId),
        // Thay đổi phương thức phù hợp
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CenteredCircularProgress();
          } else if (snapshot.hasError) {
            return CenteredCircularProgress();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có gợi ý nào.'));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final food = snapshot.data![index];
                return ItemFood(
                  size: size,
                  food: food, // Giả sử giá là một số kiểu double
                );
              },
            );
          }
        },
      ),
    );
  }
}
