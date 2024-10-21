import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:project_1_btl/screen/OTPSetting/ChangePasswordScreen.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';

class OTPScreen extends StatelessWidget {
  final Size size;
  const OTPScreen({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "OTP"),
      body: Column(
        children: [
          MyText(text: "Nhập mã OTP", size: 20, color: Colors.black, weight: FontWeight.w300),
          SizedBox(height: 20,),
          OtpTextField(
            numberOfFields: 6,
            borderColor: Color(0xFF512DA8),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode){
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Text("Verification Code"),
                      content: Text('Code entered is $verificationCode'),
                    );
                  }
              );
            }, // end onSubmit
          ),
          SizedBox(height: 20,),
          InkWell(child : MyButton(size: size, title: "Tiếp tục"),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen(size: size,)));
          },),
          SizedBox(height: 20,),
          MyText(text: "Gửi Lại", size: 20, color: Colors.black, weight: FontWeight.w300)
        ],
      ),
    );
  }
}
