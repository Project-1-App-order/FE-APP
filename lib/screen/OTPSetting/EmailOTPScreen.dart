import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/OTPSetting/OTPScreen.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class EmailOTPScreen extends StatelessWidget {
  final Size size;
  const EmailOTPScreen({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Quên Mật Khẩu",),
      body: Column(
        children: [
          MyText(text: "Nhập email", size: 20, color: Colors.black, weight: FontWeight.w300),
          SizedBox(height: 20,),
          CustomTextField(hintText: "Nhập Email",icon: Icons.email, iconSize: 20, background: ColorApp.sageGray, hintColor: ColorApp.lightGrayBeige, height: 50),
          SizedBox(height:20,),
          InkWell(
            child: MyButton(size: size, title: "Tiếp tục"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(size: size,)));
            },
          )

        ],
      ),
    );
  }
}
