import 'package:flutter/material.dart';
import 'package:project_1_btl/model/Food.dart';
import 'package:project_1_btl/screen/detail/DetailFoodScreen.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemCategory extends StatelessWidget {
  final Food food;

  const ItemCategory({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to DetailFoodScreen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailFoodScreen(
              foodId: food.foodId,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white, // Loại bỏ background

        ),
        width: 90,
        height: 130,

        margin: EdgeInsets.only(right: 5),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Apply border radius
                child: Image.network(
                  food.images[0],
                  width: 78,
                  height: 78,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/image_food.jpg",
                      // Fallback image in case of error
                      width: double.infinity,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              // Container to constrain the width of the text
              Container(
                width: 80,
                height: 40, // Set to the width of the image
                child: Center(
                  child: Text(
                    food.foodName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Roboto-Light.ttf",
                    ),
                    maxLines: 2, // Limit to 2 lines
                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                  ),
                ),
              ),
            ],
          ),
        ),
      )

    );
  }
}
