import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/UserSetting/ChangePasswordScreen.dart';
import 'package:project_1_btl/screen/item/ItemProfile.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: MyAppBar(title: "Cài Đặt",),
      backgroundColor: Color(0xfff3f3f3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25 ,top: 10, bottom: 10),
            child: MyText(text: "CÀI ĐẶT TÀI KHOẢN", size: 17, color: Color(0xff6e6e6e), weight: FontWeight.w500),
          ),
          InkWell(child: ItemProfile(size: size, icon: null, title: "Mật Khẩu"),onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen(size: size,)));
          },),

          // Padding(
          //   padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
          //   child: MyText(text: "Hỗ Trợ", size: 17, color: Color(0xff6e6e6e), weight: FontWeight.w500),
          // ),
          // ItemProfile(size: size, icon: null, title: "Yêu cầu xóa tài khoản"),

        ],
      ),
    );
  }
}
