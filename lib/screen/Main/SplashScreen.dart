import 'package:flutter/material.dart';
import 'dart:async';

import 'package:project_1_btl/network/NetworkAwareWidget.dart';
import 'package:project_1_btl/utils/constants.dart'; // Thư viện để sử dụng Timer // Đảm bảo bạn đã có NetworkAwareWidget

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Khởi tạo Timer để chuyển trang sau 3 giây
    Timer(const Duration(seconds: 3), () {
      // Chuyển sang NetworkAwareWidget
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NetworkAwareWidget()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị ảnh từ assets
            Image.asset(
              "assets/images/foodlogo.png",  // Đảm bảo đường dẫn ảnh đúng
              width: size.width ,  // Điều chỉnh chiều rộng của ảnh
              height: size.height * 0.4,
              fit: BoxFit.contain,// Điều chỉnh chiều cao của ảnh
            ),
            // Text mô tả
            SizedBox(height: 50),
            Text(
              'Món ngon mỗi ngày, chỉ trong vòng tay',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "LobsterRegular",
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: ColorApp.brightOrangeColor,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
