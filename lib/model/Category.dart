class Category {
  final String id;
  final String categoryId;
  final String categoryName;
  final String? createAt;       // Made nullable
  final String? updateAt;       // Made nullable
  final String? categoryImgUrl; // Made nullable
  final String? foods;          // Made nullable

  Category({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    this.createAt,
    this.updateAt,
    this.categoryImgUrl,
    this.foods,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['\$id'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      createAt: json['createAt'] as String?,        // Cast to nullable String
      updateAt: json['updateAt'] as String?,        // Cast to nullable String
      categoryImgUrl: json['categoryImgUrl'] as String?, // Cast to nullable String
      foods: json['foods'] as String?,              // Cast to nullable String
    );
  }
}
