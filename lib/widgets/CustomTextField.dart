import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final double iconSize;
  final bool obscureText;
  final Color background;
  final Color hintColor;
  final double width;
  final double height;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.icon,
    required this.iconSize,
    this.obscureText = false,
    required this.background,
    required this.hintColor,
    this.width = double.infinity,
    required this.height,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.orange),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto-Light.ttf",
                      fontSize: 18),
                  showCursor: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFffffff),
                    hintStyle: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: "Roboto-Light.ttf",
                        fontSize: 18),
                    hintText: hintText,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
