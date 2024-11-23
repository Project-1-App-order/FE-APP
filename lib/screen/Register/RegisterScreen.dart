import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_1_btl/blocs/Register/RegisterBloc.dart';
import 'package:project_1_btl/blocs/Register/RegisterEvent.dart';
import 'package:project_1_btl/blocs/Register/RegisterState.dart';
import 'package:project_1_btl/screen/Login/LoginScreen.dart';
import 'package:project_1_btl/utils/constants.dart'; // Đảm bảo bạn đã định nghĩa ColorApp trong file này
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/CustomOverlayDialog.dart';
import 'package:project_1_btl/widgets/MyTextField.dart'; // Import overlay

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register(BuildContext context) {

    if (_emailController.text == "" || _passwordController.text == "" || _passwordController.text == _confirmPasswordController.text) {
      // Gọi phương thức đăng ký qua Bloc
      context.read<RegisterBloc>().add(RegisterSubmitted(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ));
      //xet truong hop passwo
    }else if (_confirmPasswordController.text == "") {
      // Hiển thị thông báo lỗi với overlay
      showCustomDialog(context, "Hãy nhập lại mật khẩu!", "assets/images/error.png");
    } else {
      // Hiển thị thông báo lỗi với overlay
      showCustomDialog(context, "Mật khẩu không khớp.", "assets/images/error.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: ColorApp.whiteColor,
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if(state is RegisterLoading){

          }
          else if (state is RegisterSuccess) {
            // Hiển thị thông báo đăng ký thành công
            showCustomDialog(context, "Đăng ký thành công!", "assets/images/checked.png");
            // Chuyển hướng tới màn hình đăng nhập
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          } else if (state is RegisterFailure) {
            // Hiển thị thông báo lỗi với overlay
            showCustomDialog(context, "${state.error}", "assets/images/error.png");
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Hình ảnh ở trên
                  Container(
                    margin: EdgeInsets.only(top: 30),
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
                    'Đăng ký',
                    style: TextStyle(
                      color: ColorApp.brightOrangeColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto-Light.ttf',
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  // Trường email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),

                    child: MyTextField(icon: Icons.email_outlined, hintText: "Email", controller: _emailController, isPassword: false,),
                  ),
                  SizedBox(height: 10,),
                  // Trường mật khẩu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),

                    child: MyTextField(icon: Icons.lock, hintText: "Mật khẩu", controller: _passwordController,isPassword: true,),
                  ),
                  SizedBox(height: 10,),
                  // Trường xác nhận mật khẩu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),

                    child: MyTextField(icon: Icons.lock, hintText: "Nhập lại mật khẩu", controller: _confirmPasswordController,isPassword: true,),
                  ),

                  SizedBox(height: height * 0.03),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: InkWell(
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            color: ColorApp.skyBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto-Light.ttf"
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  // Nút đăng ký
                  InkWell(
                      child: MyButton(
                        size: size,
                        title: "Đăng Ký",
                      ),
                      onTap: () {
                        _register(context);
                      }),
                  SizedBox(height: height * 0.04),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'Bằng cách đăng nhập hoặc đăng ký, bạn đồng ý với ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto-Light.ttf',
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Chính sách quy định của chúng tôi',
                            style: TextStyle(
                              color: ColorApp.skyBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto-Light.ttf',
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
