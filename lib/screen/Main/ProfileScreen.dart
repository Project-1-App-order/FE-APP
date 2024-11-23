import 'package:flutter/material.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/screen/Login/LoginScreen.dart';
import 'package:project_1_btl/screen/Setting/SettingScreen.dart';
import 'package:project_1_btl/screen/UserSetting/UserInformationScreen.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/MyButton.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/SnackBarHelper.dart';
import '../../screen/item/ItemProfile.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository(AuthService());
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
                // Stack(
                //   children: [
                //     // Avatar
                //     Container(
                //       width: width * 0.15, // Set avatar size
                //       height: width * 0.15,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle, // Circle shape
                //         image: DecorationImage(
                //           image: AssetImage('assets/images/user.png'), // Avatar image path
                //           fit: BoxFit.cover, // Make image cover the whole circle
                //         ),
                //       ),
                //     ),
                //
                //     // Icon "v" at the bottom right
                //     Positioned(
                //       bottom: 0,
                //       right: 0,
                //       child: Container(
                //         width: 20, // Icon size
                //         height: 20,
                //         decoration: BoxDecoration(
                //           color: Colors.red, // Icon background color
                //           shape: BoxShape.circle, // Circle shape
                //           border: Border.all(
                //             color: Colors.white, // White border around the icon
                //             width: 2.0,
                //           ),
                //         ),
                //         child: const Icon(
                //           Icons.check, // Checkmark icon
                //           color: Colors.white,
                //           size: 16, // Icon size
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Stack(
                  children: [
                    // Kiểm tra tên người dùng để hiển thị ảnh hoặc chữ
                    FutureBuilder<Map<String, dynamic>>(
                      future: authRepository.getUserInformation(), // Fetch user info from API
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Loading state: Hiển thị biểu tượng avatar mặc định
                          return Container(
                            width: width * 0.15, // Set avatar size
                            height: width * 0.15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300, // Màu nền mặc định
                            ),
                            child: Center(
                              child: Icon(Icons.person, size: width * 0.1, color: Colors.grey),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          var userName = snapshot.data?['fullName']; // Lấy tên từ API
                          if (userName != null && userName.isNotEmpty) {
                            // Lấy chữ cái đầu tiên của từ cuối cùng
                            String initial = userName.split(' ').last.substring(0, 1).toUpperCase();

                            return Container(
                              width: width * 0.15,
                              height: width * 0.15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue, // Màu nền avatar
                              ),
                              child: Center(
                                child: Text(
                                  initial,
                                  style: TextStyle(
                                    fontSize: width * 0.08,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                        // Nếu không có dữ liệu hoặc lỗi, hiển thị ảnh mặc định
                        return Container(
                          width: width * 0.15,
                          height: width * 0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Icon(Icons.person, size: width * 0.1, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                    // Icon "v" ở góc dưới bên phải
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: width * 0.05),
                Expanded(
                  // Use FutureBuilder to fetch the user name from API
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: authRepository.getUserInformation(), // Fetch user info from API
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return MyText(
                          text: '', // Empty while waiting for the response
                          color: ColorApp.whiteColor,
                          size: 24,
                          weight: FontWeight.w600,
                        );
                      } else if (snapshot.hasData) {
                        var userName = snapshot.data?['fullName']; // Fetch name from API
                        return MyText(
                          text: userName ?? '', // If name is null, show empty string
                          color: ColorApp.whiteColor,
                          size: 24,
                          weight: FontWeight.w600,
                        );
                      } else {
                        return MyText(
                          text: '', // Empty if no data or error occurs
                          color: ColorApp.whiteColor,
                          size: 24,
                          weight: FontWeight.w600,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            child: ItemProfile(size: size, icon: Icons.info, title: "Thông tin người dùng"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserInformationScreen()));
            },
          ),
          SizedBox(height: 30),
          ItemProfile(size: size, icon: Icons.info, title: "Chính sách quy định"),
          InkWell(
            child: ItemProfile(size: size, icon: Icons.settings, title: "Cài đặt"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
            },
          ),
          ItemProfile(size: size, icon: Icons.fastfood, title: "Về Food App"),
          SizedBox(height: 270),
          InkWell(
            onTap: () async {
              try {
                // Call the logout API and remove the token
                await AuthService().logout();

                // Navigate back to the login screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              } catch (e) {
                // Handle logout error
                SnackBarHelper.showSimpleSnackBar(
                  context: context,
                  message: "Đăng xuất thất bại !",
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
