class CartDetail {
  final String orderId;
  final String foodId;
  final int quantity;
  final String note;

  CartDetail({
    required this.orderId,
    required this.foodId,
    required this.quantity,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'foodId': foodId,
      'quantity': quantity,
      'note': note,
    };
  }

  CartDetail copyWith({
    String? orderId,
    String? foodId,
    int? quantity,
    String? note,
  }) {
    return CartDetail(
      orderId: orderId ?? this.orderId,
      foodId: foodId ?? this.foodId,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
