import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double size;
  final String family;
  final Color color;
  final FontWeight weight;

  const MyText({
    Key? key,
    required this.text,
    required this.size , // Giá trị mặc định cho size
    this.family = "RobotoRegular" , // Giá trị mặc định cho font family
    required this.color , // Giá trị mặc định cho màu sắc
    required this.weight, // Giá trị mặc định cho độ dày
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontFamily: family,
        color: color,
        fontWeight: weight,
      ),
    );
  }
}
