import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_1_btl/model/Food.dart';

class FoodService {
  final String _baseUrl = 'http://10.0.2.2:7258/api/Foods/GetTopTenBestSeller';

  Future<List<Food>> fetchTopTenBestSellers() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> foodsJson = data["\$values"];
      return foodsJson.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top ten best sellers');
    }
  }

  final String _baseUrlGetAllFoods = 'http://10.0.2.2:7258/api/Foods/GetAllFoods'; // Updated URL

  Future<List<Food>> fetchAllFoods() async {
    final response = await http.get(Uri.parse(_baseUrlGetAllFoods));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> foodsJson = data["result"]["\$values"];
      return foodsJson.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all foods');
    }
  }

  final String _baseUrlFoodByCategory = 'http://10.0.2.2:7258/api/Foods/GetFoodsByCategory';

  Future<List<Food>> fetchFoodsByCategory(String categoryId) async {
    final url = '$_baseUrlFoodByCategory?categoryId=$categoryId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> foodsJson = data['result']['\$values'];
      return foodsJson.map((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load foods');
    }
  }
}
