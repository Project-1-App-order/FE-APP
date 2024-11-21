

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/Login/LoginScreen.dart';
import 'package:project_1_btl/screen/Main/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_1_btl/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Kiểm tra trạng thái đăng nhập
    await _checkLoginStatus();
    // Kiểm tra trạng thái kết nối Internet
    await _checkInitialConnectivity();

    // Chuyển sang màn hình phù hợp sau khi kiểm tra xong
    Timer(const Duration(seconds: 3), () {
      if (isConnected) {
        if (isLoggedIn) {
          // Nếu có token, điều hướng đến trang chính
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          // Nếu không có token, điều hướng đến trang đăng nhập
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } else {
        // Nếu không có kết nối mạng, hiển thị thông báo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NoInternetScreen()),
        );
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  Future<void> _checkInitialConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
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
              "assets/images/foodlogo.png",
              width: size.width,
              height: size.height * 0.4,
              fit: BoxFit.contain,
            ),
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
            SizedBox(height: 30),
            // Hiển thị trạng thái kết nối mạng
            // Text(
            //   isConnected ? "Đang kiểm tra đăng nhập..." : "Đang kiểm tra kết nối Internet...",
            //   style: TextStyle(fontSize: 16, color: Colors.grey),
            // ),
          ],
        ),
      ),
    );
  }
}

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Không có kết nối mạng',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Vui lòng kiểm tra kết nối internet của bạn.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              },
              child: Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
