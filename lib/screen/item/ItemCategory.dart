import 'package:flutter/material.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemCategory extends StatelessWidget {
  final String title; // Title to display
  final String imageUrl; // URL for the image

  const ItemCategory({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 130,
      padding: EdgeInsets.only(right: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Image.network(
              imageUrl,
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
            ), // Image from network
            SizedBox(height: 10),
            // Container to constrain the width of the text
            Container(
              width: 80,
              height: 40,// Set to the width of the image
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 2, // Limit to 2 lines
                  overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                ),
              ),
            ),
          ],
        ),
    );
  }
}
