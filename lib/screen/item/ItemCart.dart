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
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: size.width * 0.8,
          child: Row(
            children: [
              Image.network(
                cartDetail.images[0],
                width: 80,
                height: 80,
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
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      MyText(
                        text: cartDetail.foodName,
                        size: 20,
                        color: Colors.black,
                        weight: FontWeight.w600,
                        family: "RobotoRegular",
                      ),
                      Row(
                        children: [
                          MyText(
                            text: cartDetail.price.toString(),
                            size: 20,
                            color: Colors.black,
                            weight: FontWeight.w600,
                          ),
                          SizedBox(width: 20,),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.indeterminate_check_box),
                                onPressed: () {
                                  if (cartDetail.quantity > 1) {
                                    context.read<CartBloc>().add(UpdateCartDetailEvent(
                                      cartDetail.toCartDetail(orderId: orderId).copyWith(quantity: -1),
                                    ));
                                  } else {
                                    // Khi quantity == 1 và nút trừ được nhấn, xóa item khỏi giỏ hàng
                                    context.read<CartBloc>().add(DeleteCartDetailEvent(
                                      orderId,
                                      cartDetail.foodId,
                                    ));
                                  }
                                },
                              ),
                              MyText(
                                text: cartDetail.quantity.toString(),
                                size: 20,
                                color: Colors.black,
                                weight: FontWeight.w600,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_box_sharp),
                                onPressed: () {
                                  context.read<CartBloc>().add(UpdateCartDetailEvent(
                                    cartDetail.toCartDetail(orderId: orderId).copyWith(quantity: 1),
                                  ));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context.read<CartBloc>().add(DeleteCartDetailEvent(
                                    orderId,
                                    cartDetail.foodId,
                                  ));
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    ],),

                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
