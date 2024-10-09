import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorApp.whiteColor,
      title: Center(child: Text(title)),
      leading: Icon(Icons.arrow_back),
    );
  }

  // Define the preferred size of the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

