import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_1_btl/model/Category.dart';
import 'package:project_1_btl/utils/constants.dart';

class CategoryService {
  static String url = AppUrl.UrlApi;
  final String _baseUrl =url +  '/Categories/GetAllCategories';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> categoriesJson = data["\$values"];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi tải danh mục!').toString().replaceAll('Exception: ', '');
    }
  }


}
