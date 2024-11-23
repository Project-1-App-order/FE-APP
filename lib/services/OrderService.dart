import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_1_btl/model/CartDetail.dart';
import 'package:project_1_btl/model/Order.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static String url = AppUrl.UrlApi;
  // Phương thức tạo đơn hàng
  Future<String?> createOrder(Order order) async {
    final urlApi = Uri.parse(url + '/Orders/CreateOrder');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode(order.toJson());
    print("Body : " + body);

    try {
      final response = await http.post(urlApi, headers: headers, body: body);
      print("Response : " + response.body);  // In ra phản hồi của API
      print("Response StatusCode : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        try {
          print("200 + 1");
          final Map<String, dynamic> responseData = json.decode(response.body);
          print("200 + 2");
          print("Response Data : " + responseData.toString());
          final String orderId = responseData['orderId'];
          print('Đơn hàng đã được tạo thành công với orderId: $orderId');
          return orderId;
        } catch (e) {
          print('Lỗi khi giải mã JSON: $e');
          return null;
        }
      } else {
        print('Không thể tạo đơn hàng: ${response.statusCode}');
        print('Nội dung phản hồi: ${response.body}');
        return null;
      }


    } catch (e) {
      print('Lỗi khi tạo đơn hàng: $e');
      return null;
    }
  }

  static  String _url = url + '/Orders/AddAndDeleteOrderDetail';

  // Phương thức để gửi chi tiết đơn hàng đến API
  Future<bool> sendOrderDetails(List<CartDetail> orderDetails) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? orderId = prefs.getString('orderId');

    // Thêm tham số vào URL
    final Uri url = Uri.parse('$_url?detailCartIdDelete=$orderId');

    final String? token = prefs.getString('auth_token');

    // Dữ liệu JSON cần gửi
    String jsonBody = jsonEncode(orderDetails);

    // Gửi yêu cầu POST đến API
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody,
      );

      // Kiểm tra phản hồi từ server
      if (response.statusCode == 200) {
        print('Thành công khi gửi chi tiết đơn hàng: ${response.statusCode}');
        return true; // Yêu cầu thành công
      } else {
        print('Không thể gửi chi tiết đơn hàng: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Lỗi khi gửi chi tiết đơn hàng: $e');
      return false;
    }
  }
}
