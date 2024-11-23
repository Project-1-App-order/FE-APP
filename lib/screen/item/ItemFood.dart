import 'package:flutter/material.dart';
import 'package:project_1_btl/model/Food.dart';
import 'package:project_1_btl/screen/detail/DetailFoodScreen.dart';
import 'package:project_1_btl/utils/constants.dart';
//import 'package:project_1_btl/screen/Detail/DetailFoodScreen.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemFood extends StatelessWidget {
  final Size size;
  final Food food;
  const ItemFood({super.key, required this.food, required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        width: size.width * 0.8,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Bo góc ảnh
                  child: Image.network(
                    food.images[0],
                    width: 80,
                    height: 80,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/image_food.jpg", // Fallback image in case of error
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    text: food.foodName,
                    size: 20,
                    color: Colors.black,
                    weight: FontWeight.w500,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    food.price.toInt().toString() + ' đ',
                    style: TextStyle(
                      fontSize: 18,
                      color: ColorApp.brightOrangeColor,
                      fontFamily: "Roboto-Light.ttf",
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailFoodScreen(foodId: food.foodId)),
        );
      },
    );
  }
}
