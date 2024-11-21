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
    // return Container(
    //   height: height,
    //   decoration: BoxDecoration(
    //     color: background,
    //     borderRadius: BorderRadius.circular(8.0),
    //   ),
    //   child: Row(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //         child: Icon(
    //           icon,
    //           size: iconSize,
    //           color: hintColor,
    //         ),
    //       ),
    //       Expanded(
    //         child: Text(
    //           hintText,
    //           style: TextStyle(
    //             color: hintColor,
    //             fontSize: 16,
    //             fontFamily: "Roboto-Light.ttf"
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Container(
      height: 40,
      child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.orange
                  ),
                    color: Colors.white,
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
                            color: Colors.orange,
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
