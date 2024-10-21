import 'package:flutter/material.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemCart extends StatelessWidget {
  final Size size;
  final String title;

  const ItemCart({super.key, required this.size, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: size.width * 0.8,

      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Image.asset(
              "assets/images/image_food.jpg",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(text: title, size: 15, color: Colors.black, weight: FontWeight.w300),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.star, size: 15, color: Colors.amberAccent),
                        SizedBox(width: 5),
                        Text("4.9"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.indeterminate_check_box, size: 25,),
                        const SizedBox(width: 10),
                        MyText(text: "1", size: 18, color: Colors.black, weight: FontWeight.w500),
                        const SizedBox(width: 10),
                        Icon(Icons.add_box_sharp,  size: 25,),
                        const SizedBox(width: 10),
                        Icon(Icons.delete,  size: 25,),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MyText(text: "42000đ", size: 12, color: Colors.orange, weight: FontWeight.w300),

              ],
            ),
          ),
        ],
      ),
    );
  }
}