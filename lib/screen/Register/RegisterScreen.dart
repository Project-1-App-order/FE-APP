import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_1_btl/blocs/Register/RegisterBloc.dart';
import 'package:project_1_btl/blocs/Register/RegisterEvent.dart';
import 'package:project_1_btl/blocs/Register/RegisterState.dart';
import 'package:project_1_btl/screen/Login/LoginScreen.dart';
import 'package:project_1_btl/utils/constants.dart'; // Đảm bảo bạn đã định nghĩa ColorApp trong file này
import 'package:project_1_btl/widgets/CustomTextField.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/utils/constants.dart'; // Thay đổi đường dẫn nếu bạn lưu CustomTextField ở vị trí khác

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
    // Check if the passwords match
    if (_passwordController.text == _confirmPasswordController.text) {
      // Call the registration method using Bloc
      context.read<RegisterBloc>().add(RegisterSubmitted(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ));

      // Show a success message for password match

    } else {
      // Show an error message if passwords do not match
      Fluttertoast.showToast(
        msg: "Passwords do not match.",
        backgroundColor: Colors.red,
      );
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
          if (state is RegisterSuccess) {
            Fluttertoast.showToast(
              msg: "Registration successful!",
              backgroundColor: Colors.green,
            );
            // Navigate to the login screen
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          } else if (state is RegisterFailure) {
            Fluttertoast.showToast(
              msg: "${state.error}",
              backgroundColor: Colors.red,
            );
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Image at the top
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
                    'Đăng ký',
                    style: TextStyle(
                      color: ColorApp.brightOrangeColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSansRegular',
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  // Email field
                  CustomTextField(
                    controller: _emailController,  // Attach controller
                    hintText: 'Email / Tên đăng nhập',
                    icon: Icons.email,
                    iconSize: width * 0.06,
                    hintColor: Colors.grey,
                    background: ColorApp.whiteColor,
                    height: 50,
                  ),
                  const Divider(color: ColorApp.lightGrayBeige, height: 1),
                  // Password field
                  CustomTextField(
                    controller: _passwordController,  // Attach controller
                    hintText: 'Mật khẩu',
                    icon: Icons.lock,
                    iconSize: width * 0.06,
                    hintColor: Colors.grey,
                    background: ColorApp.whiteColor,
                    height: 50,
                    obscureText: true,
                  ),
                  const Divider(color: ColorApp.lightGrayBeige, height: 1),
                  // Confirm Password field
                  CustomTextField(
                    controller: _confirmPasswordController,  // Attach controller
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
                  // Register button
                  state is RegisterLoading
                      ? const CircularProgressIndicator()
                      : InkWell(
                      child: MyButton(
                        size: size,
                        title: "Đăng Ký",
                      ),
                      onTap: () {
                        _register(context);
                      }),
                  SizedBox(height: height * 0.06),
                  Padding(
                    padding: EdgeInsets.all(height * 0.02),
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

