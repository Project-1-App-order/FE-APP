import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_1_btl/model/Food.dart';

class FoodService {
  final String _baseUrl = 'http://10.0.2.2:7258/api/Foods';

  Future<List<Food>> fetchTopTenBestSellers() async {
    final response = await http.get(Uri.parse('$_baseUrl/GetTopTenBestSeller'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> foodsJson = data["\$values"];
      return foodsJson.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top ten best sellers');
    }
  }

  Future<List<Food>> fetchAllFoods() async {
    final response = await http.get(Uri.parse('$_baseUrl/GetAllFoods'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> foodsJson = data["result"]["\$values"];
      return foodsJson.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all foods');
    }
  }

  Future<List<Food>> fetchFoodsByCategory(String categoryId) async {
    final url = '$_baseUrl/FIlterGetFoods?categoryId=$categoryId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> foodsJson = data['result']['\$values'];
      return foodsJson.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load foods');
    }
  }

  // New method to get food details by foodId
  Future<Food> getDetailFoodById(String foodId) async {
    final url = '$_baseUrl/FIlterGetFoods?foodId=$foodId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final foodJson = data['result']['\$values'][0]; // Assuming the first item is the desired one
      return Food.fromJson(foodJson);
    } else {
      throw Exception('Failed to load food details');
    }
  }

  Future<List<Food>> getDetailFoodByName(String foodName) async {
    final url = '$_baseUrl/FIlterGetFoods?foodName=$foodName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> foodsJson = data['result']['\$values'];
      return foodsJson.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load food details');
    }
  }

  Future<List<Food>> getDetailFoodByNameAndFilter(String foodName, int startPrice, int endPrice) async {
    final url = '$_baseUrl/FIlterGetFoods?FoodName=$foodName&StartPrice=$startPrice&EndPrice=$endPrice';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> foodsJson = data['result']['\$values'];
      return foodsJson.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load food details');
    }
  }
}
