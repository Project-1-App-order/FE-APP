import 'package:flutter/material.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class ItemUserInfo extends StatelessWidget {
  final String title;
  final String value;
  const ItemUserInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(text: title, size: 18, color: Colors.black, weight: FontWeight.w300),
          Row(
            children: [
              MyText(text: value, size: 18, color: Colors.black, weight: FontWeight.w300),
              SizedBox(width: 15,),
              Icon(Icons.keyboard_arrow_right)
            ],
          )

        ],
      ),
    );
  }
}
