import 'package:project_1_btl/model/CartDetail.dart';
import 'package:project_1_btl/model/FoodCartDetail.dart';

abstract class CartEvent {}

class FetchCartEvent extends CartEvent {}

class AddCartDetailEvent extends CartEvent {
  final CartDetail cartDetail;
  AddCartDetailEvent(this.cartDetail);
}

class UpdateCartDetailEvent extends CartEvent {
  final CartDetail cartDetail;
  UpdateCartDetailEvent(this.cartDetail);
}

class DeleteCartDetailEvent extends CartEvent {
  final String orderId;
  final String foodId;
  DeleteCartDetailEvent(this.orderId, this.foodId);
}

class DeleteAllCartDetailsEvent extends CartEvent {
  final String orderId;
  DeleteAllCartDetailsEvent({required this.orderId});
}

class CartLoadedEvent extends CartEvent {
  final List<FoodCartDetail> cartDetails;
  CartLoadedEvent(this.cartDetails);
}

class UpdateCartDetailItemEvent extends CartEvent {
  final FoodCartDetail cartDetail;
  UpdateCartDetailItemEvent(this.cartDetail);
}
