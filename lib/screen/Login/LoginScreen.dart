import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/OTPSetting/EmailOTPScreen.dart';
import 'package:project_1_btl/screen/Register/RegisterScreen.dart';
import 'package:project_1_btl/utils/constants.dart'; // Đảm bảo bạn đã định nghĩa ColorApp trong file này
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart'; // Thay đổi đường dẫn nếu bạn lưu CustomTextField ở vị trí khác

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình từ MediaQuery
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: ColorApp.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start, // Đảm bảo nội dung bắt đầu từ trên cùng
          children: [
            // Ảnh với width full dính trên cùng
            Container(
              width: width, // Chiều rộng đầy đủ của màn hình
              height: height * 0.3, // Chiều cao là 30% chiều cao màn hình
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image_food.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Text Login
            const Text(
              'Đăng nhập',
              style: TextStyle(
                color: ColorApp.brightOrangeColor,
                fontSize: 40, // Kích thước font cố định
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSansRegular', // Sử dụng font tùy chỉnh
              ),
            ),

            SizedBox(height: height * 0.03), // Khoảng cách theo tỉ lệ chiều cao màn hình
            // Enter Email
            CustomTextField(
              hintText: 'Email',
              icon: Icons.email,
              iconSize: width * 0.06, // Kích thước icon phụ thuộc vào chiều rộng
              hintColor: Colors.grey, background: ColorApp.whiteColor, height: 50,
            ),

            Divider(color: Colors.grey, height: 3,),
            // Enter Password
            CustomTextField(
              hintText: 'Mật khẩu',
              icon: Icons.lock,
              iconSize: width * 0.06, // Kích thước icon phụ thuộc vào chiều rộng
              hintColor: Colors.grey, background: ColorApp.whiteColor, height: 50,
              obscureText: true,
            ),

            Divider(color: Colors.grey, height: 3,),

            SizedBox(height: height * 0.06),

            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: InkWell(
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(
                      color: ColorApp.skyBlue,
                      fontSize: 20, // Kích thước font cố định
                      fontWeight: FontWeight.w600,
                      // Sử dụng font tùy chỉnh
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                )
              ),
            ),

            SizedBox(height: height * 0.06),

            // Nút Login
            InkWell(child: MyButton(size: size, title: "Đăng Nhập"), onTap: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
            },),
            SizedBox(height: height * 0.06),
            InkWell(
              child:Center(child: MyText(text: "Quên Mật Khẩu", size: 20, color: ColorApp.skyBlue, weight: FontWeight.w600),)
              ,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => EmailOTPScreen(size: size)));
              },
            )
          ],
        ),
      ),
    );
  }
}
