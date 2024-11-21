import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_1_btl/blocs/Login/LoginBloc.dart';
import 'package:project_1_btl/blocs/Login/LoginEvent.dart';
import 'package:project_1_btl/blocs/Login/LoginState.dart';
import 'package:project_1_btl/blocs/Register/RegisterBloc.dart';
import 'package:project_1_btl/blocs/Register/RegisterState.dart';
import 'package:project_1_btl/screen/OTPSetting/EmailOTPScreen.dart';
import 'package:project_1_btl/screen/Register/RegisterScreen.dart';
import 'package:project_1_btl/screen/Main/MainScreen.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/CenterCircularProgress.dart';
import 'package:project_1_btl/widgets/CustomOverlayDialog.dart';
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/MyTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) {
    // Gửi sự kiện đăng nhập qua BLoC
    context.read<LoginBloc>().add(
      LoginSubmitted(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );

  }

  @override
  Widget build(BuildContext context)  {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: ColorApp.whiteColor,
      body: BlocListener<LoginBloc, LoginState>(listener: (context, state) async {
        if (state is LoginLoading) {
          // Hiển thị SnackBar khi đang đăng nhập
        } else if (state is LoginSuccess) {
          // Điều hướng tới trang chính nếu đăng nhập thành công

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),

          );

          //print('Token saved: ${state.message}');
        } else if (state is LoginFailure) {
          // Hiển thị lỗi nếu đăng nhập thất bại
          showCustomDialog(context, "${state.error}", "assets/images/error.png");
        }
      }, child:
      BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Ảnh trên cùng
              Container(
                margin: EdgeInsets.only(top: 40),
                width: width,
                height: height * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/foodlogo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Đăng nhập',
                style: TextStyle(
                  color: ColorApp.brightOrangeColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto-Light.ttf',
                ),
              ),
              SizedBox(height: height * 0.03),
              // TextField Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MyTextField(icon: Icons.email_outlined, hintText: "Email", controller: emailController, isPassword: false,),
              ),
              // TextField Password
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                child: MyTextField(icon: Icons.lock, hintText: "Mật khẩu", controller: passwordController,isPassword: true,),
              ),

              SizedBox(height: height * 0.06),
              // Đăng ký
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: InkWell(
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: ColorApp.skyBlue,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Roboto-Light.ttf"
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                    )),
              ),
              SizedBox(height: height * 0.06),
              // Nút đăng nhập
              state is LoginLoading
                  ? CenteredCircularProgress()
                  : InkWell(
                child: MyButton(size: size, title: "Đăng Nhập"),
                onTap: () {
                  _login(context); // Gọi hàm đăng nhập
                },
              ),
              SizedBox(height: height * 0.04),
              // Quên mật khẩu
              InkWell(
                child: Center(
                  child: MyText(
                    text: "Quên Mật Khẩu",
                    size: width * 0.06,
                    color: ColorApp.skyBlue,
                    weight: FontWeight.w600,

                  ),
                ),
                onTap: () {
                  // Xử lý quên mật khẩu
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmailOTPScreen(size: size)));
                },
              ),
            ],
          ),
        );
      })),
    );
  }
}

