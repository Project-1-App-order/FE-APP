import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_1_btl/blocs/Register/RegisterBloc.dart';
import 'package:project_1_btl/blocs/Register/RegisterEvent.dart';
import 'package:project_1_btl/blocs/Register/RegisterState.dart';
import 'package:project_1_btl/screen/Login/LoginScreen.dart';
import 'package:project_1_btl/utils/constants.dart'; // Đảm bảo bạn đã định nghĩa ColorApp trong file này
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/CustomOverlayDialog.dart'; // Import overlay

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
                      fontFamily: 'OpenSansRegular',
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  // Trường email
                  CustomTextField(
                    controller: _emailController,  // Gắn controller
                    hintText: 'Email / Tên đăng nhập',
                    icon: Icons.email,
                    iconSize: width * 0.06,
                    hintColor: Colors.grey,
                    background: ColorApp.whiteColor,
                    height: 50,
                  ),
                  const Divider(color: ColorApp.lightGrayBeige, height: 1),
                  // Trường mật khẩu
                  CustomTextField(
                    controller: _passwordController,  // Gắn controller
                    hintText: 'Mật khẩu',
                    icon: Icons.lock,
                    iconSize: width * 0.06,
                    hintColor: Colors.grey,
                    background: ColorApp.whiteColor,
                    height: 50,
                    obscureText: true,
                  ),
                  const Divider(color: ColorApp.lightGrayBeige, height: 1),
                  // Trường xác nhận mật khẩu
                  CustomTextField(
                    controller: _confirmPasswordController,  // Gắn controller
                    hintText: 'Nhập lại Mật khẩu',
                    icon: Icons.lock,
                    iconSize: width * 0.06,
                    hintColor: Colors.grey,
                    background: ColorApp.whiteColor,
                    height: 50,
                    obscureText: true,
                  ),
                  const Divider(color: ColorApp.lightGrayBeige, height: 1),
                  SizedBox(height: height * 0.06),
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
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.06),
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
                          fontFamily: 'OpenSansRegular',
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Chính sách quy định của chúng tôi',
                            style: TextStyle(
                              color: ColorApp.skyBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSansRegular',
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
