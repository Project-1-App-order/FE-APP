import 'dart:convert';
import 'package:project_1_btl/model/Food.dart';
import 'package:project_1_btl/services/FoodService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    try {
      final prefs = await SharedPreferences.getInstance();
      final String currentDate = DateTime.now().toIso8601String().substring(0, 10); // Lấy ngày hiện tại (YYYY-MM-DD)
      final String? lastSavedDate = prefs.getString('lastSavedDate');

      // Kiểm tra nếu ngày hôm nay đã có danh sách món ăn được lưu
      if (lastSavedDate != null && lastSavedDate == currentDate) {
        print("foodlist" + prefs.getString('foodList')!);
        // Đã có danh sách món ăn cho hôm nay, lấy danh sách đã lưu
        final String? foodListString = prefs.getString('foodList');
        if (foodListString != null) {
          final List<dynamic> foodListJson = json.decode(foodListString);
          final List<Food> foodList = foodListJson.map((json) => Food.fromJson(json)).toList();
          return foodList;
        }
      }

      print("không có sản phẩm");

      // Nếu chưa có hoặc ngày đã thay đổi, lấy món ăn mới từ API
      final response = await http.get(Uri.parse('http://139.59.108.150:8083/api/Foods/FilterGetFoods'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> foodsJson = data["result"]["\$values"];
        final List<Food> foods = foodsJson.map((json) => Food.fromJson(json)).toList();

        // Random 3 món ăn
        foods.shuffle(); // Shuffle lại danh sách món ăn
        List<Food> randomFoods = foods.take(3).toList(); // Lấy 3 món ăn ngẫu nhiên

        // Lưu danh sách món ăn và ngày vào SharedPreferences
        await prefs.setString('lastSavedDate', currentDate);
        await prefs.setString('foodList', json.encode(randomFoods.map((food) => food.toJson()).toList()));

        return randomFoods;
      } else {
        throw Exception('Failed to load foods: ${response.statusCode}');
      }
    } catch (e) {
      // Bắt tất cả các lỗi có thể xảy ra và in ra
      print('Error: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }


  Future<List<Food>> getFoodsByCategory(String categoryId) async {
    return await _foodService.fetchFoodsByCategory(categoryId);
  }

  Future<Food> getDetailFoodById(String foodId) async {
    return await _foodService.getDetailFoodById(foodId);
  }
  Future<List<Food>> getFoodByName(String foodName) async {
    return await _foodService.getDetailFoodByName(foodName);
  }
  Future<List<Food>> getFoodByNameAndFilter(String foodName, int startPrice, int endPrice) async {
    return await _foodService.getDetailFoodByNameAndFilter(foodName, startPrice, endPrice);
  }
}
