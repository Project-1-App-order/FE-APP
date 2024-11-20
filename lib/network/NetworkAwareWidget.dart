import 'dart:async';

//import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/Login/LoginScreen.dart';
import 'package:project_1_btl/screen/Main/HomeScreen.dart';
import 'package:project_1_btl/screen/Main/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkAwareWidget extends StatefulWidget {
  const NetworkAwareWidget({super.key});

  @override
  _NetworkAwareWidgetState createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  //late StreamSubscription<BatteryState> batterySubscription;
  bool isLoggedIn = false;
  List<ConnectivityResult> _connectionStatus = [];
  int batteryLevel = 100;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Kiểm tra trạng thái đăng nhập
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      setState(() {
        _connectionStatus = result;
      });
    });
    // batterySubscription =
    //     Battery().onBatteryStateChanged.listen((BatteryState state) {
    //   _checkBatteryLevel();
    // });

    _checkInitialConnectivity();
  }

  // Kiểm tra trạng thái kết nối ban đầu
  Future<void> _checkInitialConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectionStatus = connectivityResult;
    });
  }

  // Future<void> _checkBatteryLevel() async {
  //   batteryLevel = await Battery().batteryLevel;
  //   setState(() {});
  // }

  // Kiểm tra token trong SharedPreferences
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  bool isConnected() {
    return _connectionStatus.any((result) => result != ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          if (!isConnected()) {
            // Hiển thị giao diện khi mất mạng
            return Center(
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
                ],
              ),
            );
          }
          // else if (batteryLevel < 40) {
          //   // Hiển thị thông báo khi pin thấp
          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(Icons.battery_alert, size: 80, color: Colors.red),
          //         SizedBox(height: 20),
          //         Text(
          //           'Pin thấp: $batteryLevel%',
          //           style: TextStyle(fontSize: 20),
          //         ),
          //         SizedBox(height: 10),
          //         Text(
          //           'Vui lòng sạc pin để tiếp tục sử dụng ứng dụng.',
          //           textAlign: TextAlign.center,
          //         ),
          //       ],
          //     ),
          //   );
          // }
          else {
            // Kiểm tra trạng thái kết nối và hiển thị loại mạng
            final connectivityResult = _connectionStatus;
            String networkType = '';

            if (connectivityResult.contains(ConnectivityResult.mobile)) {
              networkType = 'Mobile network available.';
            } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
              networkType = 'Wi-fi is available.';
            } else if (connectivityResult
                .contains(ConnectivityResult.ethernet)) {
              networkType = 'Ethernet connection available.';
            } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
              networkType = 'Vpn connection active.';
            } else if (connectivityResult
                .contains(ConnectivityResult.bluetooth)) {
              networkType = 'Bluetooth connection available.';
            } else if (connectivityResult.contains(ConnectivityResult.other)) {
              networkType =
                  'Connected to a network which is not in the above mentioned networks.';
            } else if (connectivityResult.contains(ConnectivityResult.none)) {
              networkType = 'No available network types';
            }

            // Kiểm tra trạng thái đăng nhập khi có mạng
            if (isLoggedIn) {
              // Nếu có token, điều hướng đến trang chủ
              return MainScreen();
            } else {
              // Nếu không có token, điều hướng đến trang đăng nhập
              return LoginScreen();
            }
          }
        },
      ),
    );
  }
}
