import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/CenterCircularProgress.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/SnackBarHelper.dart';
import 'package:project_1_btl/widgets/ToastHelper.dart';
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
      SnackBarHelper.showSimpleSnackBar(
        context: context,
        message: "Tải thông tin người dùng thất bại !",
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0), // Góc vuông hoàn toàn
          ),
          content: MyText(
            text: "Vui lòng điền đầy đủ tên, số điện thoại và địa chỉ của bạn.",
            size: 16,
            color: Colors.black,
            weight: FontWeight.w400,
          ),
          actions: [
            // Nút "Hủy"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog mà không làm gì
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white, // Nền trắng
                side: BorderSide(
                  color: ColorApp.brightOrangeColor, // Viền màu cam
                  width: 2.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0), // Bo góc bằng 0
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 32.0,
                ),
              ),
              child: Text(
                "Hủy",
                style: TextStyle(
                  color: ColorApp.brightOrangeColor, // Chữ màu cam
                  fontSize: 18,
                  fontFamily: "Roboto-Light.ttf",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Nút "OK"
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng dialog
                // Điều hướng tới UserInformationScreen và chờ kết quả
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInformationScreen(),
                  ),
                );

                if (result == true) {
                  setState(() {
                    _userInformationFuture = _loadUserInformation(); // Tải lại thông tin người dùng
                  });
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: ColorApp.brightOrangeColor, // Nền cam
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0), // Bo góc bằng 0
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 32.0,
                ),
              ),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white, // Chữ màu trắng
                  fontSize: 18,
                  fontFamily: "Roboto-Light.ttf",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );



      },
    );
  }

  void _handleSendOrder() async {
    print("1");
    if (phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        userNameController.text.isEmpty) {
      _showMissingInfoDialog(); // Show the dialog if info is missing
    } else {
      try {
        // Convert the cart details to CartDetail

        // Send the API request to place the order
        final response = await orderRepository.sendOrderFromCart();

        if (response == true) {
          SnackBarHelper.showSimpleSnackBar(
            context: context,
            message: "Đặt hàng thành công",
          );
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Lỗi khi đặt hàng, vui lòng thử lại " +
                    response.toString())),
          );
        }
        print("2");
      } catch (error) {
        SnackBarHelper.showSimpleSnackBar(
          context: context,
          message: "Đặt hàng đã xảy ra lỗi!",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Xác nhận đơn hàng"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _userInformationFuture,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return CenteredCircularProgress();
            } else if (userSnapshot.hasError ||
                userSnapshot.data == null ||
                userSnapshot.data!.isEmpty) {
              return Center(child: Text("Lỗi khi tải thông tin người dùng"));
            }

            final userInfo = userSnapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                MyText(text: "Tên: ${userInfo['fullName']?? 'Chưa có'}", size: 17, color: Colors.black, weight: FontWeight.w500),
                MyText(text: "Số điện thoại: ${userInfo['phoneNumber']?? 'Chưa có'}", size: 17, color: Colors.black, weight: FontWeight.w500),
                MyText(text: "Địa chỉ: ${userInfo['address']?? 'Chưa có'}", size: 17, color: Colors.black, weight: FontWeight.w500),

                SizedBox(height: 10),
                FutureBuilder<List<FoodCartDetail>?>(
                  future: _cartDetailsFuture,
                  builder: (context, cartSnapshot) {
                    if (cartSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CenteredCircularProgress();
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

                          MyText(text: "Tổng tiền: ${totalPrice.toStringAsFixed(2)} VND", size: 17, color: Colors.black, weight: FontWeight.w500),
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
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xFFF8F8F8),
                                    ),
                                    // Màu nền xám nhạt
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        // Ảnh sản phẩm
                                        Container(
                                          width: 70, // Tăng kích thước ảnh
                                          height: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0), // Bo góc
                                            border: Border.all(
                                              color: const Color(0xFFCCCCCC), // Màu viền
                                              width: 2.0,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0), // Bo góc ảnh
                                            child: Image.network(
                                              item.images.isNotEmpty
                                                  ? item.images[0]
                                                  : 'https://via.placeholder.com/150',
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset(
                                                  "assets/images/image_food.jpg",
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Nội dung
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                item.foodName,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold, // Đậm
                                                  fontFamily: "Roboto-Light.ttf", // Font Roboto
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "Giá: ${item.price} VND",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold, // Đậm
                                                  fontFamily: "Roboto-Light.ttf", // Font Roboto
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "Số lượng: ${item.quantity}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold, // Đậm
                                                  fontFamily: "Roboto-Light.ttf", // Font Roboto
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                  child: InkWell(child:MyButton(size: size, title: "Đặt mua"), onTap: (){
                   _handleSendOrder();
            },
                  )
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
