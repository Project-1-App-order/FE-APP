import 'dart:ui';
import 'package:flutter/material.dart';

// Widget overlay tùy chỉnh để hiển thị icon và title
class CustomOverlayDialog extends StatelessWidget {
  final String title;
  final String image;

  // Constructor nhận title và image
  CustomOverlayDialog({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center, // Căn giữa overlay trong màn hình
      child: Material(
        color: Colors.transparent, // Màu nền trong suốt cho material
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Độ mờ của background
            child: Container(
              width: 320,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFC3C3C4),
                // Nền mờ với màu cam
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 4),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Điều chỉnh kích thước của Column
                crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa các phần tử
                children: [
                  Image.asset(
                    image,
                    width: 45,
                    height: 45,
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    title,
                    textAlign: TextAlign.center, // Căn giữa text
                    style: TextStyle(
                      fontFamily: "Roboto-Light.ttf",
                      fontWeight: FontWeight.w600,
                      color: Colors.black, // Màu chữ trắng
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Hàm hiển thị overlay
void showCustomDialog(BuildContext context, String title, String image) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: CustomOverlayDialog(title: title, image: image),
    ),
  );

  // Thêm overlay vào màn hình
  overlay.insert(overlayEntry);

  // Tự động đóng overlay sau 2 giây
  Future.delayed(Duration(seconds: 1), () {
    overlayEntry.remove(); // Xóa overlay sau 2 giây
  });
}
