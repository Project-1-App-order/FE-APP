import 'package:flutter/material.dart';
import 'package:project_1_btl/model/CartDetail.dart';
import 'package:project_1_btl/model/Food.dart';
import 'package:project_1_btl/repository/CartRepository.dart';
import 'package:project_1_btl/repository/FoodRepository.dart';
import 'package:project_1_btl/services/CartService.dart';
import 'package:project_1_btl/services/FoodService.dart';
import 'package:project_1_btl/widgets/CenterCircularProgress.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/SnackBarHelper.dart';
import 'package:project_1_btl/widgets/ToastHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailFoodScreen extends StatelessWidget {
  final String foodId;

  const DetailFoodScreen({super.key, required this.foodId});

  @override
  Widget build(BuildContext context) {
    final FoodRepository foodRepository = FoodRepository(FoodService());
    final CartRepository cartRepository = CartRepository(CartService());

    void addOrUpdateCartDetail(Food food) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? orderId = prefs.getString('orderId');

      CartDetail cartDetail = CartDetail(
        orderId: orderId!, // Thay thế bằng logic ID đơn hàng thực tế của bạn
        foodId: food.foodId,
        quantity: 1,
        note: 'Đang thêm từ màn hình chi tiết',
      );

      bool success = await cartRepository.addOrUpdateCartDetail(cartDetail);
      if (success) {
        SnackBarHelper.showSimpleSnackBar(
          context: context,
          message: "Món ăn đã được thêm vào giỏ hàng!",
        );
      } else {
        SnackBarHelper.showSimpleSnackBar(
          context: context,
          message: "Món ăn thêm vào giỏ hàng thất bại!",
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Food>(
        future: foodRepository.getDetailFoodById(foodId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CenteredCircularProgress();
          } else if (snapshot.hasError) {
            return CenteredCircularProgress();
          } else if (!snapshot.hasData) {
            return Center(child: Text("Không có dữ liệu"));
          } else {
            final food = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stack chỉ chứa hình ảnh và mũi tên quay lại
                  Stack(
                    children: [
                      // Hình ảnh full-width với chiều cao 350
                      Container(
                        height: 350,
                        child: Hero(
                          tag: "image", // Đảm bảo tag là duy nhất
                          child: Image.network(
                            food.images[0].isNotEmpty
                                ? food.images[0]
                                : 'assets/images/image_food.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      // Mũi tên quay lại, cố định vị trí khi cuộn
                      Positioned(
                        top: 40, // Khoảng cách từ trên
                        left: 16, // Khoảng cách từ trái
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Quay lại màn hình trước
                          },
                        ),
                      ),
                    ],
                  ),
                  // Nội dung chi tiết sản phẩm dưới hình ảnh
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              text: food.foodName,
                              size: 20,
                              color: Colors.black,
                              weight: FontWeight.w600,
                            ),
                            GestureDetector(
                              onTap: () => addOrUpdateCartDetail(food),
                              child: Icon(
                                Icons.add_box,
                                color: Colors.red,
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        MyText(
                          text:
                          "Cơm rang thập cẩm là món ăn quen thuộc của ẩm thực Việt Nam, kết hợp hương vị phong phú từ nhiều nguyên liệu tươi ngon. Mỗi đĩa cơm rang bao gồm cơm trắng rang cùng trứng gà, có độ giòn vừa phải, kết hợp cùng các loại rau củ như cà rốt, đậu Hà Lan, ngô ngọt, và hành lá. Bên cạnh đó, cơm còn được xào với các loại thịt đa dạng như tôm, thịt bò, thịt gà hoặc xúc xích, mang đến vị đậm đà và thơm ngon.",
                          size: 15,
                          color: Colors.grey,
                          weight: FontWeight.w600,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          food.price.toString() + " Đ",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),
                        Divider(color: Colors.grey, height: 2),
                        SizedBox(height: 20),
                        MyText(
                          text: "Hình ảnh món ăn",
                          size: 20,
                          color: Colors.black,
                          weight: FontWeight.w600,
                        ),
                        SizedBox(height: 10),
                        // Thư viện hình ảnh món ăn
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: food.images.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  food.images[index],
                                  fit: BoxFit.cover,
                                  width: 300, // Đặt chiều rộng cho mỗi hình ảnh
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
