// import 'package:flutter/material.dart';
//
// // Widget overlay tùy chỉnh để hiển thị icon và title
// class CustomOverlayDialog extends StatelessWidget {
//   final String title;
//   final IconData icon;
//
//   // Constructor nhận title và icon
//   CustomOverlayDialog({required this.title, required this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.center, // Căn giữa overlay trong màn hình
//       child: Material(
//         color: Colors.transparent, // Màu nền trong suốt cho material
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.6), // Nền đen mờ cho toàn bộ container
//             borderRadius: BorderRadius.circular(12.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black45,
//                 offset: Offset(0, 4),
//                 blurRadius: 6.0,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // Điều chỉnh kích thước của Column
//             crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa các phần tử
//             children: [
//               Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 30.0,
//               ),
//               SizedBox(height: 12.0),
//               Text(
//                 title,
//                 textAlign: TextAlign.center, // Căn giữa text
//                 style: TextStyle(
//                   color: Colors.white, // Màu chữ trắng
//                   fontSize: 18.0,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Hàm hiển thị overlay
// void showCustomDialog(BuildContext context, String title, IconData icon) {
//   final overlay = Overlay.of(context);
//   final overlayEntry = OverlayEntry(
//     builder: (context) => CustomOverlayDialog(title: title, icon: icon),
//   );
//
//   // Thêm overlay vào màn hình
//   overlay.insert(overlayEntry);
//
//   // Tự động đóng overlay sau 1 giây
//   Future.delayed(Duration(seconds: 1), () {
//     overlayEntry.remove(); // Xóa overlay sau 1 giây
//   });
// }

import 'package:flutter/material.dart';

// Widget overlay tùy chỉnh để hiển thị icon và title
class CustomOverlayDialog extends StatelessWidget {
  final String title;
  final IconData icon;

  // Constructor nhận title và icon
  CustomOverlayDialog({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center, // Căn giữa overlay trong màn hình
      child: Material(
        color: Colors.transparent, // Màu nền trong suốt cho material
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white, // Nền trắng cho widget nổi
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
              Icon(
                icon,
                color: Colors.black, // Màu icon đen
                size: 30.0,
              ),
              SizedBox(height: 12.0),
              Text(
                title,
                textAlign: TextAlign.center, // Căn giữa text
                style: TextStyle(
                  color: Colors.black, // Màu chữ đen
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hàm hiển thị overlay
void showCustomDialog(BuildContext context, String title, IconData icon) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Stack( // Sử dụng Stack để hiển thị overlay
      children: [
        // Background đen mờ cho toàn bộ overlay
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.6), // Màu nền đen mờ cho overlay
          ),
        ),
        // Nổi widget với nội dung tùy chỉnh
        CustomOverlayDialog(title: title, icon: icon),
      ],
    ),
  );

  // Thêm overlay vào màn hình
  overlay.insert(overlayEntry);

  // Tự động đóng overlay sau 1 giây
  Future.delayed(Duration(seconds: 1), () {
    overlayEntry.remove(); // Xóa overlay sau 1 giây
  });
}
