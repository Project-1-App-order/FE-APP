
import 'package:project_1_btl/model/Category.dart';
import 'package:project_1_btl/services/CategoryService.dart';

class CategoryRepository {
  final CategoryService _categoryService;

  CategoryRepository(this._categoryService);

  Future<List<Category>> getCategories() async {
    return await _categoryService.fetchCategories();
  }
}