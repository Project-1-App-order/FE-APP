import 'package:flutter/material.dart';
import 'package:project_1_btl/model/CartDetail.dart';
import 'package:project_1_btl/model/FoodCartDetail.dart';
import 'package:project_1_btl/model/Order.dart';
import 'package:project_1_btl/services/CartService.dart';
import 'package:project_1_btl/services/OrderService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepository {
  final OrderService _orderService;
  final CartService _cartService;

  // Constructor để tiêm các dịch vụ
  OrderRepository(this._orderService, this._cartService);

  // Phương thức để tạo đơn hàng và trả về orderId
  Future<String?> createOrder(Order order) async {
    return await _orderService.createOrder(order);
  }

  // Phương thức gửi đơn hàng từ giỏ hàng
  Future<bool> sendOrderFromCart() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? orderId = prefs.getString('orderId');
      final String? userId = prefs.getString('userId');

      print("User Id : " + userId!);
      print("Order Id : " + orderId!);

      // Kiểm tra sự hiện diện của userId và orderId
      if (userId == null || orderId == null) {
        print("Thiếu userId hoặc orderId trong SharedPreferences.");
        return false;
      }

      // Bước 1: Lấy thông tin chi tiết giỏ hàng
      List<FoodCartDetail>? cartDetails = await _cartService.getAllCartDetailByCartId(orderId);

      if (cartDetails == null || cartDetails.isEmpty) {
        print("Thông tin chi tiết giỏ hàng trống hoặc null.");
        return false;
      }

      // Bước 2: Tạo một đơn hàng mới
      Order order = Order(userId: userId, orderStatus: 0 , orderNote: "Ghi chú");
      final String? newOrderId = await createOrder(order);

      if (newOrderId == null) {
        print("Tạo đơn hàng không thành công.");
        return false;
      }

      // Bước 3: Chuyển đổi danh sách FoodCartDetail thành CartDetail với orderId mới
      List<CartDetail> orderDetails = cartDetails.map((foodCartDetail) {
        return CartDetail(
          orderId: newOrderId,
          foodId: foodCartDetail.foodId,
          quantity: foodCartDetail.quantity,
          note: foodCartDetail.note,
        );
      }).toList();

      // Bước 4: Gửi chi tiết đơn hàng
      bool result = await _orderService.sendOrderDetails(orderDetails);
      print("Kết quả gửi chi tiết đơn hàng: $result");
      return result;
    } catch (e) {
      print("Đã xảy ra lỗi: $e");
      return false;
    }
  }
}
