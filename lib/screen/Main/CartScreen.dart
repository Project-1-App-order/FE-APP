import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_1_btl/blocs/Cart/CartBloc.dart';
import 'package:project_1_btl/blocs/Cart/CartEvent.dart';
import 'package:project_1_btl/blocs/Cart/CartState.dart';
import 'package:project_1_btl/model/FoodCartDetail.dart';
import 'package:project_1_btl/screen/Order/OrderConfirmScreen.dart';
import 'package:project_1_btl/screen/item/ItemCart.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/CenterCircularProgress.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String orderId = '';
  List<FoodCartDetail> cartDetails = [];

  @override
  void initState() {
    super.initState();
    _loadOrderId();
  }

  Future<void> _loadOrderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      orderId = prefs.getString('orderId') ?? '';
    });

    // Fetch cart details after retrieving orderId
    if (orderId.isNotEmpty) {
      context.read<CartBloc>().add(FetchCartEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tính tổng tiền của các sản phẩm trong giỏ
    double total =
        cartDetails.fold(0, (sum, item) => sum + item.price * item.quantity);

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFFAFAFA),
        title: Row(
          children: [
            InkWell(
              child: MyText(
                text: "Xóa Tất Cả",
                size: 13,
                color: ColorApp.brightOrangeColor,
                weight: FontWeight.w600,
              ),
              onTap: () {
                BlocProvider.of<CartBloc>(context)
                    .add(DeleteAllCartDetailsEvent(orderId: orderId));
              },
            ),
            Spacer(),  // Thêm Spacer để tạo khoảng cách
            Center(
              child: const Text(
                'Giỏ hàng',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Spacer(),  // Thêm Spacer để căn giữa
          ],
        )

      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoadingState) {
            // Hiển thị spinner loading trong khi chờ dữ liệu
          } else if (state is CartLoadedState) {
            setState(() {
              cartDetails = state.cartDetails;
            });
          } else if (state is CartItemUpdatedState) {
            setState(() {
              // Cập nhật item cụ thể
              int index = cartDetails.indexWhere(
                  (item) => item.foodId == state.updatedItem.foodId);
              if (index != -1) {
                cartDetails[index] =
                    state.updatedItem; // Update the specific item
              }
            });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoadingState) {
                    return CenteredCircularProgress();
                  } else if (state is CartErrorState) {
                    return Center(child: Text(state.message));
                  } else if (state is CartLoadedState) {
                    if (state.cartDetails.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/emptycart.png',
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Giỏ hàng trống',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: state.cartDetails.length,
                        itemBuilder: (context, index) {
                          final cartDetail = state.cartDetails[index];
                          return ItemCart(
                            size: MediaQuery.of(context).size,
                            cartDetail: cartDetail,
                            orderId: orderId,
                          );
                        },
                      );
                    }
                  }else{
                    return CenteredCircularProgress();
                  }
                },
              ),
            ),
            const Divider(height: 2, color: Colors.grey),
            if (cartDetails
                .isNotEmpty) // Only show the button if cart is not empty
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: "Tổng: $total đ", // Cập nhật tổng giá trị
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.bold,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Không bo góc để tạo hình chữ nhật
                        ),
                      ),
                      onPressed: () {
                        // Handle purchase action
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmScreen(orderId: orderId),
                          ),
                        );
                      },
                      child: MyText(
                        text: "Đặt mua",
                        size: 16,
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )

          ],
        ),
      ),
    );
  }
}
