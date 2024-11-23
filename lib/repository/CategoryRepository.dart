
import 'package:project_1_btl/model/Category.dart';
import 'package:project_1_btl/services/CategoryService.dart';

class CategoryRepository {
  final CategoryService _categoryService;

  CategoryRepository(this._categoryService);

  Future<List<Category>> getCategories() async {
    return await _categoryService.fetchCategories();
  }

  Future<List<Category>> getCategoriesAndSpecial() async {
    List<Category> categories = await _categoryService.fetchCategories();

    // Thêm một category mặc định vào danh sách
    categories.insert(0, Category(categoryId: "all", categoryName: "Tất Cả", id: "all",categoryImgUrl: "https://drive.google.com/file/d/1cYF0q8Tjw3fh7pMvsW5Tf7oV9dEBoKXz/view"));

    return categories;
  }

}