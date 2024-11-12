import 'package:project_1_btl/model/CartDetail.dart';
import 'package:project_1_btl/model/FoodCartDetail.dart';
import 'package:project_1_btl/services/CartService.dart';

class CartRepository {
  final CartService _cartService = CartService();

  CartRepository(CartService cartService);

  Future<String?> fetchCart() {
    return _cartService.fetchCart();
  }

  // Phương thức thêm chi tiết giỏ hàng
  Future<bool> addCartDetail(CartDetail cartDetail) {
    return _cartService.addCartDetail(cartDetail);
  }

  // Phương thức cập nhật chi tiết giỏ hàng
  Future<bool> updateCartDetail(CartDetail cartDetail) {
    return _cartService.updateCartDetail(cartDetail);
  }

  // Phương thức xóa chi tiết giỏ hàng theo foodId và orderId
  Future<bool> deleteCartDetail(String orderId, String foodId) {
    return _cartService.deleteCartDetail(orderId, foodId);
  }

  // Phương thức xóa tất cả chi tiết giỏ hàng theo orderId
  Future<bool> deleteAllOrderDetailByOrderId(String orderId) {
    return _cartService.deleteAllOrderDetailByOrderId(orderId);
  }

  Future<List<FoodCartDetail>?> getAllCartDetailByCartId(String cartId) {
    return _cartService.getAllCartDetailByCartId(cartId);
  }

  Future<bool> addOrUpdateCartDetail(CartDetail cartDetail){
    return _cartService.addOrUpdateCartDetail(cartDetail);
  }
}
