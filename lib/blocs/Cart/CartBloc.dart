import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_1_btl/blocs/Cart/CartEvent.dart';
import 'package:project_1_btl/blocs/Cart/CartState.dart';
import 'package:project_1_btl/model/CartDetail.dart';
import 'package:project_1_btl/model/FoodCartDetail.dart';
import 'package:project_1_btl/repository/CartRepository.dart';
import 'package:project_1_btl/services/CartService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  List<FoodCartDetail> cartDetails = [];

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<FetchCartEvent>((event, emit) async {
      emit(CartLoadingState());
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? orderId = prefs.getString('orderId');

        if (orderId != null) {
          cartDetails = await cartRepository.getAllCartDetailByCartId(orderId) ?? [];
          emit(CartLoadedState(cartDetails));
        } else {
          emit(CartErrorState('Failed to fetch cart.'));
        }
      } catch (e) {
        emit(CartErrorState('Error: $e'));
      }
    });

    on<AddCartDetailEvent>((event, emit) async {
      try {
        bool success = await cartRepository.addCartDetail(event.cartDetail);
        if (success) {
          final newItem = FoodCartDetail.fromCartDetail(event.cartDetail);
          cartDetails.add(newItem);
          emit(CartLoadedState(List.from(cartDetails))); // Phát lại danh sách đã cập nhật
        } else {
          emit(CartErrorState('Failed to add cart detail.'));
        }
      } catch (e) {
        emit(CartErrorState('Error: $e'));
      }
    });

    on<UpdateCartDetailEvent>((event, emit) async {
      try {
        bool success = await cartRepository.updateCartDetail(event.cartDetail);

        print("đã load đến success : ");
        if (success) {
          // Lấy foodId từ cartDetail
          final foodId = event.cartDetail.foodId;

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? orderId = prefs.getString('orderId');

          // Lấy danh sách chi tiết giỏ hàng từ repository
          final allCartDetails = await cartRepository.getAllCartDetailByCartId(orderId!);

          print("đã load đến đây : ");
          // Tìm item có foodId tương ứng trong danh sách cartDetails
          final updatedItem = allCartDetails?.firstWhere(
                (item) => item.foodId == foodId,
            orElse: () => FoodCartDetail(
              foodId: '',
              foodName: 'Unknown',
              price: 0.0,
              quantity: 0,
              note: '',
              images: [],
            ), // Trả về null nếu không tìm thấy item
          );

          if (updatedItem != null) {
            // Tìm index của item trong danh sách hiện tại (cartDetails)
            int index = cartDetails.indexWhere((item) => item.foodId == updatedItem.foodId);

            print("INdex + " + index.toString());

            if (index != -1) {
              // Cập nhật item trong cartDetails
              cartDetails[index] = updatedItem;
              emit(CartLoadedState(List.from(cartDetails))); // Phát lại danh sách đã cập nhật
            } else {
              // Xử lý nếu không tìm thấy item trong danh sách
              emit(CartErrorState('Item not found in cart.'));
            }
          } else {
            // Xử lý nếu không tìm thấy updatedItem trong danh sách allCartDetails
            emit(CartErrorState('Food item not found.'));
          }
        } else {
          emit(CartErrorState('Failed to update cart detail.'));
        }
      } catch (e) {
        emit(CartErrorState('Error: $e'));
      }
    });


    on<DeleteCartDetailEvent>((event, emit) async {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? orderId = prefs.getString('orderId');

        bool success = await cartRepository.deleteCartDetail(orderId!, event.foodId);
        if (success) {
          cartDetails.removeWhere((item) => item.foodId == event.foodId);
          emit(CartLoadedState(List.from(cartDetails))); // Phát lại danh sách đã cập nhật
        } else {
          emit(CartErrorState('Failed to delete cart detail.'));
        }
      } catch (e) {
        emit(CartErrorState('Error: $e'));
      }
    });

    on<DeleteAllCartDetailsEvent>((event, emit) async {
      try {
        bool success = await cartRepository.deleteAllOrderDetailByOrderId(event.orderId);
        if (success) {
          cartDetails.clear();
          emit(CartLoadedState(List.from(cartDetails))); // Phát lại danh sách rỗng
        } else {
          emit(CartErrorState('Failed to delete all cart details.'));
        }
      } catch (e) {
        emit(CartErrorState('Error: $e'));
      }
    });
  }
}

