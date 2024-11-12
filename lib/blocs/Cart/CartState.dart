import 'package:project_1_btl/model/FoodCartDetail.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<FoodCartDetail> cartDetails;
  CartLoadedState(this.cartDetails);
}

class CartErrorState extends CartState {
  final String message;
  CartErrorState(this.message);
}

class CartSuccessState extends CartState {
  final String successMessage;
  CartSuccessState(this.successMessage);
}
class CartItemUpdatedState extends CartState {
  final FoodCartDetail updatedItem;
  CartItemUpdatedState(this.updatedItem);
}
