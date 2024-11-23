import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_1_btl/blocs/Cart/CartBloc.dart';
import 'package:project_1_btl/blocs/Cart/CartEvent.dart';
import 'package:project_1_btl/blocs/Cart/CartState.dart';
import 'package:project_1_btl/model/FoodCartDetail.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemCart extends StatelessWidget {
  final Size size;
  final FoodCartDetail cartDetail;
  final String orderId;

  const ItemCart({
    Key? key,
    required this.size,
    required this.cartDetail,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) {
        if (current is CartItemUpdatedState) {
          // Kiểm tra chỉ cập nhật nếu item hiện tại thay đổi
          return current.updatedItem.foodId == cartDetail.foodId;
        }
        return false;
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: double.infinity,
            //height: 135,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFfae3e2).withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    // Phần 1: Hình ảnh
                    Flexible(
                      flex: 4, // Chiếm 20%
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), // Bo góc ảnh
                        child: Image.network(
                          cartDetail.images[0],
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/image_food.jpg",
                              width: 80,
                              height: 80,
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Phần 2: Tên, giá, số lượng
                    Flexible(
                      flex: 8, // Chiếm 60%
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          // Tên sản phẩm
                          MyText(
                            text: cartDetail.foodName,
                            size: 18,
                            color: const Color(0xFF3a3a3b),
                            weight: FontWeight.w600,
                            family: "Roboto-Light.ttf",
                          ),
                          SizedBox(height: 5,),
                          // Giá sản phẩm
                          MyText(
                            text: "${cartDetail.price} VNĐ",
                            size: 17,
                            color: const Color(0xFF3a3a3b),
                            weight: FontWeight.w500,
                          ),
                          // Row: Thêm/Bớt số lượng
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if (cartDetail.quantity > 1) {
                                    context.read<CartBloc>().add(UpdateCartDetailEvent(
                                      cartDetail
                                          .toCartDetail(orderId: orderId)
                                          .copyWith(quantity: -1),
                                    ));
                                  } else {
                                    context.read<CartBloc>().add(DeleteCartDetailEvent(
                                      orderId,
                                      cartDetail.foodId,
                                    ));
                                  }
                                },
                              ),
                              MyText(
                                text: cartDetail.quantity.toString(),
                                size: 18,
                                color: Colors.black,
                                weight: FontWeight.w600,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  context.read<CartBloc>().add(UpdateCartDetailEvent(
                                    cartDetail
                                        .toCartDetail(orderId: orderId)
                                        .copyWith(quantity: 1),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Phần 3: Thùng rác
                    Flexible(
                      flex: 2, // Chiếm 20%
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<CartBloc>().add(DeleteCartDetailEvent(
                            orderId,
                            cartDetail.foodId,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );


      },
    );
  }
}
