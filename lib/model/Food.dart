class Food {
  final String foodId;
  final String foodName;
  final double price;
  final int status;
  final String description;
  final List<String> images;

  Food({
    required this.foodId,
    required this.foodName,
    required this.price,
    required this.status,
    required this.description,
    required this.images,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodId: json['foodId'],
      foodName: json['foodName'] ?? "",
      price: json['price'],
      status: json['status'] ?? 1,
      description: json['description'] ?? "",
      images: List<String>.from(json['foodImages']["\$values"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'price': price,
      'status': status,
      'description': description,
      'foodImages': {
        '\$values': images,
      },
    };
  }
}
