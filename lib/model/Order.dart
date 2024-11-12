class Order {
  final String userId;
  final int orderStatus;
  final String orderNote;

  Order({
    required this.userId,
    required this.orderStatus,
    required this.orderNote,
  });

  // Phương thức chuyển đối tượng Order thành JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'orderStatus': orderStatus,
      'orderNote': orderNote,
    };
  }
}
