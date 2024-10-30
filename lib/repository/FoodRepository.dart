import 'dart:convert';
import 'dart:math';

import 'package:project_1_btl/model/Food.dart';
import 'package:project_1_btl/services/FoodService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodRepository {
  final FoodService _foodService;

  FoodRepository(this._foodService);

  Future<List<Food>> getTopTenBestSellers() async {
    return await _foodService.fetchTopTenBestSellers();
  }

  Future<List<Food>> getAll() async{
    return await _foodService.fetchAllFoods();
  }

  Future<List<Food>> getDailyRandomFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toString().split(' ')[0]; // Lấy ngày hiện tại

    // Kiểm tra xem ngày đã lưu có khác với ngày hôm nay không
    if (prefs.getString('lastLoadDate') != today) {
      final foodList = await _foodService.fetchAllFoods();

      if (foodList.isNotEmpty) {
        final random = Random();
        final selectedFoods = List<Food>.generate(
            3,
                (_) => foodList[random.nextInt(foodList.length)]
        );

        // Lưu danh sách ngẫu nhiên và ngày vào SharedPreferences
        prefs.setString('selectedFoods', json.encode(selectedFoods.map((e) => e.toJson()).toList()));
        prefs.setString('lastLoadDate', today);
        return selectedFoods;
      }
    } else {
      // Lấy dữ liệu đã lưu
      final savedFoodsJson = prefs.getString('selectedFoods');
      if (savedFoodsJson != null) {
        final savedFoodsList = json.decode(savedFoodsJson) as List;
        return savedFoodsList.map((json) => Food.fromJson(json)).toList();
      }
    }
    return [];
  }

  Future<List<Food>> getFoodsByCategory(String categoryId) async {
    return await _foodService.fetchFoodsByCategory(categoryId);
  }
}
