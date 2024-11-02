import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorApp.whiteColor,
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(title),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  // Define the preferred size of the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

