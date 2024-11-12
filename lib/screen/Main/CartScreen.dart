import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_1_btl/blocs/Cart/CartBloc.dart';
import 'package:project_1_btl/blocs/Cart/CartEvent.dart';
import 'package:project_1_btl/blocs/Cart/CartState.dart';
import 'package:project_1_btl/model/FoodCartDetail.dart';
import 'package:project_1_btl/screen/Order/OrderConfirmScreen.dart';
import 'package:project_1_btl/screen/item/ItemCart.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String orderId;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: MyText(
                text: "Xóa Tất Cả",
                size: 13,
                color: Colors.orange,
                weight: FontWeight.w300,
              ),
              onTap: () {
                BlocProvider.of<CartBloc>(context)
                    .add(DeleteAllCartDetailsEvent(orderId: orderId));
              },
            ),
            const Text(
              'Giỏ hàng',
              style: TextStyle(color: Colors.black),
            ),
            const Icon(Icons.close, size: 27, color: Colors.black),
          ],
        ),
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoadedState) {
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CartErrorState) {
                    return Center(child: Text(state.message));
                  } else {
                    return cartDetails.isEmpty
                        ?  Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/emptycart.png', // Path to your image
                                  width: 80, // Adjust size as needed
                                  height: 80, // Adjust size as needed
                                ),
                                SizedBox(height: 10),
                                // Spacing between the image and text
                                Text(
                                  'Giỏ hàng trống',
                                  style: TextStyle(
                                    fontSize: 18, // Adjust text size as needed
                                    color: Colors
                                        .grey, // Change text color if needed
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: cartDetails.length,
                            itemBuilder: (context, index) {
                              final cartDetail = cartDetails[index];
                              return ItemCart(
                                size: MediaQuery.of(context).size,
                                cartDetail: cartDetail,
                                orderId: orderId,
                              );
                            },
                          );
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        // Handle purchase action
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OrderConfirmScreen(orderId: orderId)));
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
              ),
          ],
        ),
      ),
    );
  }
}
