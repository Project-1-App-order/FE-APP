import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_1_btl/model/Category.dart';

class CategoryService {
  final String _baseUrl = 'http://10.0.2.2:7258/api/Categories/GetAllCategories';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> categoriesJson = data["\$values"];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
