import 'package:flutter/material.dart';
import 'package:project_1_btl/model/CartDetail.dart';
import 'package:project_1_btl/model/FoodCartDetail.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/repository/CartRepository.dart';
import 'package:project_1_btl/repository/OrderRepository.dart';
import 'package:project_1_btl/screen/Main/MainScreen.dart';
import 'package:project_1_btl/screen/UserSetting/UserInformationScreen.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/services/CartService.dart';
import 'package:project_1_btl/services/OrderService.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Thay bằng đường dẫn thật đến màn hình updateUserInformation

class OrderConfirmScreen extends StatefulWidget {
  final String orderId;

  const OrderConfirmScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderConfirmScreenState createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  final AuthRepository authRepository = AuthRepository(AuthService());
  final CartRepository cartRepository = CartRepository(CartService());
  final OrderRepository orderRepository =
      OrderRepository(OrderService(), CartService());

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedGender;
  late Future<Map<String, dynamic>> _userInformationFuture;
  late Future<List<FoodCartDetail>?> _cartDetailsFuture;
  String tokenOrder = "token";

  @override
  void initState() {
    super.initState();
    _userInformationFuture = _loadUserInformation();
    _cartDetailsFuture =
        cartRepository.getAllCartDetailByCartId(widget.orderId);
  }

  Future<Map<String, dynamic>> _loadUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    try {
      final userInfo = await authRepository.getUserInformation();
      setState(() {
        tokenOrder = token!;
        userNameController.text = userInfo['fullName'] ?? '';
        phoneController.text = userInfo['phoneNumber'] ?? '';
        emailController.text = userInfo['email'] ?? '';
        addressController.text = userInfo['address'] ?? '';
        selectedGender =
            (userInfo['gender'] == 'Nam' || userInfo['gender'] == 'Nữ')
                ? userInfo['gender']
                : null;
      });
      return userInfo;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user information: $error')),
      );
      return {};
    }
  }

  double _calculateTotalPrice(List<FoodCartDetail> cartItems) {
    return cartItems.fold(
        0, (total, item) => total + (item.price * item.quantity));
  }

  void _showMissingInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông tin thiếu"),
          content: Text("Vui lòng điền số điện thoại và địa chỉ của bạn."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserInformationScreen(), // Chuyển sang màn hình updateUserInformation
                  ),
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _handlePlaceOrder() {
    if (phoneController.text.isEmpty || addressController.text.isEmpty) {
      _showMissingInfoDialog(); // Hiển thị dialog nếu thông tin thiếu
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đặt hàng thành công!")),
      );
    }
  }

  void _handleSendOrder() async {
    print("1");
    if (phoneController.text.isEmpty || addressController.text.isEmpty) {
      _showMissingInfoDialog(); // Show the dialog if info is missing
    } else {
      try {
        // Convert the cart details to CartDetail

          // Send the API request to place the order
          final response = await orderRepository.sendOrderFromCart();

          if (response == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Đặt hàng thành công!")),
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lỗi khi đặt hàng, vui lòng thử lại " + response.toString())),
            );
          }
          print("2");
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi đặt hàng: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Xác nhận đơn hàng"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _userInformationFuture,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (userSnapshot.hasError ||
                userSnapshot.data == null ||
                userSnapshot.data!.isEmpty) {
              return Center(child: Text("Lỗi khi tải thông tin người dùng"));
            }

            final userInfo = userSnapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tên: ${userInfo['fullName']}"),
                Text("Số điện thoại: ${userInfo['phoneNumber']}"),
                Text("Địa chỉ: ${userInfo['address']}"),
                SizedBox(height: 10),
                FutureBuilder<List<FoodCartDetail>?>(
                  future: _cartDetailsFuture,
                  builder: (context, cartSnapshot) {
                    if (cartSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (cartSnapshot.hasError ||
                        cartSnapshot.data == null ||
                        cartSnapshot.data!.isEmpty) {
                      return Center(child: Text("Giỏ hàng trống"));
                    }

                    final cartItems = cartSnapshot.data!;
                    final totalPrice = _calculateTotalPrice(cartItems);

                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                              "Tổng tiền: ${totalPrice.toStringAsFixed(2)} VND",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 20),
                          Text("Danh sách món ăn:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Expanded(
                            child: ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    leading: Image.network(
                                      item.images.isNotEmpty
                                          ? item.images[0]
                                          : 'https://via.placeholder.com/150',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(item.foodName),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Giá: ${item.price} VND"),
                                        Text("Số lượng: ${item.quantity}"),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _handleSendOrder();
                        print("send order");
                      },
                      child: Text("Đặt mua")),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
