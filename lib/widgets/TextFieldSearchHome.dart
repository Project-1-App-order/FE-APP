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
      height: 40,
      child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF2F3F5),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            "Tìm Kiếm Đồ ăn / Thức uống", // Placeholder như trong TextFieldSearchHome
                            style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500, fontFamily: "Roboto-Light.ttf"),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Khi nhấn vào icon, cũng chuyển đến SearchScreen
                          },
                        )),
                  ],
                ),
              ),
            );
  }
}
