import 'package:flutter/material.dart';

class TextFieldSearchHome extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final double iconSize;
  final Color hintColor;
  final Color background;
  final double height;

  const TextFieldSearchHome({
    required this.hintText,
    required this.icon,
    required this.iconSize,
    required this.hintColor,
    required this.background,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              icon,
              size: iconSize,
              color: hintColor,
            ),
          ),
          Expanded(
            child: Text(
              hintText,
              style: TextStyle(
                color: hintColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
