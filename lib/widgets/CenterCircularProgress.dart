import 'package:flutter/material.dart';

class CenteredCircularProgress extends StatelessWidget {
  const CenteredCircularProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50.0, // Kích thước mặc định
        height: 50.0,
        child: CircularProgressIndicator(
          color: Colors.orange, // Màu mặc định
          strokeWidth: 4.0, // Độ dày đường
        ),
      ),
    );
  }
}
