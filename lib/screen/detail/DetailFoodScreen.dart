import 'package:flutter/material.dart';
import 'package:project_1_btl/model/Food.dart';
import 'package:project_1_btl/repository/FoodRepository.dart';
import 'package:project_1_btl/services/FoodService.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class DetailFoodScreen extends StatelessWidget {
  final String foodId;

  const DetailFoodScreen({super.key, required this.foodId});

  @override
  Widget build(BuildContext context) {
    final FoodRepository foodRepository = FoodRepository(FoodService());

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Food>(
        future: foodRepository.getDetailFoodById(foodId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No data available"));
          } else {
            final food = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stack only contains image and back arrow
                  Stack(
                    children: [
                      // Full-width image with height of 350
                      Container(
                        height: 350,
                        child: Hero(
                          tag: foodId, // Đảm bảo tag là duy nhất
                          child: Image.network(
                            food.images[0].isNotEmpty
                                ? food.images[0]
                                : 'assets/images/image_food.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      // Back arrow, stays in place when scrolling
                      Positioned(
                        top: 40, // Distance from top
                        left: 16, // Distance from left
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Go back to previous screen
                          },
                        ),
                      ),
                    ],
                  ),
                  // Product details content below image
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
                            Icon(
                              Icons.add_box,
                              color: Colors.red,
                              size: 36,
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
                        // Food image gallery
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
                                  width: 300, // Set width for each image
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
