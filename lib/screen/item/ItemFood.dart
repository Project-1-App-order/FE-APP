import 'package:flutter/material.dart';
//import 'package:project_1_btl/screen/Detail/DetailFoodScreen.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemFood extends StatelessWidget {
  final Size size;
  final String title;

  const ItemFood({super.key, required this.size, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10),
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
                  MyText(
                      text: title,
                      size: 15,
                      color: Colors.black,
                      weight: FontWeight.w300),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(Icons.star, size: 15, color: Colors.amberAccent),
                      SizedBox(width: 5),
                      Text("4.9"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '70000đ',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10,),
                      MyText(
                          text: "60000đ",
                          size: 16,
                          color: Colors.black,
                          weight: FontWeight.w500),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailFoodScreen()));
      },
    );
  }
}
