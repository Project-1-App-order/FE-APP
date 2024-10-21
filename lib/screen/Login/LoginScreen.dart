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
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';
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

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', state.message); // Save the token

          //print('Token saved: ${state.message}');
        } else if (state is LoginFailure) {
          // Hiển thị lỗi nếu đăng nhập thất bại
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
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
                width: width,
                height: height * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/image_food.jpg'),
                    fit: BoxFit.cover,
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
                  fontFamily: 'OpenSansRegular',
                ),
              ),
              SizedBox(height: height * 0.03),
              // TextField Email
              CustomTextField(
                controller: emailController,
                // Thêm controller
                hintText: 'Email',
                icon: Icons.email,
                iconSize: width * 0.06,
                hintColor: Colors.grey,
                background: ColorApp.whiteColor,
                height: 50,
              ),
              const Divider(color: Colors.grey, height: 1),
              // TextField Password
              CustomTextField(
                controller: passwordController,
                // Thêm controller
                hintText: 'Mật khẩu',
                icon: Icons.lock,
                iconSize: width * 0.06,
                hintColor: Colors.grey,
                background: ColorApp.whiteColor,
                height: 50,
                obscureText: true,
              ),
              const Divider(color: Colors.grey, height: 1),
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
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
                  ? const CircularProgressIndicator()
                  : InkWell(
                child: MyButton(size: size, title: "Đăng Nhập"),
                onTap: () {
                  _login(context); // Gọi hàm đăng nhập
                },
              ),
              SizedBox(height: height * 0.06),
              // Quên mật khẩu
              InkWell(
                child: Center(
                  child: MyText(
                    text: "Quên Mật Khẩu",
                    size: 20,
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

