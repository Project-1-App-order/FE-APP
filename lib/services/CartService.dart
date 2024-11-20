import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_1_btl/model/CartDetail.dart';
import 'package:project_1_btl/model/Category.dart';
import 'package:project_1_btl/model/FoodCartDetail.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static String url = AppUrl.UrlApi;
  final String baseUrlCart = url;

  Future<String?> fetchCart() async {
    final url = Uri.parse('$baseUrlCart/GetCart');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orderId = data['result'][0]['orderId'];
        return orderId;
      } else {
        print('Tải dữ liệu giỏ hàng không thành công: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Lỗi khi tải giỏ hàng: $e');
      return null;
    }
  }

  final String baseUrl = url;

  Future<bool> addCartDetail(CartDetail cartDetail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    print("Token: " + token!);

    final url = Uri.parse('$baseUrl/CartDetail/AddCartDetail');
    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(cartDetail.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Thêm vào giỏ hàng thành công: ${response.body}');
      return true;
    } else if (response.statusCode == 409) {
      print('Thêm vào giỏ hàng không thành công: ${response.body}');
      return false;
    } else {
      print('Thêm vào giỏ hàng thất bại: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> updateCartDetail(CartDetail cartDetail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    final url = Uri.parse('$baseUrl/CartDetail/UpdateCartDetail');
    final response = await http.put(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(cartDetail.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Cập nhật giỏ hàng thành công: ${response.body}');
      return true;
    } else {
      print('Cập nhật giỏ hàng không thành công: ${response.body}');
      return false;
    }
  }

  Future<bool> deleteCartDetail(String orderId, String foodId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    final url = Uri.parse('$baseUrl/CartDetail/DeleteCartDetail?orderId=$orderId&foodId=$foodId');
    final response = await http.delete(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Xóa khỏi giỏ hàng thành công: ${response.body}');
      return true;
    } else {
      print('Xóa khỏi giỏ hàng không thành công: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> deleteAllOrderDetailByOrderId(String orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    final String? orderId = prefs.getString('orderId');

    final url = Uri.parse('$baseUrl/CartDetail/DeleteAllOrderDetailByOrderId?orderId=$orderId');
    final response = await http.delete(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Xóa tất cả khỏi giỏ hàng thành công: ${response.body}');
      return true;
    } else {
      print('Xóa tất cả khỏi giỏ hàng không thành công: ${response.body}');
      return false;
    }
  }

  Future<List<FoodCartDetail>?> getAllCartDetailByCartId(String cartId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    print("Token Tất Cả Giỏ Hàng: " + token!);
    print("Mã Giỏ Hàng: " + cartId);

    final url = Uri.parse('$baseUrl/CartDetail/GetAllCartDetailByCartId?cartId=$cartId');
    final response = await http.get(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Tải thành công");
      final data = jsonDecode(response.body);
      final List<FoodCartDetail> cartDetails = (data['\$values'] as List)
          .map((cartDetail) => FoodCartDetail.fromJson(cartDetail))
          .toList();
      return cartDetails;
    } else {
      print('Tải chi tiết giỏ hàng không thành công: ${response.statusCode}');
      return null;
    }
  }

  Future<bool> addOrUpdateCartDetail(CartDetail cartDetail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? orderId = prefs.getString('orderId');

    List<FoodCartDetail>? cartDetails = await getAllCartDetailByCartId(orderId!);

    print("Mã Đơn Hàng: " + orderId);

    bool productExists = cartDetails?.any((item) => item.foodId == cartDetail.foodId) ?? false;

    if (productExists) {
      bool updated = await updateCartDetail(cartDetail);
      if (updated) {
        print("Cập nhật CartDetail thành công.");
        return true;
      } else {
        print("Cập nhật CartDetail không thành công.");
        return false;
      }
    } else {
      bool added = await addCartDetail(cartDetail);
      if (added) {
        print("Thêm CartDetail thành công.");
        return true;
      } else {
        print("Thêm CartDetail không thành công.");
        return false;
      }
    }
  }
}
