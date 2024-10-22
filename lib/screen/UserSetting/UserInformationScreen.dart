import 'package:flutter/material.dart';
import 'package:project_1_btl/repository/AuthRepository.dart';
import 'package:project_1_btl/screen/item/ItemUserInfo.dart';
import 'package:project_1_btl/services/AuthService.dart';
import 'package:project_1_btl/widgets/MyAppBar.dart';

import '../../widgets/MyText.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final AuthRepository authRepository = AuthRepository(AuthService());
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    _loadUserInformation();
  }

  Future<void> _loadUserInformation() async {
    try {
      final userInfo = await authRepository.getUserInformation();
      setState(() {
        userNameController.text = userInfo['userName'] ?? '';
        phoneController.text = userInfo['phoneNumber'] ?? '';
        emailController.text = userInfo['email'] ?? '';
        addressController.text = userInfo['address'] ?? '';
        selectedGender = (userInfo['gender'] == 'Nam' || userInfo['gender'] == 'Nữ')
            ? userInfo['gender']
            : null;
      });
    } catch (error) {
      // Handle error when retrieving user information
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user information: $error')),
      );
    }
  }

  void _saveChanges() async {
    final updatedUserInfo = {
      'fullName': userNameController.text,
      'phoneNumber': phoneController.text,
      'email': emailController.text, // Ensure you don't update email if the server doesn't allow it
      'address': addressController.text,
      'gender': selectedGender ?? '',
    };

    try {
      final result = await authRepository.updateUserInformation(updatedUserInfo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    } catch (error) {
      // Handle error when saving user information
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save user information: $error')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Thông tin người dùng"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.2,
                    height: width * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/image_food.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      MyText(
                          text: "Đổi ảnh đại diện",
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w300),
                      SizedBox(width: 15),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              _buildTextFormField("Tên Đăng Nhập", userNameController),
              _buildTextFormField("Số Điện Thoại", phoneController),
              _buildTextFormField("Email", emailController),
              _buildGenderDropdown(), // Thêm phần dropdown giới tính
              _buildTextFormField("Địa Chỉ", addressController),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _saveChanges();
                },
                child: Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget cho Dropdown giới tính
  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Giới Tính',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: selectedGender,
              items: ['Nam', 'Nữ']
                  .map((gender) => DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}