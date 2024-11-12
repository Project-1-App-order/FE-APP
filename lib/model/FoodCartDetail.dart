import 'package:project_1_btl/model/CartDetail.dart';

class FoodCartDetail {
  final String foodId;
  final String foodName;
  final double price;
  final int quantity;
  final String note;
  final List<String> images;

  FoodCartDetail({
    required this.foodId,
    required this.foodName,
    required this.price,
    required this.quantity,
    required this.note,
    required this.images,
  });

  factory FoodCartDetail.fromJson(Map<String, dynamic> json) {
    return FoodCartDetail(
      foodId: json['foodId'],
      foodName: json['foodName'],
      price: json['price'],
      quantity: json['quantity'],
      note: json['note'],
      images: List<String>.from(json['images']['\$values']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'quantity': quantity,
      'note': note,
      'images': {
        '\$values': images,
      },
    };
  }

  FoodCartDetail copyWith({
    String? foodId,
    String? foodName,
    int? quantity,
    String? note,
    List<String>? images,
  }) {
    return FoodCartDetail(
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      images: images ?? this.images,
    );
  }

  CartDetail toCartDetail({required String orderId}) {
    return CartDetail(
      orderId: orderId,
      foodId: foodId,
      quantity: quantity,
      note: note,
    );
  }

  static FoodCartDetail fromCartDetail(
    CartDetail cartDetail, {
    String foodName = 'Unknown',
    List<String> images = const [],
    double price = 0.0, // Thêm price vào tham số
  }) {
    return FoodCartDetail(
      foodId: cartDetail.foodId,
      foodName: foodName,
      price: price,
      // Thêm price
      quantity: cartDetail.quantity,
      note: cartDetail.note,
      images: images,
    );
  }
}
