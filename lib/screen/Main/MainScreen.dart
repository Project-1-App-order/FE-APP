import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/Main/CartScreen.dart';
import 'package:project_1_btl/screen/Main/CategoryScreen.dart';
import 'package:project_1_btl/screen/Main/HomeScreen.dart';
import 'package:project_1_btl/screen/Main/ProfileScreen.dart';
import 'package:project_1_btl/utils/constants.dart'; // Giả sử bạn đã định nghĩa ColorApp.brightOrangeColor ở đây

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Để theo dõi tab hiện tại

  final List<Widget> _screens =  [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật tab được chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex], // Hiển thị màn hình tương ứng với tab hiện tại
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Tab hiện tại
        onTap: _onItemTapped, // Xử lý sự kiện khi nhấn vào tab
        selectedItemColor: Colors.orange, // Màu của mục được chọn
        unselectedItemColor: Colors.black, // Màu của các mục chưa được chọn
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Danh mục',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Giỏ Hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tôi',
          ),
        ],
      ),
    );
  }
}