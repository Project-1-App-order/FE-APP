import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/Login/LoginScreen.dart';
import 'package:project_1_btl/screen/Setting/SettingScreen.dart';
import 'package:project_1_btl/screen/UserSetting/UserInformationScreen.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import '../../screen/item/ItemProfile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: ColorApp.whiteColor,
      body: Column(
        children: [
          Container(
            color: ColorApp.brightOrangeColor,
            height: height * 0.25,
            padding: EdgeInsets.only(left: width * 0.05, top: height * 0.1),
            child: Row(
              children: [
                Stack(
                  children: [
                    // Avatar
                    Container(
                      width: width * 0.2, // Đặt kích thước avatar
                      height: width * 0.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Hình dạng tròn
                        image: DecorationImage(
                          image: AssetImage('assets/images/image_food.jpg'), // Đường dẫn ảnh avatar
                          fit: BoxFit.cover, // Hiển thị ảnh toàn bộ trong vòng tròn
                        ),
                      ),
                    ),

                    // Icon "v" nhỏ ở góc dưới bên phải
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 25, // Kích thước của icon
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.red, // Màu nền của icon
                          shape: BoxShape.circle, // Hình tròn
                          border: Border.all(
                            color: Colors.white, // Viền màu trắng quanh icon
                            width: 2.0,
                          ),
                        ),
                        child: const Icon(
                          Icons.check, // Icon "v" hoặc dấu kiểm
                          color: Colors.white,
                          size: 16, // Kích thước của icon
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width * 0.05),
                Expanded(
                  child: MyText(
                    text: 'Nguyễn Văn A',
                    color: ColorApp.whiteColor,
                    size: 24,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          InkWell(child : ItemProfile(size: size, icon: Icons.info, title: "Thông tin người dùng"), onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserInformationScreen()));
          },),
          SizedBox(height: 30,),
          ItemProfile(size: size, icon: Icons.info, title: "Chính sách quy định"),
          InkWell(child: ItemProfile(size: size, icon: Icons.settings, title: "Cài đặt"), onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
          },),
          ItemProfile(size: size, icon: Icons.fastfood, title: "Về Food App"),
          SizedBox(height: 270,),
          InkWell(
            onTap: () async {
              try {
                // Call the logout API and remove the token
                await AuthService().logout();

                // Navigate back to the login screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              } catch (e) {
                // Handle logout error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${e.toString()}')),
                );
              }
            },
            child: MyButton(size: size, title: "Đăng Xuất"),
          ),
        ],
      ),
    );
  }
}
